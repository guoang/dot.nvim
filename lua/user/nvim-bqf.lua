local status_ok, bqf = pcall(require, "bqf")
if not status_ok then
  return
end

bqf.setup({
  func_map = {
    pscrollup = "",
    pscrolldown = "",
  }
})

local function scroll(direction)
  local pvs = require('bqf.preview.session')
  local pvh = require('bqf.preview.handler')
  if pvs.validate() then
    pvh.scroll(direction)
  else
    if direction > 0 then
      vim.cmd(vim.api.nvim_replace_termcodes("normal 10j", true, false, true))
    else
      vim.cmd(vim.api.nvim_replace_termcodes("normal 10k", true, false, true))
    end
  end
end

M = {scroll = scroll}
return M
