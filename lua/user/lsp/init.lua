local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "user.lsp.null-ls"
require "user.lsp.mason"

-- 每个 vim.lsp.config['xxx'] = {} 所设置的配置,
-- 会和 vim.lsp.config 中的原始配置合并, 同名字段会覆盖
require "user.lsp.pyright"
require "user.lsp.clangd"
require "user.lsp.jsonls"
require "user.lsp.lua_ls"
require "user.lsp.pylsp"
require "user.lsp.neocmake"
