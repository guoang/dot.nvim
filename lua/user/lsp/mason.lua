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

-- Roslyn LSP 通过 Crashdummyy/mason-registry 提供, 需要注册进来
settings.registries = {
  "github:mason-org/mason-registry",
  "github:Crashdummyy/mason-registry",
}

require("mason").setup(settings)
require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_installation = true,
})

-- Roslyn LSP 单独用 mason-registry 安装 (不走 mason-lspconfig)
local mr_ok, mr = pcall(require, "mason-registry")
if mr_ok then
  local ok, pkg = pcall(mr.get_package, "roslyn")
  if ok and not pkg:is_installed() then
    pkg:install()
  end
end

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
