-- Setup nvim-cmp.
local status_ok, npairs = pcall(require, "nvim-autopairs")
if not status_ok then
  return
end

npairs.setup({
  check_ts = true, -- treesitter integration
  disable_filetype = { "TelescopePrompt" },
  ts_config = {
    lua = { "string", "source" },
    javascript = { "string", "template_string" },
    java = false,
  },
  map_c_w = true,
  fast_wrap = {
    map = "<C-]>",
    chars = { "{", "[", "(", '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
    offset = 0, -- Offset from pattern match
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "PmenuSel",
    highlight_grey = "LineNr",
  },
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end
-- https://github.com/windwp/nvim-autopairs
cmp.event:on(
  "confirm_done",
  cmp_autopairs.on_confirm_done({
    filetypes = {
      cmake = {
        ["("] = {
          kind = {
            cmp.lsp.CompletionItemKind.Function,
          },
          handler = function(char, item, bufnr, rules, commit_character)
            vim.cmd("normal hl")
          end,
        },
      },
    },
  })
)
