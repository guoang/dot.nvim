local colors = require("catppuccin.palettes").get_palette()
local bg1 = vim.api.nvim_get_hl_by_name("Normal", true).background
local bg2 = vim.api.nvim_get_hl_by_name("NvimTreeNormal", true).background
local TelescopeColor = {
  TelescopeMatching = { fg = colors.flamingo },
  TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },
  TelescopePromptPrefix = { bg = colors.surface0 },
  TelescopePromptNormal = { bg = colors.surface0 },
  TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
  TelescopePromptTitle = { bg = colors.pink, fg = colors.mantle },
  TelescopeResultsNormal = { bg = bg2 },
  TelescopeResultsBorder = { bg = bg2, fg = bg2 },
  TelescopeResultsTitle = { fg = colors.mantle },
  TelescopePreviewNormal = { bg = bg2 },
  TelescopePreviewBorder = { bg = bg2, fg = bg2 },
  TelescopePreviewTitle = { bg = colors.green, fg = colors.mantle },
}
for hl, col in pairs(TelescopeColor) do
  vim.api.nvim_set_hl(0, hl, col)
end
