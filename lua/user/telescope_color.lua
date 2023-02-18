local M = {}

function M.set_telescope_color()
  local colors = require("catppuccin.palettes").get_palette()
  local nvim_tree = vim.api.nvim_get_hl_by_name("NvimTreeNormal", true).background
  local cursor_line = vim.api.nvim_get_hl_by_name("CursorLine", true).background
  local TelescopeColor = {
    TelescopeMatching = { fg = colors.flamingo },
    TelescopeSelection = { fg = colors.text, bg = cursor_line, bold = true },
    TelescopePromptPrefix = { bg = cursor_line, },
    TelescopePromptNormal = { bg = cursor_line, },
    TelescopePromptBorder = { bg = cursor_line, fg = cursor_line },
    TelescopePromptTitle = { bg = colors.pink, fg = colors.mantle },
    TelescopeResultsNormal = { bg = nvim_tree },
    TelescopeResultsBorder = { bg = nvim_tree, fg = nvim_tree },
    TelescopeResultsTitle = { fg = colors.mantle },
    TelescopePreviewNormal = { bg = nvim_tree },
    TelescopePreviewBorder = { bg = nvim_tree, fg = nvim_tree },
    TelescopePreviewTitle = { bg = colors.green, fg = colors.mantle },
  }
  for hl, col in pairs(TelescopeColor) do
    vim.api.nvim_set_hl(0, hl, col)
  end
end

return M
