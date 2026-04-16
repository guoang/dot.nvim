-- Roslyn LSP (C# / Unity) 配置
-- 插件: seblyng/roslyn.nvim, 会自动调用 vim.lsp.start()
-- Roslyn server 由 mason 通过 Crashdummyy/mason-registry 安装 (见 mason.lua)
local status_ok, roslyn = pcall(require, "roslyn")
if not status_ok then
  return
end

roslyn.setup({
  -- Unity 大项目 (89 个 csproj) 性能优化:
  filewatching = "off",  -- 关文件监听, 保存时不卡 1-2 秒
  broad_search = false,  -- 不向上搜索父目录, 加快 root 检测
  lock_target = true,    -- 锁定选定的 sln, 打开新 .cs 文件时不重新扫描
  config = {
    settings = {
      ["csharp|background_analysis"] = {
        -- 只对打开的文件做诊断, 不扫全 sln
        dotnet_analyzer_diagnostics_scope = "openFiles",
        dotnet_compiler_diagnostics_scope = "openFiles",
      },
      ["csharp|completion"] = {
        dotnet_show_completion_items_from_unimported_namespaces = true,
        dotnet_show_name_completion_suggestions = true,
      },
      ["csharp|inlay_hints"] = {
        csharp_enable_inlay_hints_for_implicit_object_creation = true,
        csharp_enable_inlay_hints_for_implicit_variable_types = true,
      },
      -- 关掉 CodeLens (引用数、测试按钮), 减少开销
      ["csharp|code_lens"] = {
        dotnet_enable_references_code_lens = false,
        dotnet_enable_tests_code_lens = false,
      },
    },
  },
})
