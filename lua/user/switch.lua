-- plugin Switch
vim.g.switch_mapping = ""
vim.g.switch_custom_definitions = {
  vim.fn["switch#NormalizedCaseWords"]({ 'foo', 'bar', 'baz' }),
}

M = {}

-- switch colorcolumn
local function switch_column()
  if vim.api.nvim_get_option_value("colorcolumn", { scope = "local" }) ~= "80" then
    vim.opt_local.colorcolumn = "80"
  else
    vim.opt_local.colorcolumn = ""
  end
end

--switch diagnostic visible
local function switch_diagnostic()
  local status, v = pcall(vim.api.nvim_buf_get_var, 0, "switch_diagnostic_status")
  if not status or v == "enable" then
    vim.api.nvim_buf_set_var(0, "switch_diagnostic_status", "disable")
    vim.diagnostic.disable()
  else
    vim.api.nvim_buf_set_var(0, "switch_diagnostic_status", "enable")
    vim.diagnostic.enable()
  end
end

-- switch spell checking
local function switch_spell_check()
  local status, v = pcall(vim.api.nvim_buf_get_var, 0, "switch_spell_check_status")
  if not status or v == "disable" then
    vim.api.nvim_buf_set_var(0, "switch_spell_check_status", "enable")
    vim.opt_local.spell = true
  else
    vim.api.nvim_buf_set_var(0, "switch_spell_check_status", "disable")
    vim.opt_local.spell = false
  end
end

M.switch_column = switch_column
M.switch_diagnostic = switch_diagnostic
M.switch_spell_check = switch_spell_check

return M
