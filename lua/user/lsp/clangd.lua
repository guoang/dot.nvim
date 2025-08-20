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
