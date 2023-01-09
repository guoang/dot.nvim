local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  return
end

local match_path = function(buf, path, group)
  local path_ok, plenary_path = pcall(require, "plenary.path")
  if not path_ok then
    return
  end
  local bpath = plenary_path.new(buf.path):absolute()
  local ppath = plenary_path.new(vim.fn.resolve(vim.fn.expand(path))):absolute()
  if bpath:sub(0, #ppath) == ppath then
    if buf.id == vim.fn.bufnr() then
      vim.b.bufferline_group = group
    end
    return true
  end
  return false
end

local buffer_next = function()
  local bufferline_groups = require("bufferline.groups")
  for _, group in pairs(bufferline_groups.get_all()) do
    if group.hidden == true then
      vim.cmd("BufferLineGroupToggle " .. group.name)
    end
  end
  vim.cmd("BufferLineCycleNext")
  for _, group in pairs(bufferline_groups.get_all()) do
    if group.hidden == false and group.name ~= vim.b.bufferline_group then
      vim.cmd("BufferLineGroupToggle " .. group.name)
    end
  end
end

local buffer_prev = function()
  local bufferline_groups = require("bufferline.groups")
  for _, group in pairs(bufferline_groups.get_all()) do
    if group.hidden == true then
      vim.cmd("BufferLineGroupToggle " .. group.name)
    end
  end
  vim.cmd("BufferLineCyclePrev")
  for _, group in pairs(bufferline_groups.get_all()) do
    if group.hidden == false and group.name ~= vim.b.bufferline_group then
      vim.cmd("BufferLineGroupToggle " .. group.name)
    end
  end
end

bufferline.setup {
  options = {
    close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
    right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
    offsets = { { filetype = "NvimTree", text = "NvimTree" } },
    separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
    always_show_bufferline = true,
    sort_by = 'directory',
    groups = {
      options = {
        toggle_hidden_on_enter = true -- when you re-enter a hidden group this options re-opens that group so the buffer is visible
      },
      items = {
        -- { name = "dot.nvim", auto_close = true, matcher = function(buf) return match_path(buf, '~/git/dot.nvim/', "dot_nvim") end, },
        -- { name = "zettelkasten", auto_close = true, matcher = function(buf) return match_path(buf, '~/zettelkasten/', "zettelkasten") end, },
        -- { name = "dragon.git", auto_close = true, matcher = function(buf) return match_path(buf, '~/work/dragon.git', "dragon_git") end, },
        -- { name = "xnet", auto_close = true, matcher = function(buf) return match_path(buf, '~/work/xcodebase/xnet', "xnet") end, },
      },
    },
  },

  -- highlights = {
  --   fill = {
  --     fg = { attribute = "fg", highlight = "#ff0000" },
  --     bg = { attribute = "bg", highlight = "TabLine" },
  --   },
  --
  --   background = {
  --     fg = { attribute = "fg", highlight = "TabLine" },
  --     bg = { attribute = "bg", highlight = "TabLine" },
  --   },
  --
  --   buffer_visible = {
  --     fg = { attribute = "fg", highlight = "TabLine" },
  --     bg = { attribute = "bg", highlight = "TabLine" },
  --   },
  --
  --   close_button = {
  --     fg = { attribute = "fg", highlight = "TabLine" },
  --     bg = { attribute = "bg", highlight = "TabLine" },
  --   },
  --   close_button_visible = {
  --     fg = { attribute = "fg", highlight = "TabLine" },
  --     bg = { attribute = "bg", highlight = "TabLine" },
  --   },
  --
  --   tab_selected = {
  --     fg = { attribute = "fg", highlight = "Normal" },
  --     bg = { attribute = "bg", highlight = "Normal" },
  --   },
  --
  --   tab = {
  --     fg = { attribute = "fg", highlight = "TabLine" },
  --     bg = { attribute = "bg", highlight = "TabLine" },
  --   },
  --
  --   tab_close = {
  --     -- fg = {attribute='fg',highlight='LspDiagnosticsDefaultError'},
  --     fg = { attribute = "fg", highlight = "TabLineSel" },
  --     bg = { attribute = "bg", highlight = "Normal" },
  --   },
  --
  --   duplicate_selected = {
  --     fg = { attribute = "fg", highlight = "TabLineSel" },
  --     bg = { attribute = "bg", highlight = "TabLineSel" },
  --     italic = true,
  --   },
  --
  --   duplicate_visible = {
  --     fg = { attribute = "fg", highlight = "TabLine" },
  --     bg = { attribute = "bg", highlight = "TabLine" },
  --     italic = true,
  --   },
  --
  --   duplicate = {
  --     fg = { attribute = "fg", highlight = "TabLine" },
  --     bg = { attribute = "bg", highlight = "TabLine" },
  --     italic = true,
  --   },
  --
  --   modified = {
  --     fg = { attribute = "fg", highlight = "TabLine" },
  --     bg = { attribute = "bg", highlight = "TabLine" },
  --   },
  --
  --   modified_selected = {
  --     fg = { attribute = "fg", highlight = "Normal" },
  --     bg = { attribute = "bg", highlight = "Normal" },
  --   },
  --
  --   modified_visible = {
  --     fg = { attribute = "fg", highlight = "TabLine" },
  --     bg = { attribute = "bg", highlight = "TabLine" },
  --   },
  --
  --   separator = {
  --     fg = { attribute = "bg", highlight = "TabLine" },
  --     bg = { attribute = "bg", highlight = "TabLine" },
  --   },
  --
  --   separator_selected = {
  --     fg = { attribute = "bg", highlight = "Normal" },
  --     bg = { attribute = "bg", highlight = "Normal" },
  --   },
  --
  --   indicator_selected = {
  --     fg = { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" },
  --     bg = { attribute = "bg", highlight = "Normal" },
  --   },
  -- },
}

M = {
  buffer_next = buffer_next,
  buffer_prev = buffer_prev,
  buffer_match_path = match_path,
}
return M
