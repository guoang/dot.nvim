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
	Copilot = "",

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
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-b>"] = cmp.mapping(function(fallback)
			if cmp.visible() and cmp.get_active_entry() ~= nil then
				cmp.mapping.scroll_docs(-1)
			else
				fallback()
			end
		end, { "i", "c" }),
		["<C-f>"] = cmp.mapping(function(fallback)
			if cmp.visible() and cmp.get_active_entry() ~= nil then
				cmp.mapping.scroll_docs(1)
			else
				fallback()
			end
		end, { "i", "c" }),
    ["<C-e>"] = cmp.mapping({
      i = function(fallback)
        local co_s = vim.fn["copilot#GetDisplayedSuggestion"]()
        cmp.mapping.abort()
        if co_s.text ~= "" then
          local co_keys = vim.fn["copilot#Accept"]()
          if co_keys ~= "" then
            vim.api.nvim_feedkeys(co_keys, "i", true)
          else
            fallback()
          end
        else
          fallback()
        end
      end,
      c = function(fallback)
        local co_s = vim.fn["copilot#GetDisplayedSuggestion"]()
        cmp.mapping.close()
        if co_s.text ~= "" then
          local co_keys = vim.fn["copilot#Accept"]()
          if co_keys ~= "" then
            vim.api.nvim_feedkeys(co_keys, "i", true)
          else
            fallback()
          end
        else
          fallback()
        end
      end
    }),
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			local co_s = vim.fn["copilot#GetDisplayedSuggestion"]()
			if cmp.visible() then
				if cmp.get_active_entry() ~= nil then
					cmp.confirm()
				else
					cmp.select_next_item()
					cmp.confirm()
				end
			elseif co_s.text ~= "" then
				local co_keys = vim.fn["copilot#Accept"]()
				if co_keys ~= "" then
					vim.api.nvim_feedkeys(co_keys, "i", true)
				else
					fallback()
				end
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

M = {
	cmp_toggle_source = cmp_toggle_source,
}
return M
