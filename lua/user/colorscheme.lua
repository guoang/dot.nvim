local colorscheme = "sonokai"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end

vim.cmd("hi link illuminatedWord LspReferenceText")
vim.cmd("hi! link Folded Comment")

if colorscheme == "sonokai" then
  -- distinguish from illuminate highlight
  vim.cmd("highlight Visual cterm=bold gui=bold guibg=#3b4a5e")
end
