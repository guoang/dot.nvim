local colorscheme = "tokyonight"

-- setup for nord
vim.g.nord_contrast = true
vim.g.nord_italic = false
vim.g.nord_bold = false
vim.g.nord_uniform_diff_background = true
if colorscheme == "nord" then
  require('nord').set()
end

local function post_process()
  vim.cmd("hi! link Folded Comment")
  if vim.g.colors_name == "sonokai" then
    -- distinguish from illuminate highlight
    vim.cmd("hi Visual cterm=bold gui=bold guibg=#3b4a5e")
    -- make a darker bg
    vim.cmd("hi Normal guibg=#292b2f")
    vim.cmd("hi NormalNC guibg=#292b2f")
    vim.cmd("hi EndOfBuffer guibg=#292b2f")
  end

  if vim.g.colors_name == "tokyonight" then
    local c = require("tokyonight.colors")
    c.default.fg = "#aab1d3"
    vim.cmd("hi NvimTreeNormal guifg=#aab1d3")
    vim.cmd("hi @variable guifg=#aab1d3")
    vim.cmd("hi @variable.member guifg=#aab1d3")
    vim.cmd("hi link NVimTreeExecFile TSRainbowGreen")
    vim.cmd("hi NVimTreeSymlink guifg=#90cdfa")
    vim.cmd("hi NVimTreeSymlinkFolderName guifg=#90cdfa")
    vim.cmd("hi NVimTreeSymlinkFolderIcon guifg=#90cdfa")
    -- vim.cmd("hi Type guifg=#29a4bd")  -- same as builtin
    vim.cmd("hi DiagnosticUnnecessary guifg=#565f89")
    vim.cmd("hi String guifg=#8ebe6a")
    vim.cmd("hi IblScope guifg=#b69bf1")
  end

  -- for alpha
  vim.cmd("hi! link AlphaSubTitle SpecialComment")
  vim.cmd("hi! link AlphaKeymapShortcut Label")
  vim.cmd("hi! link AlphaMru Constant")
  vim.cmd("hi! link AlphaDashboard Function")

  -- for telescope
  -- require("user.telescope_color").set_telescope_color()

  -- for aerial
  vim.cmd("hi link AerialLine Visual")
end

-- setup post process
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  callback = function()
    post_process()
  end,
})

-- set background color for specific windows
local target_filetypes = {
  "copilot-chat",
  "codecompanion",
  "qf",
  "aerial",
  "Outline",
  "Trouble",
  "help",
}
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = "*",
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if vim.tbl_contains(target_filetypes, ft) then
      vim.wo.winhl = "Normal:NvimTreeNormal,EndOfBuffer:NvimTreeEndOfBuffer"
    end
  end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = target_filetypes,
  callback = function()
    vim.wo.winhl = "Normal:NvimTreeNormal,EndOfBuffer:NvimTreeEndOfBuffer"
  end,
})

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end

vim.cmd("colorscheme " .. colorscheme)
