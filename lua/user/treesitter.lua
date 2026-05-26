local parsers = {
  "lua",
  "markdown",
  "markdown_inline",
  "bash",
  "python",
  "c",
  "cpp",
  "typescript",
  "vim",
  "vimdoc",
  "json",
  "cmake",
  "query",
  "c_sharp",
}

local legacy_parsers = vim.list_extend(vim.deepcopy(parsers), {
  "norg",
  "org",
})

local highlight_disabled = {
  css = true,
  cmake = true,
}

local indent_disabled = {
  python = true,
  css = true,
  cmake = true,
}

local parser_by_filetype = {
  bash = "bash",
  c = "c",
  cmake = "cmake",
  cpp = "cpp",
  cs = "c_sharp",
  help = "vimdoc",
  json = "json",
  lua = "lua",
  markdown = "markdown",
  norg = "norg",
  org = "org",
  python = "python",
  query = "query",
  sh = "bash",
  typescript = "typescript",
  vim = "vim",
}

vim.g.skip_ts_context_commentstring_module = true
local context_ok, context = pcall(require, "ts_context_commentstring")
if context_ok then
  context.setup()
end

local function setup_textobjects_main()
  local textobjects_ok, textobjects = pcall(require, "nvim-treesitter-textobjects")
  if textobjects_ok and type(textobjects.setup) == "function" then
    textobjects.setup({
      select = {
        lookahead = true,
      },
      move = {
        set_jumps = true,
      },
    })
  end

  local select_ok, select = pcall(require, "nvim-treesitter-textobjects.select")
  if select_ok then
    local select_maps = {
      { "af", "@function.outer" },
      { "if", "@function.inner" },
      { "ac", "@class.outer" },
      { "ic", "@class.inner" },
      { "iC", "@comment.outer" },
      { "aC", "@comment.outer" },
      { "ib", "@block.inner" },
      { "ab", "@block.outer" },
      { "il", "@loop.inner" },
      { "al", "@loop.outer" },
      { "is", "@statement.outer" },
      { "as", "@statement.outer" },
    }

    for _, map in ipairs(select_maps) do
      vim.keymap.set({ "x", "o" }, map[1], function()
        select.select_textobject(map[2], "textobjects")
      end, { silent = true })
    end
  end

  local move_ok, move = pcall(require, "nvim-treesitter-textobjects.move")
  if move_ok then
    local move_maps = {
      { "]m", "goto_next_start", "@function.outer" },
      { "]]", "goto_next_start", "@function.outer" },
      { "]c", "goto_next_start", "@class.outer" },
      { "]M", "goto_next_end", "@function.outer" },
      { "][", "goto_next_end", "@function.outer" },
      { "]C", "goto_next_end", "@class.outer" },
      { "[m", "goto_previous_start", "@function.outer" },
      { "[[", "goto_previous_start", "@function.outer" },
      { "[c", "goto_previous_start", "@class.outer" },
      { "[M", "goto_previous_end", "@function.outer" },
      { "[]", "goto_previous_end", "@function.outer" },
      { "[C", "goto_previous_end", "@class.outer" },
    }

    for _, map in ipairs(move_maps) do
      vim.keymap.set({ "n", "x", "o" }, map[1], function()
        move[map[2]](map[3], "textobjects")
      end, { silent = true })
    end
  end
end

local function setup_main()
  local ts_ok, ts = pcall(require, "nvim-treesitter")
  if not ts_ok or type(ts.install) ~= "function" then
    return false
  end

  ts.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })

  local missing = {}
  local installed = {}
  if type(ts.get_installed) == "function" then
    for _, parser in ipairs(ts.get_installed()) do
      installed[parser] = true
    end
  end
  for _, parser in ipairs(parsers) do
    if not installed[parser] then
      table.insert(missing, parser)
    end
  end

  if #missing > 0 and vim.fn.executable("tree-sitter") == 1 then
    pcall(function()
      ts.install(missing)
    end)
  end

  setup_textobjects_main()

  local group = vim.api.nvim_create_augroup("user_treesitter", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = vim.tbl_keys(parser_by_filetype),
    callback = function(args)
      local parser = parser_by_filetype[vim.bo[args.buf].filetype]
      if not parser then
        return
      end

      if not highlight_disabled[parser] then
        pcall(vim.treesitter.start, args.buf, parser)
      end

      if not indent_disabled[parser] then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })

  return true
end

local function setup_legacy()
  local configs_ok, configs = pcall(require, "nvim-treesitter.configs")
  if not configs_ok then
    return
  end

  local legacy_highlight_disabled = { "css", "cmake" }
  if vim.fn.has("nvim-0.12") == 1 then
    vim.list_extend(legacy_highlight_disabled, { "markdown", "markdown_inline" })
  end

  configs.setup({
    ensure_installed = legacy_parsers,
    ignore_install = { "" },
    sync_install = false,

    highlight = {
      enable = true,
      disable = legacy_highlight_disabled,
    },
    autopairs = {
      enable = true,
    },
    indent = {
      enable = true,
      disable = { "python", "css", "cmake" },
    },

    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["iC"] = "@comment.outer",
          ["aC"] = "@comment.outer",
          ["ib"] = "@block.inner",
          ["ab"] = "@block.outer",
          ["il"] = "@loop.inner",
          ["al"] = "@loop.outer",
          ["is"] = "@statement.outer",
          ["as"] = "@statement.outer",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@function.outer",
          ["]c"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@function.outer",
          ["]C"] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@function.outer",
          ["[c"] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@function.outer",
          ["[C"] = "@class.outer",
        },
      },
      lsp_interop = {
        enable = true,
        floating_preview_opts = {
          border = "rounded",
          max_height = 50,
        },
        peek_definition_code = {
          ["Kf"] = "@function.outer",
          ["KF"] = "@function.outer",
          ["Kc"] = "@class.outer",
          ["KC"] = "@class.outer",
        },
      },
    },
  })
end

if not setup_main() then
  setup_legacy()
end
