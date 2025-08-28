vim.lsp.config('clangd', {
  cmd = {
    "clangd",
    "--header-insertion-decorators=false",
    "--header-insertion=never",
  },
  capabilities = {
    offsetEncoding = 'utf-8',
  },
})

local prev_on_attach = vim.lsp.config.clangd.on_attach

vim.lsp.config('clangd', {
  on_attach = function(client, bufnr)
    if prev_on_attach then
      prev_on_attach(client, bufnr)
    end
    vim.api.nvim_buf_create_user_command(bufnr, 'A', 'LspClangdSwitchSourceHeader',
      { desc = 'Switch between source/header' })
  end,
})
