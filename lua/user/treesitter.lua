local status_ok, _ = pcall(require, "nvim-treesitter")
if not status_ok then
  return
end

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

vim.g.skip_ts_context_commentstring_module = true
require('ts_context_commentstring').setup()

configs.setup({
  ensure_installed = {
    "lua",
    "markdown",
    "markdown_inline",
    "bash",
    "python",
    "c",
    "cpp",
    "typescript",
    "vim",
    "json",
    "cmake",
    "query",
    "norg",
    "org",
    "c_sharp"
  }, -- put the language you want in this array
  -- ensure_installed = "all", -- one of "all" or a list of languages
  ignore_install = { "" }, -- List of parsers to ignore installing
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)

  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "css", "cmake" }, -- list of language that will be disabled
  },
  autopairs = {
    enable = true,
  },
  indent = { enable = true, disable = { "python", "css" } },

  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["iC"] = "@comment.outer", -- no inner
        ["aC"] = "@comment.outer",
        ["ib"] = "@block.inner",
        ["ab"] = "@block.outer",
        ["il"] = "@loop.inner",
        ["al"] = "@loop.outer",
        ["is"] = "@statement.outer", -- no inner
        ["as"] = "@statement.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
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

for _, l in ipairs({ "python" }) do
  vim.treesitter.query.set(
    l,
    "folds",
    [[
      (function_definition (block) @fold)
    ]]
  )
end

for _, l in ipairs({ "lua" }) do
  vim.treesitter.query.set(
    l,
    "folds",
    [[
      (function_declaration (block) @fold)
      (function_definition (block) @fold)
    ]]
  )
end

for _, l in ipairs({ "cpp", "c" }) do
  vim.treesitter.query.set(
    l,
    "folds",
    [[
      (function_definition (compound_statement) @fold)
    ]]
  )
end

for _, l in ipairs({ "cmake" }) do
  vim.treesitter.query.set(
    l,
    "folds",
    [[
      (function_def) @fold
    ]]
  )
end
