local status_ok, spectre = pcall(require, "spectre")
if not status_ok then
  return
end

spectre.setup({
  find_engine = {
    rg = {
      options = {
        word = {
          value = "--word-regexp",
          desc = "Only show matches surrounded by word boundaries.",
          icon = "[W]"
        }
      }
    }
  }
})
