local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

local lspkind_ok, lspkind = pcall(require, "lspkind")
if not lspkind_ok then
  return
end

require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

-- sources {{{

local cmp_sources = {
  { name = "nvim_lsp" },
  { name = "nvim_lsp_signature_help" },
  { name = "nvim_lua" },
  { name = "luasnip" },
  {
    name = "buffer",
    option = {
      get_bufnrs = function()
        return vim.api.nvim_list_bufs()
      end,
    },
  },
  { name = "path" },
  { name = "git" },
  { name = "vim-dadbod-completion" },
  -- { name = "copilot" },
  { name = "browser", keyword_length = 3, max_item_count = 10 },
  {
    name = "look",
    keyword_length = 3,
    max_item_count = 10,
    priority = -100,
    option = {
      convert_case = true,
      loud = true,
      dict = "/Users/lalo/git/English-Vocabulary-Word-List/Oxford 3000.txt",
    },
  },
}

local function cmp_toggle_source(src)
  local sources = cmp.get_config().sources
  for i = #sources, 1, -1 do
    if sources[i].name == src then
      table.remove(sources, i)
      cmp.setup.buffer({ sources = sources })
      vim.cmd("CmpStatus")
      return
    end
  end
  for _, s in ipairs(cmp_sources) do
    if s.name == src then
      table.insert(sources, s)
      cmp.setup.buffer({ sources = sources })
      vim.cmd("CmpStatus")
      return
    end
  end
end

-- }}}

-- add copilot to lspkind.lua
lspkind.init({
  symbol_map = {
    Copilot = "",
    TypeParameter = "",
  },
})
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "Green" })

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_active_entry() ~= nil then
        cmp.mapping.scroll_docs(-1)
      else
        fallback()
      end
    end),
    ["<C-j>"] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_active_entry() ~= nil then
        cmp.mapping.scroll_docs(1)
      else
        fallback()
      end
    end),
    ["<C-n>"] = cmp.mapping(function(_)
      if cmp.visible() then
        cmp.select_next_item()
      else
        cmp.complete()
      end
    end),
    ["<C-p>"] = cmp.mapping(function(_)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        cmp.complete()
      end
    end),
    ["<C-f>"] = cmp.mapping(function(fallback)
      local co_s = vim.fn["copilot#GetDisplayedSuggestion"]()
      if cmp.visible() and cmp.get_active_entry() ~= nil then
        -- accept cmp suggestion, and move cursor forward
        cmp.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }, function()
          local pos = vim.api.nvim_win_get_cursor(0)
          vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + 1 })
        end)
      elseif co_s.text ~= "" and co_s.text ~= nil then
        -- accept copilot suggestion, just next char
        local co_line = co_s.text:match(".-\n")
        if co_line == nil then
          co_line = co_s.text
        else
          co_line = co_line:sub(1, -2)
        end
        if co_line ~= "" then
          local pos = vim.api.nvim_win_get_cursor(0)[2]
          local line = vim.api.nvim_get_current_line()
          co_line = line:sub(0, pos) .. co_line:sub(0, 1)
          vim.api.nvim_set_current_line(co_line)
          vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], pos + 1 })
        else
          fallback()
        end
      else
        fallback()
      end
    end),
    ["<C-e>"] = cmp.mapping(function(fallback)
      local co_s = vim.fn["copilot#GetDisplayedSuggestion"]()
      if cmp.visible() and cmp.get_active_entry() ~= nil then
        -- accept cmp suggestion, and move cursor to end of line
        cmp.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }, function()
          local line = vim.api.nvim_get_current_line()
          vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], #line })
        end)
      elseif co_s.text ~= "" and co_s.text ~= nil then
        -- accept copilot suggestion, just current line
        local co_line = co_s.text:match(".-\n")
        if co_line == nil then
          co_line = co_s.text
        else
          co_line = co_line:sub(1, -2)
        end
        if co_line ~= "" then
          local pos = vim.api.nvim_win_get_cursor(0)[2]
          local line = vim.api.nvim_get_current_line()
          co_line = line:sub(0, pos) .. co_line
          vim.api.nvim_set_current_line(co_line)
          line = vim.api.nvim_get_current_line()
          vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], #line })
        else
          fallback()
        end
      else
        fallback()
      end
    end),
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      -- local co_s = vim.fn["copilot#GetDisplayedSuggestion"]()
      if cmp.visible() then
        if cmp.get_active_entry() ~= nil then
          cmp.confirm()
        else
          cmp.select_next_item()
          cmp.confirm()
        end
      -- don't do this, or can't input <tab> when copilot is suggesting
      -- elseif co_s.text ~= "" then
      -- 	local co_keys = vim.fn["copilot#Accept"]()
      -- 	if co_keys ~= "" then
      -- 		vim.api.nvim_feedkeys(co_keys, "i", true)
      -- 	else
      -- 		fallback()
      -- 	end
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end),
  }),
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = lspkind.cmp_format({
      mode = "symbol_text",
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function(entry, vim_item)
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          nvim_lua = "[Lua]",
          luasnip = "[Snip]",
          buffer = "[Buffer]",
          path = "[Path]",
          emoji = "[Emoji]",
          -- copilot = "[Copilot]",
          browser = "[Browser]",
          look = "[Look]",
          ["vim-dadbod-completion"] = "[Dadbod]",
        })[entry.source.name]
        return vim_item
      end,
    }),
  },
  sources = cmp_sources,
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  experimental = {
    ghost_text = false,
  },
})

-- `/` cmdline setup.
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = "nvim_lsp_document_symbol" } }, { { name = "buffer" } }),
})
-- `:` cmdline setup.
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = "path" } }, {
    {
      name = "cmdline",
      -- keyword_length = 2,
      option = {
        ignore_cmds = { "Man", "!" },
      },
    },
    -- {
    --   name = "cmdline_history",
    -- },
  }),
})

local format = require("cmp_git.format")
local sort = require("cmp_git.sort")

require("cmp_git").setup({
  -- defaults
  filetypes = { "gitcommit", "toggleterm", "octo" },
  remotes = { "upstream", "origin" }, -- in order of most to least prioritized
  enableRemoteUrlRewrites = false, -- enable git url rewrites, see https://git-scm.com/docs/git-config#Documentation/git-config.txt-urlltbasegtinsteadOf
  git = {
    commits = {
      limit = 100,
      sort_by = sort.git.commits,
      format = format.git.commits,
    },
  },
  trigger_actions = {
    {
      debug_name = "git_commits",
      trigger_character = ":",
      action = function(sources, trigger_char, callback, params, git_info)
        return sources.git:get_commits(callback, params, trigger_char)
      end,
    },
  },
})

M = {
  cmp_toggle_source = cmp_toggle_source,
}
return M
