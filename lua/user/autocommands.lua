vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
  callback = function()
    vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR> 
      set nobuflisted 
    ]])
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "cmake" },
  callback = function()
    vim.opt_local.foldmethod = "marker"
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown" },
  callback = function()
    vim.b.switch_custom_definitions = {
      { "- [ ]", "- [X]" },
    }
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf" },
  callback = function()
    vim.keymap.set(
      "n",
      "<C-f>",
      "<cmd>lua require('user.nvim-bqf').scroll(1)<CR>",
      { noremap = true, silent = true, buffer = true }
    )
    vim.keymap.set(
      "n",
      "<C-b>",
      "<cmd>lua require('user.nvim-bqf').scroll(-1)<CR>",
      { noremap = true, silent = true, buffer = true }
    )
    vim.keymap.set("n", "<C-c>", "<cmd>AbortDispatch<CR>", { noremap = true, silent = true, buffer = true })
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    local path_ok, plenary_path = pcall(require, "plenary.path")
    if not path_ok then
      return
    end
    local bufnr = vim.fn.bufnr()
    local bufnr_last = vim.fn.bufnr("$")
    local bufname = vim.fn.bufname()
    if #bufname > 0 then
      local path = plenary_path.new(bufname)
      if #bufname and path:exists() and path:is_dir() then
        if bufnr == 1 and bufnr_last <= 2 then
          vim.fn.chdir(bufname)
          vim.cmd("Alpha")
          vim.api.nvim_buf_delete(bufnr, {})
        end
      end
    end
  end,
})

-- auto create bufferline group
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  callback = function()
    local ok, project = pcall(require, "project_nvim.project")
    if not ok then
      return
    end
    local root, _ = project.find_pattern_root()
    require("user.bufferline").buffer_setup_group(root)
  end,
})

-- need bufdelete.nvim, neo-tree & alpha-dashboard
local alpha_on_empty = vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })
vim.api.nvim_create_autocmd("User", {
  pattern = "BDeletePost*",
  group = alpha_on_empty,
  callback = function(event)
    local fallback_name = vim.api.nvim_buf_get_name(event.buf)
    local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
    local fallback_on_empty = fallback_name == "" and fallback_ft == ""

    if fallback_on_empty then
      -- require("neo-tree").close_all()
      vim.cmd("Alpha")
      vim.cmd(event.buf .. "bwipeout")
    end
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

vim.api.nvim_create_autocmd({ "CmdWinEnter" }, {
  callback = function()
    vim.cmd("quit")
  end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.java" },
  callback = function()
    vim.lsp.codelens.refresh()
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    vim.cmd("hi link illuminatedWord LspReferenceText")
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    local line_count = vim.api.nvim_buf_line_count(0)
    if line_count >= 5000 then
      vim.cmd("IlluminatePauseBuf")
    end
  end,
})
