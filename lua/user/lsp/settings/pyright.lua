-- config pyright for neovim lsp
return {
  root_dir = require("lspconfig").util.root_pattern(".git", ".svn", ".root"),
  settings = {
    python = {
      analysis = {
        extraPaths = {
          "/Users/lalo/work/xbuild/install/RelWithDebInfo/Darwin-x86_64/xsolution/lib",
          "/Users/lalo/work/xbuild/install/RelWithDebInfo/Darwin-x86_64/xsolution/python",
          "/Users/lalo/work/xbuild/install/RelWithDebInfo/Darwin-x86_64/xsolution/lib/python",
          "/Users/lalo/work/xbuild/install/RelWithDebInfo/Darwin-x86_64/xsolution/lib/python3.11",
          "/Users/lalo/work/xbuild/install/RelWithDebInfo/Darwin-x86_64/xsolution/lib/python3.11/site-packages",
        },
        stubPath = "/Users/lalo/work/xbuild/install/RelWithDebInfo/Darwin-x86_64/xsolution/api/pystub",
      },
    },
  },
}
