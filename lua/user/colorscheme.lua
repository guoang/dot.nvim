local colorscheme = "sonokai"

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
    vim.cmd("highlight Visual cterm=bold gui=bold guibg=#3b4a5e")
  end
end

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  callback = function()
    post_process()
  end,
})

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end

vim.cmd("colorscheme " .. colorscheme)
