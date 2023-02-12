local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  return
end

toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  highlights = {
    NormalFloat = {
      link = "NvimTreeNormal",
    },
  },
  direction = "float",
  open_mapping = [[<c-\>]],
  float_opts = {
    border = "none",
  },
  on_open = function(_, _, _, _)
    vim.cmd("set nocursorline")
  end,
})

local M = {}
local Terminal = require("toggleterm.terminal").Terminal

function M.lazygit()
  Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" }):toggle()
end

function M.python()
  Terminal:new({ cmd = "~/work/xbuild/install/RelWithDebInfo/Darwin-x86_64/xsolution/bin/python3", hidden = true, direction = "float" }):toggle()
end

return M
