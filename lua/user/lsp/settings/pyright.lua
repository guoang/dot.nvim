-- config pyright for neovim lsp
return {
  root_dir = require("lspconfig").util.root_pattern(".git", ".svn", ".root"),
  settings = {
    python = {
      analysis = {
        extraPaths = {
          -- "/Users/lalo/work/xbuild/install/RelWithDebInfo/Darwin-arm64/xsolution/lib",
          -- "/Users/lalo/work/xbuild/install/RelWithDebInfo/Darwin-arm64/xsolution/python",
          -- "/Users/lalo/work/xbuild/install/RelWithDebInfo/Darwin-arm64/xsolution/lib/python",
          -- "/Users/lalo/work/xbuild/install/RelWithDebInfo/Darwin-arm64/xsolution/lib/python3.11",
          -- "/Users/lalo/work/xbuild/install/RelWithDebInfo/Darwin-arm64/xsolution/lib/python3.11/site-packages",
          "/Users/lalo/work/block/ds2/trunk/game",
          "/Users/lalo/work/block/ds2/trunk/game/common",
          "/Users/lalo/work/block/ds2/trunk/game/common/xcodebase",
          "/Users/lalo/work/block/ds2/trunk/game/client",
          "/Users/lalo/work/block/ds2/trunk/game/server",
        },
        stubPath = "/Users/lalo/work/block/ds2/trunk/game/stub",
        diagnosticSeverityOverrides = {
          reportMissingModuleSource = "none"
        }
      },
    },
  },
}
