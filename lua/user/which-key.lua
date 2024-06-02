local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local setup = {
  plugins = {
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 10, -- how many suggestions should be shown in the list?
    },
  }
}

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
  P = { name = "Packer" },
  f = { name = "Find" },
  g = { name = "Git" },
  l = { name = "Lsp" },
  d = { name = "Dap/Diagnostic" },
  t = {
    name = "Terminal/Trouble",
  },
  s = { name = "Switch" },
  r = { name = "RunIt" },
  R = { name = "Replace" },
  b = { name = "Buffer" },
  z = { name = "Zettelkasten" },
}

which_key.setup(setup)
which_key.register(mappings, opts)
