local co_ok, co = pcall(require, "copilot")
if not co_ok then
  return
end

-- Copilot proxy: https://github.com/github/copilot.vim/blob/1358e8e45ecedc53daf971924a0541ddf6224faf/doc/copilot.txt#L77-L91
vim.g.copilot_proxy = "http://127.0.0.1:1087"

co.setup({
  panel = { enabled = false },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept = "<C-CR>",
      accept_word = false,
      accept_line = false,
      next = false,
      prev = false,
      dismiss = false,
    }
  },
  filetypes = {
    cpp   = true,
    c     = true,
    py    = true,
    cmake = true,
    lua   = true,
    ["*"] = false,
  },
  -- copilot_model = "gpt-5",
})

-- local cmp_ok, cmp = pcall(require, "cmp")
-- if cmp_ok then
--   cmp.event:on("menu_opened", function()
--     vim.b.copilot_suggestion_hidden = true
--   end)
--
--   cmp.event:on("menu_closed", function()
--     vim.b.copilot_suggestion_hidden = false
--   end)
-- end

local function copilot_accept_word_or_fallback()
  local ok, copilot = pcall(require, "copilot.suggestion")
  if ok and copilot.is_visible() then
    copilot.accept_word()
  else
    -- Fallback to "move forward"
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, false, true), "n", false)
  end
end
vim.keymap.set("i", "<C-f>", copilot_accept_word_or_fallback, { desc = "Copilot Accept Word or <C-f> Fallback" })

local function copilot_accept_line_or_fallback()
  local ok, copilot = pcall(require, "copilot.suggestion")
  if ok and copilot.is_visible() then
    copilot.accept_line()
  else
    -- Fallback to "move to end of line
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<End>", true, false, true), "n", false)
  end
end
vim.keymap.set("i", "<C-e>", copilot_accept_line_or_fallback, { desc = "Copilot Accept Line or <C-f> Fallback" })

local function copilot_toggle_suggestion_visibility()
  local copilot = require("copilot.suggestion")
  if copilot.is_visible() then
    copilot.dismiss()
    vim.notify("Copilot suggestion hidden", vim.log.levels.INFO)
  else
    copilot.next()
    vim.notify("Copilot suggestion shown", vim.log.levels.INFO)
  end
end
vim.keymap.set("i", "<C-l>", copilot_toggle_suggestion_visibility, { desc = "Copilot toggle visibility" })
