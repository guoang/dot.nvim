local opts = {
  capabilities = {
    offsetEncoding = "utf-8",
  },
  cmd = {
    "clangd",
    "--header-insertion-decorators=false",
    "--header-insertion=never",
  },
}

return opts
