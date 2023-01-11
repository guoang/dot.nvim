local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

-- {{{ icons

local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
	Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
	TypeParameter = "",
	-- Text = "",
	-- Method = "",
	-- Function = "",
	-- Constructor = "",
	-- Field = "",
	-- Variable = "",
	-- Class = "",
	-- Interface = "",
	-- Module = "",
	-- Property = "",
	-- Unit = "",
	-- Value = "",
	-- Enum = "",
	-- Keyword = "",
	-- Color = "",
	-- File = "",
	-- Reference = "",
	-- Folder = "",
	-- EnumMember = "",
	-- Constant = "",
	-- Struct = "",
	-- Event = "",
	-- Operator = "",
}
-- }}}

-- sources {{{

local cmp_sources = {
  { name = "nvim_lsp" },
  { name = "nvim_lua" },
  { name = "luasnip" },
  { name = "buffer" },
  { name = "path" },
  { name = "copilot" },
  { name = "browser" },
  { name = "look", keyword_length = 2, option = { convert_case = true, loud = true, }},
  { name = "vim-dadbod-completion" }
}

local function cmp_toggle_source(src)
  -- ftplugin/haskell.lua
  local sources = cmp.get_config().sources
  for i = #sources, 1, -1 do
    if sources[i].name == src then
      table.remove(sources, i)
      cmp.setup.buffer({ sources = sources })
      vim.cmd("CmpStatus")
      return
    end
  end
  table.insert(sources, {name = src})
  cmp.setup.buffer({ sources = sources })
  vim.cmd("CmpStatus")
end

-- }}}

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-j>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-k>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
        "i",
        "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
        "i",
        "s",
    }),
  }),
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = function(entry, vim_item)
      vim_item.kind = string.format('    %s %s', kind_icons[vim_item.kind], vim_item.kind)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        nvim_lua = "[Lua]",
        luasnip = "[Snip]",
        buffer = "[Buffer]",
        path = "[Path]",
        emoji = "[Emoji]",
        copilot = "[Copilot]",
        browser = "[Browser]",
        look = "[Look]",
        ["vim-dadbod-completion"] = "[Dadbod]",
      })[entry.source.name]
      return vim_item
    end,
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
    ghost_text = true,
  },
})

M = {
  cmp_toggle_source = cmp_toggle_source,
}
return M
