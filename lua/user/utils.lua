local M = {}

function M.get_bufnr(filter)
  if filter ~= nil then
    local ft = filter.filetype
    local bn = filter.bufname
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      local filetype = vim.bo[bufnr].filetype
      local bn_match = true
      if bn ~= nil and not bufname:match(bn) then
        bn_match = false
      end
      local ft_match = true
      if ft ~= nil and ft ~= filetype then
        ft_match = false
      end
      if bn_match and ft_match then
        return bufnr
      end
    end
  end
end

function M.get_winnr(filter)
  local bufnr = M.get_bufnr(filter)
  if bufnr == nil then
    return -1
  end
  return vim.fn.bufwinnr(bufnr)
end

function M.get_winid(filter)
  local bufnr = M.get_bufnr(filter)
  if bufnr == nil then
    return -1
  end
  return vim.fn.bufwinid(bufnr)
end

function M.is_qf_open()
  return M.get_winnr({ filetype = "qf" }) ~= -1
end

-- switch spell checking
function M.toggle_qf()
  if not require('user.utils').is_qf_open() then
    vim.cmd("copen")
  else
    vim.cmd("cclose")
  end
end

function M.move_to_window_right()
  -- Try to move to the right window, if it fails, try to move to zellij right pane
  local old_bufnr = vim.api.nvim_get_current_buf()
  vim.cmd.wincmd('l')
  local new_bufnr = vim.api.nvim_get_current_buf()
  if old_bufnr == new_bufnr then
    vim.fn.system("zellij action move-focus right")
  end
end

function M.move_to_window_left()
  -- Try to move to the left window, if it fails, try to move to zellij left pane
  local old_bufnr = vim.api.nvim_get_current_buf()
  vim.cmd.wincmd('h')
  local new_bufnr = vim.api.nvim_get_current_buf()
  if old_bufnr == new_bufnr then
    vim.fn.system("zellij action move-focus left")
  end
end

function M.move_to_window_up()
  -- Try to move to the upper window, if it fails, try to move to zellij upper pane
  local old_bufnr = vim.api.nvim_get_current_buf()
  vim.cmd.wincmd('k')
  local new_bufnr = vim.api.nvim_get_current_buf()
  if old_bufnr == new_bufnr then
    vim.fn.system("zellij action move-focus up")
  end
end

function M.move_to_window_down()
  -- Try to move to the down window, if it fails, try to move to zellij down pane
  local old_bufnr = vim.api.nvim_get_current_buf()
  vim.cmd.wincmd('j')
  local new_bufnr = vim.api.nvim_get_current_buf()
  if old_bufnr == new_bufnr then
    vim.fn.system("zellij action move-focus down")
  end
end

return M
