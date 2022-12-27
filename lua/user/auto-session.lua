local status_ok, auto_session, session_lens

status_ok, auto_session = pcall(require, "auto-session")
if not status_ok then
	return
end

auto_session.setup({
  log_level = 'info',
  auto_session_enable_last_session = false,
  auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
  auto_session_enabled = true,
  auto_save_enabled = true,
  auto_restore_enabled = false,
  auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
  auto_session_use_git_branch = false,
})

status_ok, session_lens = pcall(require, "session-lens")
if not status_ok then
	return
end

session_lens.setup()
