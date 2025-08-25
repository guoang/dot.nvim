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

-- setup folding
vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function()
    local ft = vim.bo.filetype
    local status_ok, pretty_fold = pcall(require, "user.pretty-fold")
    if not status_ok or not pretty_fold then
      return
    end
    if vim.tbl_contains({ "cpp", "c", "python", "lua" }, ft) then
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
      pretty_fold.setup_for_expr()
    else
      pretty_fold.setup_for_marker()
    end
    vim.opt_local.foldenable = false
    -- vim.api.nvim_exec([[
    --   autocmd BufReadPost,FileReadPost * normal! zM
    -- ]], false)
  end,
})

-- dim inactive window
vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    vim.opt_local.cursorline = false
    vim.opt_local.colorcolumn = "0"
  end,
})
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    if vim.bo.filetype == "alpha" then
      return
    end
    if vim.bo.filetype == "qf" or vim.bo.filetype == "Trouble" then
      vim.opt_local.cursorline = true
      return
    end
    vim.opt_local.cursorline = true
    vim.opt_local.colorcolumn = require("user.options").colorcolumn_by_ft(vim.bo.filetype)
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "TelescopePrompt" },
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- a file opened by telescope will not folding
-- fix it with this autocmd
-- https://github.com/nvim-telescope/telescope.nvim/issues/559#issuecomment-1074076011
-- vim.api.nvim_create_autocmd("BufRead", {
--   callback = function()
--     vim.api.nvim_create_autocmd("BufWinEnter", {
--       once = true,
--       command = "normal! zx",
--     })
--   end,
-- })

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown" },
  callback = function()
    vim.b.switch_custom_definitions = {
      { "- [ ]", "- [X]" },
    }
    vim.opt_local.shiftwidth = 3
    vim.opt_local.tabstop = 3
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

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
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

-- fix cursor shape for alacritty
-- Because neovim requests a cursor shape change and doesn't reset it when leaving neovim.
-- https://github.com/alacritty/alacritty/issues/5450
vim.api.nvim_create_autocmd({ "ExitPre" }, {
  callback = function()
    vim.cmd("set guicursor=a:ver90")
  end,
})
-- fix cursor shape for terminal mode
-- not working
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = "toggleterm",
--   callback = function()
--     vim.cmd("au InsertEnter <buffer> setlocal guicursor=a:ver90")
--     vim.cmd("au InsertLeave <buffer> setlocal guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20")
--   end,
-- })


-- copy source code to windows machine
-- 映射表：本地目录 => { 远程地址, 远程目录 }
local sync_list = {
  ["/Users/lalo/work/block/trunk/game"] = { host = "Admin@100.87.205.123", remote_dir = "D:/block/trunk/game" },
  ["/Users/lalo/work/block/trunk/xpylibs"] = { host = "Admin@100.87.205.123", remote_dir = "D:/block/trunk/xpylibs" },
  ["/Users/lalo/work/block/trunk/client/block/Assets/Scripts"] = { host = "Admin@100.87.205.123", remote_dir = "D:/block/trunk/client/block/Assets/Scripts" },
  ["/Users/lalo/work/block/trunk/client/block/Assets/Launch/Scripts"] = { host = "Admin@100.87.205.123", remote_dir = "D:/block/trunk/client/block/Assets/Launch/Scripts" },
  ["/Users/lalo/work/block/trunk/client/block/Packages/com.bytedance.block"] = { host = "Admin@100.87.205.123", remote_dir = "D:/block/trunk/client/block/Packages/com.bytedance.block" },
  ["/Users/lalo/work/block/trunk/client/block/Packages/com.bytedance.xpk"] = { host = "Admin@100.87.205.123", remote_dir = "D:/block/trunk/client/block/Packages/com.bytedance.xpk" },
}

-- Register autocmd for BufWritePost
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*",
  callback = function(args)
    local filepath = vim.fn.expand("<afile>:p")
    for watch_dir, remote in pairs(sync_list) do
      -- Check if the file path starts with the watch_dir
      if vim.startswith(filepath, watch_dir) then
        -- 保持目录结构：把 watch_dir 里的文件原样映射到 remote_dir
        local relative_path = filepath:sub(#watch_dir + 2) -- +2 因为要去掉 '/'
        local remote_path = remote.remote_dir .. "/" .. relative_path

        -- 构造 SCP 命令
        local scp_cmd = string.format(
          "scp '%s' '%s:%s'",
          filepath, remote.host, remote_path
        )

        -- 保证目标路径目录已存在，可用 ssh 的 mkdir -p
        local mkdir_cmd = string.format(
          "ssh %s 'mkdir -p %s'",
          remote.host,
          vim.fn.fnamemodify(remote_path, ":h")
        )
        vim.fn.jobstart(mkdir_cmd, { detach = true })
        vim.fn.jobstart(scp_cmd, { detach = true })
        break -- 如果一个文件只属于一个 sync 路径, 匹配到了就跳出
      end
    end
  end,
})
