local status_ok, trouble = pcall(require, "trouble")
if not status_ok then
  return
end

trouble.setup({
  mode = "document_diagnostics",
  auto_close = true,
})
