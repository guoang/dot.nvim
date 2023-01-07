local status_ok, im_select = pcall(require, "im_select")
if not status_ok then
  return
end

im_select.setup({
  -- IM will be used in `normal` mode
  -- For Windows/WSL, default: "1033", aka: English US Keyboard
  -- For macOS, default: "com.apple.keylayout.ABC", aka: US
  -- You can use `im-select` in cli to get the IM name of you preferred
  im_normal = "com.apple.keylayout.ABC",
  im_normal_ft = {
    TelescopePrompt = "com.apple.keylayout.ABC",
  },
  -- IM will be used in `insert` mode
  im_insert = "com.apple.keylayout.ABC",
  im_insert_ft = {
    TelescopePrompt = "com.apple.keylayout.ABC",
    -- markdown = "com.apple.inputmethod.SCIM.Shuangpin",
    markdown = "com.sogou.inputmethod.sogou.pinyin",
  },
  -- Create auto command to select `im_normal` when `InsertLeave`
  auto_select_normal = true,
  -- Create auto command to select `im_insert` when `InsertEnter`
  auto_select_insert = false,
  -- keymaps
  keymaps = {
    toggle_auto_select_normal = "",
    toggle_auto_select_insert = "",
  },
})
