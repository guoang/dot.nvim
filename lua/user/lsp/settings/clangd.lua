local opts = {
  capabilities = {
    offsetEncoding = "utf-8",
  },
  cmd = {
    "clangd",
    "--header-insertion-decorators=false",
  },
}

return opts
