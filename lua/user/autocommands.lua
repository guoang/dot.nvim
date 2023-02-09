-- press q to close specific window
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "tsplayground" },
  callback = function()
    vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR> 
      set nobuflisted 
    ]])
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "cpp", "c", "python", "lua" },
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt_local.foldenable = true
    -- vim.opt_local.foldnestmax = 3
    -- vim.cmd("normal zx")
  end,
})

-- dim inactive buffer
vim.api.nvim_create_autocmd('BufLeave', {
  callback = function()
    vim.opt_local.cursorline = false
  end,
})
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    if vim.bo.filetype ~= 'alpha' then
      vim.opt_local.cursorline = true
    end
  end,
})

-- a file opened by telescope will not folding
-- fix it with this autocmd
-- https://github.com/nvim-telescope/telescope.nvim/issues/559#issuecomment-1074076011
vim.api.nvim_create_autocmd('BufRead', {
   callback = function()
      vim.api.nvim_create_autocmd('BufWinEnter', {
         once = true,
         command = 'normal! zx'
      })
   end
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
    local bufname = vim.fn.bufname()
    if #bufname > 0 then
      local path = plenary_path.new(bufname)
      if #bufname and path:exists() and path:is_dir() then
        if bufnr == 1 then
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

-- open Alpha when no buffer
local alpha_on_empty = vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })
vim.api.nvim_create_autocmd("User", {
  pattern = "BDeletePost*",
  group = alpha_on_empty,
  callback = function(event)
    local fallback_name = vim.api.nvim_buf_get_name(event.buf)
    local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
    local fallback_on_empty = fallback_name == "" and fallback_ft == ""
    if fallback_on_empty then
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
