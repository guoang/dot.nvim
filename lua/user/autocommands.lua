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
	pattern = { "gitcommit", "markdown" },
	callback = function()
		-- vim.opt_local.wrap = true
		-- vim.opt_local.spell = true
    vim.opt_local.colorcolumn = "80"
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "markdown" },
	callback = function()
    vim.b.switch_custom_definitions = {
      { "- [ ]", "- [X]"},
    }
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    local path_ok, plenary_path = pcall(require, "plenary.path")
    if not path_ok then
      return
    end
    local bufnr = vim.fn.bufnr()
    local bufnr_last = vim.fn.bufnr('$')
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
  end
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    if vim.fn.winnr('$') == 1 and vim.fn.bufname() == 'NvimTree_' .. vim.fn.tabpagenr() then
      vim.cmd("quit")
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
    local groups_ok, bufferline_groups = pcall(require, "bufferline.groups")
    if not groups_ok then
      return
    end
    local root, method = project.get_project_root()
    if root then
      local name = root:sub(#root:match(".*[/\\]") + 1)
      local names = bufferline_groups.names()
      for _, group_name in ipairs(names) do
        if group_name == name then
          return
        end
      end
      local function format_name(name) return name:gsub("[^%w]+", "_") end
      bufferline_groups.setup({
        options = {
          groups = {
            items = {
              {
                name = name,
                auto_close = true,
                priority = #names + 2,
                matcher = function(buf) return require'user.bufferline'.buffer_match_path(buf, root, format_name(name)) end
              }
            }
          }
        }
      })
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

