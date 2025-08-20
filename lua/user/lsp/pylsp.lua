vim.lsp.config('pylsp', {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          maxLineLength = 120,
        },
        mccabe = {
          enabled = false,
        },
        rope_autoimport = {
          enabled = false,
        },
        autopep8 = {
          enabled = false, -- use yapf
        }
      },
    },
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.completionProvider = false
  end
})
