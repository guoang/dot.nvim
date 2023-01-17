local status_ok, spectre = pcall(require, "spectre")
if not status_ok then
  return
end

spectre.setup({
  mapping = {
    ["toggle_word_boundary"] = {
      map = "tw",
      cmd = "<cmd>lua require('spectre').change_options('word')<CR>",
      desc = "toggle word boundary",
    },
  },
  find_engine = {
    rg = {
      options = {
        word = {
          value = "--word-regexp",
          desc = "Only show matches surrounded by word boundaries.",
          icon = "[W]",
        },
      },
    },
  },
})
