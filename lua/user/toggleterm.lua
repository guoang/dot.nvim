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
    Normal = {
      link = "NvimTreeNormal",
    },
    NormalFloat = {
      link = "NvimTreeNormal",
    },
  },
  direction = "horizontal",
  open_mapping = [[<c-\>]],
  float_opts = {
    border = "none",
  },
  on_create = function(_)
    vim.cmd("set nocursorline")
    vim.cmd("set guicursor=a:ver90")
  end,
  on_open = function(_)
    vim.cmd("set nocursorline")
    vim.cmd("set guicursor=a:ver90")
  end,
  on_close = function(_)
    vim.cmd("set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20")
  end,
  on_exit = function(_, _, _, _)
    vim.cmd("set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20")
  end,
})

local M = {}
local Terminal = require("toggleterm.terminal").Terminal

function M.lazygit()
  Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" }):toggle()
end

function M.python()
  Terminal:new({ cmd = "~/work/block/trunk/server/bin/python3", hidden = true, direction = "float" }):toggle()
end

return M
