local status_ok, auto_session = pcall(require, "auto-session")
if not status_ok then
	return
end

local vim_enter_dir = vim.fn.getcwd()

-- find_pattern_root from project.nvim
local function find_pattern_root(search_dir, patterns)
  if vim.fn.has("win32") > 0 then
    search_dir = search_dir:gsub("\\", "/")
  end

  local glob = require("project_nvim.utils.globtopattern")
  local uv = vim.loop
  local last_dir_cache = ""
  local curr_dir_cache = {}

  local function get_parent(path)
    path = path:match("^(.*)/")
    if path == "" then
      path = "/"
    end
    return path
  end

  local function get_files(file_dir)
    last_dir_cache = file_dir
    curr_dir_cache = {}

    local dir = uv.fs_scandir(file_dir)
    if dir == nil then
      return
    end

    while true do
      local file = uv.fs_scandir_next(dir)
      if file == nil then
        return
      end

      table.insert(curr_dir_cache, file)
    end
  end

  local function is(dir, identifier)
    dir = dir:match(".*/(.*)")
    return dir == identifier
  end

  local function sub(dir, identifier)
    local path = get_parent(dir)
    while true do
      if is(path, identifier) then
        return true
      end
      local current = path
      path = get_parent(path)
      if current == path then
        return false
      end
    end
  end

  local function child(dir, identifier)
    local path = get_parent(dir)
    return is(path, identifier)
  end

  local function has(dir, identifier)
    if last_dir_cache ~= dir then
      get_files(dir)
    end
    local pattern = glob.globtopattern(identifier)
    for _, file in ipairs(curr_dir_cache) do
      if file:match(pattern) ~= nil then
        return true
      end
    end
    return false
  end

  local function match(dir, pattern)
    local first_char = pattern:sub(1, 1)
    if first_char == "=" then
      return is(dir, pattern:sub(2))
    elseif first_char == "^" then
      return sub(dir, pattern:sub(2))
    elseif first_char == ">" then
      return child(dir, pattern:sub(2))
    else
      return has(dir, pattern)
    end
  end

  -- breadth-first search
  while true do
    for _, pattern in ipairs(patterns) do
      local exclude = false
      if pattern:sub(1, 1) == "!" then
        exclude = true
        pattern = pattern:sub(2)
      end
      if match(search_dir, pattern) then
        if exclude then
          break
        else
          return search_dir, "pattern " .. pattern
        end
      end
    end

    local parent = get_parent(search_dir)
    if parent == search_dir or parent == nil then
      return nil
    end

    search_dir = parent
  end
end

local function restore_bufferline_groups()
  local config = require("project_nvim.config")
  local bufs = vim.api.nvim_list_bufs()
  for _, bufnr in ipairs(bufs) do
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname ~= nil then
      local dir = bufname:match(".*[/\\]")
      if dir ~= nil then
        local root, _ = find_pattern_root(dir, config.options.patterns)
        require("user.bufferline").buffer_setup_group(root)
      end
    end
  end
end

local function close_all_floating_wins()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= '' then
      vim.api.nvim_win_close(win, false)
    end
  end
end

local function close_windows()
  pcall(vim.cmd, "NvimTreeClose")
  pcall(vim.cmd, "SymbolsOutlineClose")
  pcall(vim.cmd, "cclose")
  pcall(vim.cmd, "helpclose")
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
  post_restore_cmds = { restore_bufferline_groups },
  post_save_cmds = { save_vim_enter_dir },
  pre_save_cmds = { close_all_floating_wins, close_windows },
})
