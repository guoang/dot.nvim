local status_ok, auto_session, session_lens

status_ok, auto_session = pcall(require, "auto-session")
if not status_ok then
	return
end

local vim_enter_dir = vim.fn.getcwd()

local function restore_nvim_tree()
  local bufs = vim.api.nvim_list_bufs()
  for _, bufnr in ipairs(bufs) do
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname ~= nil and bufname:match("NvimTree") then
      vim.cmd("NvimTreeOpen")
      break
    end
  end
end

local function restore_bufferline_groups()
  local project = require("project_nvim.project")
  local bufs = vim.api.nvim_list_bufs()
  for _, bufnr in ipairs(bufs) do
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname ~= nil then
      local dir = bufname:match(".*[/\\]")
      if dir ~= nil then
        local root, _ = project.find_pattern_root(dir)
        require("user.bufferline").buffer_setup_group(root)
      end
    end
  end
end

local function save_vim_enter_dir()
  local cwd = vim.fn.getcwd()
  if cwd == vim_enter_dir then return end
  pcall(vim.fn.chdir, vim_enter_dir)
  -- clear altfile
  vim.cmd("edit __nvim_tmp_stub_file__")
  vim.cmd("bwipeout")
  -- do save
  vim.cmd("SaveSession")
  vim.fn.chdir(cwd)
end

auto_session.setup({
  log_level = 'info',
  auto_session_enable_last_session = false,
  auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
  auto_session_enabled = true,
  auto_save_enabled = true,
  auto_restore_enabled = false,
  auto_session_suppress_dirs = { "~/Downloads", "/" },
  auto_session_use_git_branch = false,
  post_restore_cmds = { restore_bufferline_groups, restore_nvim_tree },
  post_save_cmds = { save_vim_enter_dir },
})

status_ok, session_lens = pcall(require, "session-lens")
if not status_ok then
  return
end

session_lens.setup()
