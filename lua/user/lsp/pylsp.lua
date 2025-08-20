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
    -- 关闭补全功能
    client.server_capabilities.completionProvider = nil
    -- 关闭跳转（定义/类型定义）
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.typeDefinitionProvider = false
  end
})
