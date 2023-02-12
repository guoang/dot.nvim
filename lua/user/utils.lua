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
  -- return current bufnr
  return vim.fn.bufnr()
end

function M.get_winnr(filter)
  local bufnr = M.get_bufnr(filter)
  return vim.fn.bufwinnr(bufnr)
end

function M.get_winid(filter)
  local bufnr = M.get_bufnr(filter)
  return vim.fn.bufwinid(bufnr)
end

function M.set_winhl(filter, winhl)
  vim.wo[M.get_winid(filter)].winhl = winhl
end

function M.set_winhl_nvimtree(filter)
  M.set_winhl(filter, require("nvim-tree.view").View.winopts.winhl)
end

return M
