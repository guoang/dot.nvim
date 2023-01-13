local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

toggleterm.setup({
	size = 20,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
	},
  on_open = function(t, job, data, name)
    local cmd = "set winhl="
    cmd = cmd .. "EndOfBuffer:NvimTreeEndOfBuffer,Normal:NvimTreeNormal,"
    cmd = cmd .. "CursorLine:NvimTreeCursorLine,CursorLineNr:NvimTreeCursorLineNr,"
    cmd = cmd .. "WinSeparator:NvimTreeWinSeparator,StatusLine:NvimTreeStatusLine,"
    cmd = cmd .. "StatusLineNC:NvimTreeStatuslineNC,SignColumn:NvimTreeSignColumn,"
    cmd = cmd .. "NormalNC:NvimTreeNormalNC"
    vim.cmd(cmd)
  end,
})

local Terminal = require("toggleterm.terminal").Terminal

function tterm_lazygit()
	Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" }):toggle()
end
