vim.g.copilot_no_tab_map = true

local M = {}

function M.get_suggestion_text()
  local s = vim.fn["copilot#GetDisplayedSuggestion"]()
  return s.text
end

function M.has_suggestion()
  local s = vim.fn["copilot#GetDisplayedSuggestion"]()
  return s.text ~= "" and s.text ~= nil
end

function M.toggle_suggest()
  if M.has_suggestion() then
    vim.fn["copilot#Dismiss"]()
  else
    vim.fn["copilot#Suggest"]()
  end
end

function M.accept_line(fallback)
  -- accept copilot suggestion, just current line
  local text = M.get_suggestion_text()
  if text == "" or text == nil then
    fallback()
    return
  end
  local co_line = text:match(".-\n")
  if co_line == nil then
    co_line = text
  else
    co_line = co_line:sub(1, -2)
  end
  if co_line ~= "" then
    local pos = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    co_line = line:sub(0, pos) .. co_line
    vim.api.nvim_set_current_line(co_line)
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], #co_line })
  else
    fallback()
  end
end

function M.accept_char(fallback)
  -- accept copilot suggestion, just next char
  local text = M.get_suggestion_text()
  if text == "" or text == nil then
    fallback()
    return
  end
  local co_line = text:match(".-\n")
  if co_line == nil then
    co_line = text
  else
    co_line = co_line:sub(1, -2)
  end
  if co_line ~= "" then
    local pos = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    co_line = line:sub(0, pos) .. co_line:sub(0, 1)
    vim.api.nvim_set_current_line(co_line)
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], pos + 1 })
  else
    fallback()
  end
end

function M.accept_all(fallback)
  if M.has_suggestion() then
    require("nvim-autopairs").disable()
    local co_keys = vim.fn["copilot#Accept"]()
    if co_keys ~= "" then
      vim.api.nvim_feedkeys(co_keys, "i", true)
    end
    require("nvim-autopairs").enable()
  elseif fallback then
    fallback()
  else
    vim.fn["copilot#Suggest"]()
  end
end

return M
