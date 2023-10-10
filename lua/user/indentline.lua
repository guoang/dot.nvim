local status_ok, ibl = pcall(require, "ibl")
if not status_ok then
  return
end

vim.g.indent_blankline_indent_level = 4
ibl.setup({
  indent = {
    char = "▏",
  },
  scope = {
    show_start = false,
    show_end = false,
  },
  exclude = {
    buftypes = { "terminal", "nofile", "toggleterm" },
    filetypes = { "help", "packer", "NvimTree", "toggleterm" },
  },
})
