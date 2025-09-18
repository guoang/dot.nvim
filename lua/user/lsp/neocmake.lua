vim.lsp.config('neocmake', {
  default_config = {
    init_options = {
      format = { enable = true, },
      lint = { enable = true, },
    },
  }
})
