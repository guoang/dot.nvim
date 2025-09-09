local status_ok, im_select = pcall(require, "im-select")
if not status_ok then
  return
end

sougou = "com.sogou.inputmethod.sogou.pinyin"
weixin = "com.tencent.inputmethod.wetype.pinyin"
apple_en = "com.apple.keylayout.ABC"
apple_cn = "com.apple.inputmethod.SCIM.Shuangpin"

im_select.setup({
  -- IM will be used in `normal` mode
  -- For Windows/WSL, default: "1033", aka: English US Keyboard
  -- For macOS, default: "com.apple.keylayout.ABC", aka: US
  -- You can use `im-select` in cli to get the IM name of you preferred
  im_normal = apple_en,
  im_normal_ft = {
    TelescopePrompt = apple_en,
    codecompanion = apple_en,
  },
  -- IM will be used in `insert` mode
  im_insert = apple_en,
  im_insert_ft = {
    TelescopePrompt = apple_en,
    -- markdown = "com.apple.inputmethod.SCIM.Shuangpin",
    markdown = apple_cn,
    html = apple_cn,
    rst = apple_cn,
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
