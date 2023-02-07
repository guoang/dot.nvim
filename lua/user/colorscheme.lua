local colorscheme = "sonokai"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end

if colorscheme == "sonokai" then
  -- distinguish from illuminate highlight
  pcall(vim.cmd, "highlight Visual cterm=bold gui=bold guibg=#3b4a5e")
end

vim.cmd("highlight Normal guibg=none ctermbg=none")
