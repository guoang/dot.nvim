vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "cmake" },
  callback = function()
    vim.b.dispatch = "cmake -P %"
  end,
})
