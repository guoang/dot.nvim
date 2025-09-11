local ok, cc = pcall(require, "CopilotChat")
if not ok then
  return
end

local mappings = require("CopilotChat.config.mappings")
mappings.submit_prompt.insert = '<C-CR>'

cc.setup({
  model = 'gpt-4.1',
  temperature = 0.1,
  window = {
    width = 80,
    height = 20,
    border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
    title = '🤖 AI Assistant',
  },
  headers = {
    user = '👤 You',
    assistant = '🤖 Copilot',
    tool = '🔧 Tool',
  },
  separator = '━━',
  auto_fold = false, -- Automatically folds non-assistant messages
})

-- Auto-command to customize chat buffer behavior
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'copilot-*',
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.opt_local.conceallevel = 0
    vim.wo.winhl = "Normal:NvimTreeNormal,EndOfBuffer:NvimTreeEndOfBuffer"
    vim.wo.winfixwidth = true
  end,
})
