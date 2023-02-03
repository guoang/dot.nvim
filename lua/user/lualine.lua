local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
  colored = true,
  always_visible = false,
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
}

local filetype = {
  "filetype",
  icons_enabled = true,
  padding = { left = 1, right = 0 },
}

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

local spaces = function()
  return "sw-" .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local utils = require("lualine.utils.utils")
local highlight = require("lualine.highlight")
local diagnostics_message = require("lualine.component"):extend()

diagnostics_message.default = {
  colors = {
    error = utils.extract_color_from_hllist(
      { "fg", "sp" },
      { "DiagnosticError", "LspDiagnosticsDefaultError", "DiffDelete" },
      "#e32636"
    ),
    warning = utils.extract_color_from_hllist(
      { "fg", "sp" },
      { "DiagnosticWarn", "LspDiagnosticsDefaultWarning", "DiffText" },
      "#ffa500"
    ),
    info = utils.extract_color_from_hllist(
      { "fg", "sp" },
      { "DiagnosticInfo", "LspDiagnosticsDefaultInformation", "DiffChange" },
      "#ffffff"
    ),
    hint = utils.extract_color_from_hllist(
      { "fg", "sp" },
      { "DiagnosticHint", "LspDiagnosticsDefaultHint", "DiffAdd" },
      "#273faf"
    ),
  },
}

function diagnostics_message:init(options)
  diagnostics_message.super:init(options)
  self.options.colors = vim.tbl_extend("force", diagnostics_message.default.colors, self.options.colors or {})
  self.highlights = { error = "", warn = "", info = "", hint = "" }
  self.highlights.error = highlight.create_component_highlight_group(
    { fg = self.options.colors.error },
    "diagnostics_message_error",
    self.options
  )
  self.highlights.warn = highlight.create_component_highlight_group(
    { fg = self.options.colors.warn },
    "diagnostics_message_warn",
    self.options
  )
  self.highlights.info = highlight.create_component_highlight_group(
    { fg = self.options.colors.info },
    "diagnostics_message_info",
    self.options
  )
  self.highlights.hint = highlight.create_component_highlight_group(
    { fg = self.options.colors.hint },
    "diagnostics_message_hint",
    self.options
  )
end

function diagnostics_message:update_status(is_focused)
  local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local diagnostics = vim.diagnostic.get(0, { lnum = r - 1 })
  if #diagnostics > 0 then
    local top = diagnostics[1]
    for _, d in ipairs(diagnostics) do
      if d.severity < top.severity then
        top = d
      end
    end
    local icons = { " ", " ", " ", " " }
    local hl = {
      self.highlights.error,
      self.highlights.warn,
      self.highlights.info,
      self.highlights.hint,
    }
    local length_max = 90
    local message = top.message
    if #message > length_max then
      message = string.sub(top.message, 1, length_max) .. " [...]"
    end
    return highlight.component_format_highlight(hl[top.severity])
      .. icons[top.severity]
      .. " "
      .. utils.stl_escape(message)
  else
    return ""
  end
end

local diags = {
  diagnostics_message,
  colors = {
    error = "#BF616A",
    warn = "#EBCB8B",
    info = "#A3BE8C",
    hint = "#88C0D0",
  },
}

local encoding = {
  "encoding",
  padding = 0,
}

lualine.setup({
  options = {
    globalstatus = true,
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
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
    lualine_b = { "branch", diff, diagnostics },
    lualine_c = { diags },
    lualine_x = { spaces, encoding, fileformat },
    lualine_y = {  filetype, 'os.date("%I:%M:%S", os.time())' },
    lualine_z = { "progress" },
  },
})
