local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
local code_actions = null_ls.builtins.code_actions

-- https://github.com/prettier-solidity/prettier-plugin-solidity
null_ls.setup({
  debug = false,
  sources = {
    -- lua
    -- formatting.stylua.with({
    --   extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
    -- }),
    -- json/html/markdown/...
    formatting.prettier.with({
      extra_filetypes = { "toml" },
      extra_args = {
        "--no-semi",
        "--single-quote",
        "--jsx-single-quote",
        "--prose-wrap=always",
      },
    }),
    diagnostics.jsonlint,
    -- markdown, config file located in ~/.markdownlintrc
    -- formatting.markdownlint, --use prettier instead
    diagnostics.markdownlint,
    -- python
    -- formatting.reorder_python_imports,
    -- formatting.autopep8,
    formatting.yapf,
    -- cmake
    -- formatting.cmake_format,
    -- diagnostics.cmake_lint.with({
    --   extra_args = { "--internal-var-pattern", "[A-Z][0-9A-Z_]+" },
    -- }),

    code_actions.gitsigns,
    code_actions.proselint,
  },
})
