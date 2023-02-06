local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

-- https://github.com/nvim-lualine/lualine.nvim/blob/master/examples/slanted-gaps.lua
-- https://github.com/nvim-lualine/lualine.nvim/discussions/911
--
local colors = {
  red = "#ca1243",
  grey = "#a0a1a7",
  black = "#383a42",
  white = "#f3f3f3",
  light_green = "#83a598",
  orange = "#fe8019",
  green = "#8ec07c",
}

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local diff = {
  "diff",
  colored = true,
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width,
  source = diff_source,
  padding = { left = 0, right = 1 },
}

local filetype = {
  "filetype",
  icons_enabled = true,
  padding = { left = 1, right = 0 },
}

local fileformat = {
  "fileformat",
  icons_enabled = true,
  symbols = {
    unix = "LF",
    dos = "CRLF",
    mac = "CR",
  },
}

local time = {
  'os.date("%I:%M:%S", os.time())',
}

local spaces = {
  function()
    return "sw-" .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  end,
  separator = { left = "" },
}

local diagnostics_message = require("user.lualine-diagnostics-message")

local diags_msg = {
  diagnostics_message,
  colors = {
    error = "#BF616A",
    warn = "#EBCB8B",
    info = "#A3BE8C",
    hint = "#88C0D0",
  },
  cond = diagnostics_message.has_diags_msg,
}

local diags_error = {
  "diagnostics",
  source = { "nvim" },
  sections = { "error" },
  diagnostics_color = { error = { bg = colors.red, fg = colors.white } },
  separator = { right = "" },
}

local diags_warn = {
  "diagnostics",
  source = { "nvim" },
  sections = { "warn" },
  diagnostics_color = { warn = { bg = colors.orange, fg = colors.white } },
  separator = { right = "" },
}
--
-- local diagnostics = {
--   "diagnostics",
--   sources = { "nvim_diagnostic" },
--   sections = { "error", "warn" },
--   symbols = { error = " ", warn = " " },
--   colored = true,
--   always_visible = false,
-- }

local filename = {
  "filename",
  file_status = false, -- Displays file status (readonly status, modified status)
  newfile_status = false, -- Display new file status (new file means no write after created)
  path = 1, -- 0: Just the filename
  -- 1: Relative path
  -- 2: Absolute path
  -- 3: Absolute path, with tilde as the home directory
  shorting_target = 40, -- Shortens path to leave 40 spaces in the window
  -- for other components. (terrible name, any suggestions?)
  symbols = {
    modified = "[+]", -- Text to show when the file is modified.
    readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
    unnamed = "", -- Text to show for unnamed buffers.
    newfile = "", -- Text to show for newly created file before first write
  },
  cond = function()
    return not diagnostics_message.has_diags_msg()
  end,
}

local encoding = {
  "encoding",
  padding = 0,
}

local modified = {
  function()
    if vim.bo.modified then
      return "+"
    elseif vim.bo.modifiable == false or vim.bo.readonly == true then
      return "-"
    end
    return ""
  end,
  color = { bg = "red" },
}

local search_result = {
  function()
    if vim.v.hlsearch == 0 then
      return ""
    end
    local last_search = vim.fn.getreg("/")
    if not last_search or last_search == "" then
      return ""
    end
    local searchcount = vim.fn.searchcount({ maxcount = 9999 })
    return last_search .. "(" .. searchcount.current .. "/" .. searchcount.total .. ")"
  end,
  color = { bg = "green" },
  separator = { left = "" },
}

local location = {
  "%l:%c %p%%",
}

lualine.setup({
  options = {
    globalstatus = true,
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    -- section_separators = { left = "", right = "" },
    -- component_separators = { left = '', right = '' }
    -- section_separators = { left = '', right = '' },
    -- component_separators = { left = '', right = ''},
    -- section_separators = { left = '', right = ''},
    disabled_filetypes = { "alpha", "dashboard" },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", diff },
    lualine_c = { diags_error, diags_warn, filename, diags_msg },
    lualine_x = { search_result, spaces, encoding, fileformat },
    lualine_y = { filetype, time },
    lualine_z = { location },
  },
})
