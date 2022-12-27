local status_ok, buildit = pcall(require, "buildit")
if not status_ok then
  return
end

buildit.setup({
  project = {
    xnet = {
      build = {
        dir = "~/work/xbuild",
        shell_cmd = "make",
      }
    },
  },
  filetype = {
    markdown = {
      build = {
        vim_cmd = "MarkdownPreview"
      }
    }
  }
})
