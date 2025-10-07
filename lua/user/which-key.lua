local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local setup = {
  plugins = {
    spelling = {
      enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 10, -- how many suggestions should be shown in the list?
    },
  }
}

which_key.setup(setup)
which_key.add({
  { "<leader>P", group = "Packer",         nowait = true, remap = false },
  { "<leader>R", group = "Replace",        nowait = true, remap = false },
  { "<leader>b", group = "Buffer",         nowait = true, remap = false },
  { "<leader>d", group = "Dap/Diagnostic", nowait = true, remap = false },
  { "<leader>f", group = "Find",           nowait = true, remap = false },
  { "<leader>g", group = "Git",            nowait = true, remap = false },
  { "<leader>l", group = "Lsp",            nowait = true, remap = false },
  { "<leader>r", group = "RunIt",          nowait = true, remap = false },
  { "<leader>s", group = "Switch",         nowait = true, remap = false },
  { "<leader>S", group = "Spectre",        nowait = true, remap = false },
  { "<leader>t", group = "Trouble/Term",   nowait = true, remap = false },
  { "<leader>e", group = "Explore",        nowait = true, remap = false },
  { "<leader>c", group = "Completion",     nowait = true, remap = false },
  { "<leader>m", group = "Make",           nowait = true, remap = false },
})
