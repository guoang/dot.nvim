local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  return
end

local g_priority = 3

local function format_name(n) return n:gsub("[^%w]+", "_") end

local match_path = function(buf_path, proj_path)
  local path_ok, plenary_path = pcall(require, "plenary.path")
  if not path_ok then
    return
  end
  local bpath = plenary_path.new(buf_path):absolute()
  local ppath = plenary_path.new(vim.fn.resolve(vim.fn.expand(proj_path))):absolute()
  return bpath:sub(0, #ppath) == ppath
end

local buffer_matcher = function(buf, path, group)
  local r = match_path(buf.path, path)
  if r then
    if buf.id == vim.fn.bufnr() then
      vim.b.bufferline_group = format_name(group)
    end
  end
  return r
end

local buffer_get_current_group = function()
  local groups = require("bufferline.groups")
  for _, group in pairs(groups.get_all()) do
    if group.name == vim.b.bufferline_group then
      return group
    end
  end
end

local buffer_go = function(direction)
  local state = require("bufferline.state")
  local index = nil
  for i, comp in ipairs(state.__components) do
    if comp.id == vim.fn.bufnr() then index = i break end
  end
  if index == nil then return end
  local function cycle(i, step, len)
    i = i + step
    if i > len then
      i = i - len
    elseif i <= 0 then
      i = i + len
    end
    return i
  end
  index = cycle(index, direction, #state.__components)
  local cnt = #state.__components
  local current_group = buffer_get_current_group()
  while cnt > 0 do
    if current_group and current_group.hidden then
      -- till next group
      if state.__components[index].id ~= nil then
        if not match_path(state.__components[index].path, current_group.path) then
          break
        end
      end
    else
      if state.__components[index].id ~= nil then
        break
      end
    end
    cnt = cnt - 1
    index = cycle(index, direction, #state.__components)
  end
  if state.__components[index].id ~= nil then
    vim.cmd("buf " .. tostring(state.__components[index].id))
  end
end

local buffer_next = function()
  buffer_go(1)
end

local buffer_prev = function()
  buffer_go(-1)
end

local buffer_group_toggle = function()
  vim.cmd("BufferLineGroupToggle " .. vim.b.bufferline_group)
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
    }
  },
}

local buffer_setup_group = function(root)
  if not root then return end
  if root:sub(#root):match("[/\\]") then root = root:sub(0, #root-1) end
  local groups = require("bufferline.groups")
  local name = root:sub(#root:match(".*[/\\]") + 1)
  for _, group in pairs(groups.get_all()) do
    if group.name == format_name(name) then
      return
    end
  end
  groups.setup({
    options = {
      groups = {
        items = {
          {
            name = name,
            path = root,
            auto_close = true,
            priority = g_priority,
            matcher = function(buf) return buffer_matcher(buf, root, name) end
          }
        }
      }
    }
  })
  g_priority = g_priority + 1
end

M = {
  buffer_next = buffer_next,
  buffer_prev = buffer_prev,
  buffer_matcher = buffer_matcher,
  buffer_group_toggle = buffer_group_toggle,
  buffer_get_current_group = buffer_get_current_group,
  buffer_setup_group = buffer_setup_group,
}
return M
