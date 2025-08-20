local servers = {
  "lua_ls",
  "cssls",
  "html",
  "bashls",
  "jsonls",
  "yamlls",
  "clangd",
  "neocmake",
  "pylsp",
  "pyright",
  "yamlls",
}

local settings = {
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}

require("mason").setup(settings)
require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_installation = true,
})

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status_ok then
  for _, server in pairs(servers) do
    server = vim.split(server, "@")[1]
    vim.lsp.enable(server)
    vim.lsp.config(server, {
      capabilities = cmp_nvim_lsp.default_capabilities(),
    })
  end
end
