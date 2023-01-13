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
	direction = "float",
  open_mapping = [[<c-\>]],
	float_opts = {
		border = "curved",
	},
  on_open = function(term, job, data, name)
    vim.cmd("set nocursorline")
  end
})

local Terminal = require("toggleterm.terminal").Terminal

function tterm_lazygit()
  Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" }):toggle()
end
