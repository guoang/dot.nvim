local colors = require("catppuccin.palettes").get_palette()
local bg = vim.api.nvim_get_hl_by_name("NvimTreeNormal", true).background
local TelescopeColor = {
  TelescopeMatching = { fg = colors.flamingo },
  TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },
  TelescopePromptPrefix = { bg = colors.surface0 },
  TelescopePromptNormal = { bg = colors.surface0 },
  TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
  TelescopePromptTitle = { bg = colors.pink, fg = colors.mantle },
  TelescopeResultsNormal = { bg = bg },
  TelescopeResultsBorder = { bg = bg, fg = bg },
  TelescopeResultsTitle = { fg = colors.mantle },
  TelescopePreviewNormal = { bg = bg },
  TelescopePreviewBorder = { bg = bg, fg = bg },
  TelescopePreviewTitle = { bg = colors.green, fg = colors.mantle },
}
for hl, col in pairs(TelescopeColor) do
  vim.api.nvim_set_hl(0, hl, col)
end
