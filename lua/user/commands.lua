-- write a command to open file in vscode
-- 接受一个可选参数, 指定要打开的文件路径, 如果没有指定, 则打开当前编辑的文件
vim.api.nvim_create_user_command('Vscode', function(opts)
  local filepath
  if opts.args ~= '' then
    filepath = vim.fn.fnamemodify(opts.args, ':p')
  else
    filepath = vim.fn.expand('%:p')
  end

  if filepath == '' then
    print('No file to open in VSCode')
    return
  end

  local cmd = 'code "' .. filepath .. '"'
  vim.fn.system(cmd)
  print('Opened ' .. filepath .. ' in VSCode')
end, { nargs = '?' })
