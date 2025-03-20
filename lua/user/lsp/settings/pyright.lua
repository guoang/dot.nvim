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
          "/Users/lalo/work/block/trunk/game",
          "/Users/lalo/work/block/trunk/xpylibs",
          "/Users/lalo/work/block/trunk/server/dist/Darwin-arm64/lib/python3.11/site-packages",
          "/Users/lalo/work/block/trunk/tools/dist/Darwin-arm64/lib/python3.11/site-packages",
          "/Users/lalo/work/bbuild/install/RelWithDebInfo/Darwin-arm64/block/lib/python3.11/site-packages",
        },
        stubPath = "/Users/lalo/work/block/trunk/game/stub",
        diagnosticSeverityOverrides = {
          reportMissingModuleSource = "none", -- 忽略 C Module 找不到源码的 warning
          reportUnusedExpression = "none",
          reportGeneralTypeIssues = "none",   -- 关闭类型检查
        },
      },
    },
  },
}
