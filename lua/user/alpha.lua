local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end
local path_ok, plenary_path = pcall(require, "plenary.path")
if not path_ok then
  return
end

local replace_space = true

vim.cmd("hi! link AlphaSubTitle SpecialComment")

local line_offset = function()
  local window = "%"
  if alpha.get_state() then
    window = alpha.get_state().window
  end
  local w = vim.fn.winwidth(window)
  local content_width = 134
  if w > content_width then
    return math.floor((w - content_width) / 2)
  end
  return 0
end

-- header & footer
-- {{{

local header_color = "markdownH" .. math.random(1, 6)
local header_val = require("user.alpha_headers").random()
local times = 10
while (#header_val >= 9 or #header_val < 5) and times > 0 do
  header_val = require("user.alpha_headers").random()
  times = times - 1
end

if #header_val < 8 then
  for _ = 1, (8 - #header_val) / 2 do
    table.insert(header_val, 1, "")
    table.insert(header_val, "")
  end
end

local header = {
  type = "text",
  -- val = {
  -- 	"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
  -- 	"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
  -- 	"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
  -- 	"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
  -- 	"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
  -- 	"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
  -- },

  val = header_val,
  opts = {
    position = "center",
    -- hl = "Type",
    hl = header_color,
  },
}

local footer = {
  type = "group",
  val = {
    {
      type = "text",
      val = "The computing scientist's main challenge is not to get confused by the complexities of his own making.",
      opts = {
        position = "center",
        hl = "Comment",
      },
    },
    {
      type = "text",
      val = "- Edsger W. Dijkstra",
      opts = {
        position = "center",
        hl = "Comment",
      },
    },
  },
}

-- }}}

-- button
-- {{{

local button = function(sc, txt, keybind)
  local opts = {
    position = "left",
    cursor = 1,
    hl = {},
  }
  if keybind then
    local keybind_opts = { noremap = true, silent = true, nowait = true }
    opts.keymap = { "n", sc, keybind, keybind_opts }
  end
  local function on_press()
    local key = vim.api.nvim_replace_termcodes(keybind or sc .. "<Ignore>", true, false, true)
    vim.api.nvim_feedkeys(key, "t", false)
  end
  return {
    type = "button",
    val = txt,
    on_press = on_press,
    opts = opts,
  }
end

-- }}}

-- mru
-- {{{

local mru_width = 45
local default_mru_ignore = { "gitcommit" }
local mru_opts = {
  ignore = function(path, ext)
    return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
  end,
  autocd = false,
}
local padding = function(str, len)
  if #str < len then
    return str .. string.rep(" ", len - #str)
  end
  return str
end

local function get_extension(fn)
  local match = fn:match("^.+(%..+)$")
  local ext = ""
  if match ~= nil then
    ext = match:sub(2)
  end
  return ext
end

local function icon(fn)
  local nwd = require("nvim-web-devicons")
  local ext = get_extension(fn)
  return nwd.get_icon(fn, ext, { default = true })
end

local function file_button(sc, txt, fn)
  local file_button_el = button(sc, txt, "<cmd>e " .. fn .. " <CR>")
  return file_button_el
end

local function mru(cwd, cnt, opts)
  opts = opts or mru_opts
  local oldfiles = {}
  for _, v in pairs(vim.v.oldfiles) do
    local fn = v
    if #oldfiles == cnt then
      break
    end
    local cwd_cond
    if not cwd then
      cwd_cond = true
    else
      cwd_cond = vim.startswith(v, cwd)
    end
    local ignore = (opts.ignore and opts.ignore(v, get_extension(v))) or false
    if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
      local short_fn
      if cwd then
        short_fn = vim.fn.fnamemodify(v, ":.")
      else
        short_fn = vim.fn.fnamemodify(v, ":~")
      end
      local exclude = -10
      while #short_fn > mru_width and exclude <= -1 do
        local e = {}
        local j = 1
        for k = exclude, -1 do
          e[j] = k
          j = j + 1
        end
        short_fn = plenary_path.new(short_fn):shorten(1, e)
        exclude = exclude + 1
      end
      local ico, hl = icon(fn)
      local txt = "[" .. tostring(#oldfiles + 1) .. "] " .. ico .. " " .. short_fn
      local hl_sc = { "Keyword", 0, 3 }
      local hl_ico = { hl, 4, 4 + #ico }
      local hl_path = {}
      local fn_start = txt:match(".*[/\\]")
      if fn_start ~= nil then
        hl_path = { "Comment", 5 + #ico, #fn_start }
        oldfiles[#oldfiles + 1] = { "file", txt, fn, hl_sc, hl_ico, hl_path }
      else
        oldfiles[#oldfiles + 1] = { "file", txt, fn, hl_sc, hl_ico }
      end
    end
  end

  return oldfiles
end

-- }}}

-- col
-- {{{

local col_padding = 1

local trim = function(s)
  return s:match("^(.-)%s*$")
end

-- define maximum string length in a table
local maxlen = function(column, idx)
  local max = 0
  for i = 1, #column do
    local str = trim(column[i][idx])
    if #str > max then
      max = #str
    end
  end
  return max
end

local col = function(columns)
  local nline = 0

  for i = 1, #columns do
    if #columns[i] > nline then
      nline = #columns[i]
    end
  end

  -- add as much right-padding to align the text block
  local pad = function(column, idx)
    local len = maxlen(column, idx) + 2
    -- process all the items but last,
    -- because we dont wand extra padding after last column
    for i = 1, nline do
      if i > #column then
        table.insert(column, { "title", "" })
      end
      local str = column[i][idx]
      if replace_space then
        str = str:gsub("<Spc>", "␠")
      end
      if #str < len then
        if column[i][1] == "file" or column[i][1] == "button" then
          column[i][idx] = padding(str, len)
        elseif string.find(str, "␠") ~= nil then
          column[i][idx] = padding(str, len)
        else
          column[i][idx] = padding(str, len - 2)
        end
      end
    end
  end

  for i = 1, #columns do
    pad(columns[i], 2)
  end

  -- this is a table for text strings
  local values = {}
  -- process all the lines
  for i = 1, nline do
    local line = {
      type = "text",
      val = "",
      opts = {
        hl = {},
        position = "left",
      },
    }

    for j = 1, #columns do
      if #columns[j] >= i then
        local hl_start = 0
        local tp = columns[j][i][1]
        local txt = columns[j][i][2]
        if tp == "file" then -- only at left
          local fn = columns[j][i][3]
          local sc = tostring(i - 1)
          line = file_button(sc, txt, fn)
          hl_start = 4
        elseif tp == "button" then -- only at left
          local sc = columns[j][i][3]
          local keybind = columns[j][i][4]
          line = button(sc, txt, keybind)
          hl_start = 5
        else
          hl_start = 3
          -- column spacing
          local p = ""
          if j > 1 then
            p = string.rep(" ", col_padding)
          end
          line.val = line.val .. p .. txt
        end
        for k = hl_start, #columns[j][i] do
          local hl = columns[j][i][k]
          local h1 = hl[2] + #line.val - #txt + line_offset()
          local h2 = hl[3] + #line.val - #txt + line_offset()
          table.insert(line.opts.hl, { hl[1], h1, h2 })
        end
      end
    end
    -- insert result into output table
    line.val = string.rep(" ", line_offset()) .. line.val
    table.insert(values, line)
  end

  return values
end
-- }}}

-- keymaps
-- {{{

local finding1 = {
  { "title",  "    FileExplorer",     { "AlphaSubTitle", 0, 30 } },
  { "keymap", " <Spc>e Explore Files", { "DevIconLeex",   0, 6 } },
  { "keymap", "" },
  { "title",  "    Finding",           { "AlphaSubTitle", 0, 18 } },
  { "keymap", "<Spc>ff Files",         { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>fp Projects",      { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>fr Recent files",  { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>fg live Grep",     { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>fw cursor Word ",  { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>fb text in Buf",   { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>fs buf Symbols",   { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>fS all Symbols",   { "DevIconLeex",   0, 6 },    { "Comment", 6, 20 } },
  { "keymap", "<Spc>fB open Buffers",  { "DevIconLeex",   0, 6 },    { "Comment", 6, 20 } },
  { "keymap", "<Spc>fR Registers",     { "DevIconLeex",   0, 6 },    { "Comment", 6, 20 } },
}

local finding2 = {
  { "keymap", "<Spc>fM Man pages",    { "DevIconLeex", 0, 6 }, { "Comment", 6, 20 } },
  { "keymap", "<Spc>fh vim Help",     { "DevIconLeex", 0, 6 }, { "Comment", 6, 20 } },
  { "keymap", "<Spc>fk vim Keymaps",  { "DevIconLeex", 0, 6 }, { "Comment", 6, 20 } },
  { "keymap", "<Spc>fc vim Commands", { "DevIconLeex", 0, 6 }, { "Comment", 6, 20 } },
  { "keymap", "<Spc>fC vim Colo",     { "DevIconLeex", 0, 6 }, { "Comment", 6, 20 } },
  { "keymap", "<Spc>fa vim Autocmd",  { "DevIconLeex", 0, 6 }, { "Comment", 6, 20 } },
  { "keymap", "<Spc>ft TS symbols",   { "DevIconLeex", 0, 6 }, { "Comment", 6, 20 } },
}

local git = {
  { "title",  "    Git",              { "AlphaSubTitle", 0, 13 } },
  { "keymap", "<Spc>gl Lazygit",      { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>gd Diff",         { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>gs Status",       { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>gc Commits",      { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>gb Branches",     { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>gB Blame",        { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>gr Reset Hunk",   { "DevIconLeex",   0, 6 },    { "Comment", 6, 20 } },
  { "keymap", "<Spc>gR Reset Buffer", { "DevIconLeex",   0, 6 },    { "Comment", 6, 20 } },
  { "keymap", "<Spc>gn Next Hunk",    { "DevIconLeex",   0, 6 },    { "Comment", 6, 20 } },
  { "keymap", "<Spc>gp Prev Hunk",    { "DevIconLeex",   0, 6 },    { "Comment", 6, 20 } },
  { "keymap", "<Spc>gS Stage Hunk",   { "DevIconLeex",   0, 6 },    { "Comment", 6, 20 } },
  { "keymap", "<Spc>gU Unstage Hunk", { "DevIconLeex",   0, 6 },    { "Comment", 6, 20 } },
  { "keymap", "<Spc>gP Preview Hunk", { "DevIconLeex",   0, 6 },    { "Comment", 6, 20 } },
}

local terminal = {
  { "title",  "      Terminal",                 { "AlphaSubTitle", 0, 18 } },
  { "keymap", "<C-\\> toggle terminal",         { "DevIconLeex",   0, 5 } },
  { "keymap", "  <Spc>tv Vertical window",      { "DevIconLeex",   0, 7 } },
  { "keymap", "  <Spc>tV Vertical 2 windows",   { "DevIconLeex",   0, 7 } },
  { "keymap", "  <Spc>th Horizontal window",    { "DevIconLeex",   0, 7 },    { "Comment", 7, 30 } },
  { "keymap", "  <Spc>tH Horizontal 2 windows", { "DevIconLeex",   0, 7 },    { "Comment", 7, 30 } },
  { "keymap", "  <Spc>tf Floating window",      { "DevIconLeex",   0, 7 },    { "Comment", 7, 30 } },
}

local trouble = {
  { "",       "" },
  { "title",  "    Trouble",             { "AlphaSubTitle", 0, 18 } },
  { "keymap", "<Spc>tt Toggle window",   { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>tw workspace diags", { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>td document diags",  { "DevIconLeex",   0, 6 },    { "Comment", 6, 20 } },
  { "keymap", "<Spc>tq quickfix",        { "DevIconLeex",   0, 6 },    { "Comment", 6, 20 } },
  { "keymap", "<Spc>tl loclist",         { "DevIconLeex",   0, 6 },    { "Comment", 6, 20 } },
}

local lsp = {
  { "title",     "    LSP",                 { "AlphaSubTitle", 0, 13 } },
  { "keymap",    "<Spc>li Info",            { "DevIconLeex",   0, 6 } },
  { "keymap",    "<Spc>lf Format",          { "DevIconLeex",   0, 6 } },
  { "keymap",    "<Spc>lI Install",         { "DevIconLeex",   0, 6 } },
  { "keymap",    "<Spc>la code Action",     { "DevIconLeex",   0, 6 },    { "Comment", 6, 25 } },
  { "keymap",    "<Spc>ll CodeLens Action", { "DevIconLeex",   0, 6 },    { "Comment", 6, 25 } },
  { "keymap",    "<Spc>lr Rename",          { "DevIconLeex",   0, 6 },    { "Comment", 6, 25 } },
  -- { "keymap", "<Spc>ls  Signature",      { "DevIconLeex",   0, 6 },    { "Comment", 6, 25 } },
  { "keymap",    " KK hover Signature",     { "DevIconLeex",   0, 3 } },
  { "keymap",    " KD show DevDocs",        { "DevIconLeex",   0, 3 } },
  { "keymap",    " KC hover Class",         { "DevIconLeex",   0, 3 } },
  { "keymap",    " KF hover Function",      { "DevIconLeex",   0, 3 } },
  { "keymap",    " gd go Definition",       { "DevIconLeex",   0, 3 } },
  { "keymap",    " gr go References",       { "DevIconLeex",   0, 3 } },
  { "keymap",    " gD go Declaration",      { "DevIconLeex",   0, 3 },    { "Comment", 4, 25 } },
  { "keymap",    " gI go Implementation",   { "DevIconLeex",   0, 3 },    { "Comment", 4, 25 } },
}

local dap = {
  { "title",  "    DAP",               { "AlphaSubTitle", 0, 13 } },
  { "keymap", "<Spc>dc Run/Continue",  { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>db toggle Bp",     { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>dB clear Bp",      { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>di step In",       { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>do step Over",     { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>dO step Out",      { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>dt Terminate",     { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>du toggle Ui",     { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>dR Run last",      { "DevIconLeex",   0, 6 },    { "Comment", 6, 20 } },
  { "title",  "" },
  { "title",  "    Substitute",        { "AlphaSubTitle", 0, 17 } },
  { "keymap", "<Spc>SS do Substitute", { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>Sw cursor Word",   { "DevIconLeex",   0, 6 } },
}

local switches = {
  { "",       "" },
  { "title",  "    Switches",           { "AlphaSubTitle", 0, 18 } },
  { "keymap", "<Spc>ss cursor word",    { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>sd Diagnostic",     { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>si Im-select auto", { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>sc color Column",   { "DevIconLeex",   0, 6 },    { "Comment", 6, 30 } },
  { "keymap", "<Spc>sS Spell checking", { "DevIconLeex",   0, 6 },    { "Comment", 6, 30 } },
}

local naming = {
  { "title",  "        Naming",         { "AlphaSubTitle", 0, 20 } },
  { "keymap", "    crs snake_case",     { "DevIconLeex",   0, 7 } },
  { "keymap", "    crm MixedCase",      { "DevIconLeex",   0, 7 } },
  { "keymap", "    crc camelCase",      { "DevIconLeex",   0, 7 },    { "Comment", 8, 20 } },
  { "keymap", "    cru UPPER_CASE",     { "DevIconLeex",   0, 7 },    { "Comment", 8, 20 } },
  { "keymap", "    cr- dash-case",      { "DevIconLeex",   0, 7 },    { "Comment", 8, 20 } },
  { "keymap", "    cr. dot.case",       { "DevIconLeex",   0, 7 },    { "Comment", 8, 20 } },
  { "keymap", "    cr<Spc> space case", { "DevIconLeex",   0, 9 },    { "Comment", 9, 20 } },
}

local runit = {
  { "title",  "    Run it",           { "AlphaSubTitle", 0, 16 } },
  { "keymap", "<Spc>ra All",          { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>rc Config",       { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>rC Clean",        { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>rb Build",        { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>rb Test",         { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>ri Install",      { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>rl Last",         { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>rf set Focus",    { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>rr run Focus",    { "DevIconLeex",   0, 6 } },
  { "",       "" },
  { "title",  "      Copilot",        { "AlphaSubTitle", 0, 16 } },
  { "keymap", "<C-;> trigger/accept", { "DevIconLeex",   0, 5 } },
  { "keymap", "<C-e> accept line",    { "DevIconLeex",   0, 5 } },
  { "keymap", "<C-'> dismiss",        { "DevIconLeex",   0, 5 } },
}

local navigation = {
  { "title",  "          Navigation",         { "AlphaSubTitle", 0, 20 } },
  { "keymap", "      s/S 2-char motion",      { "DevIconLeex",   0, 10 },   { "Grey", 7, 8 } },
  { "keymap", "      x/X 2-char motion (o)",  { "DevIconLeex",   0, 10 },   { "Grey", 7, 8 },   { "Comment", 10, 27 }, },
  { "keymap", "      H/L left/right buffer",  { "DevIconLeex",   0, 10 },   { "Grey", 7, 8 } },
  { "keymap", "  f/F/t/T 1-char motion",      { "DevIconLeex",   0, 10 },   { "Grey", 3, 4 },   { "Grey",    5,  6 },  { "Grey", 7, 8 }, },
  { "keymap", "  <C-h/l> left/right window",  { "DevIconLeex",   0, 10 },   { "Grey", 6, 7 } },
  { "keymap", "  <C-j/k> above/below window", { "DevIconLeex",   0, 10 },   { "Grey", 6, 7 } },
  { "keymap", "  <C-b/f> left/right (i)",     { "DevIconLeex",   0, 10 },   { "Grey", 6, 7 } },
  { "keymap", "  <C-a/e> home/end (i)",       { "DevIconLeex",   0, 10 },   { "Grey", 6, 7 } },
  { "keymap", "     ]]/c next method/class",  { "DevIconLeex",   0, 10 },   { "Grey", 7, 8 },   { "Comment", 10, 27 }, },
  { "keymap", "     [[/c prev method/class",  { "DevIconLeex",   0, 10 },   { "Grey", 7, 8 },   { "Comment", 10, 27 }, },
}

local editing = {
  { "title", "          Editing", { "AlphaSubTitle", 0, 20 } },
  { "keymap", "       ga Alignment", { "DevIconLeex", 0, 10 } },
  { "keymap", "       gi Insert at last pos", { "DevIconLeex", 0, 10 } },
  { "keymap", "      gcc toggle Comment line", { "DevIconLeex", 0, 10 } },
  { "keymap", "      gcb toggle Comment block", { "DevIconLeex", 0, 10 } },
  { "keymap", "       cs change surround mark", { "DevIconLeex", 0, 10 } },
  { "keymap", "       ds delete surround mark", { "DevIconLeex", 0, 10 } },
  { "keymap", "       ys add surround mark", { "DevIconLeex", 0, 10 } },
  { "keymap", "    <C-w> delete prev word (i)", { "DevIconLeex", 0, 10 } },
  { "keymap", "    <C-l> fast wrap pairs(i)", { "DevIconLeex", 0, 10 } },
  {
    "keymap",
    '  <C-r>/" paste (i)/(nv)',
    { "DevIconLeex", 0, 10 },
    { "Grey", 7, 8 },
    { "Comment", 10, 30 },
  },
}

local zettelkasten1 = {
  { "title",  "    Zettelkasten",        { "AlphaSubTitle", 0, 20 } },
  { "keymap", "<Spc>zz panel",           { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>zf Find notes",      { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>zi paste Img",       { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>zI insert Img link", { "DevIconLeex",   0, 6 },    { "Comment", 6, 21 } },
  { "keymap", "<Spc>zn new Note",        { "DevIconLeex",   0, 6 } },
  { "keymap", "<Spc>zN new tmpl Note",   { "DevIconLeex",   0, 6 },    { "Comment", 6, 21 } },
  { "keymap", "<Spc>zg Grep notes",      { "DevIconLeex",   0, 6 },    { "Comment", 6, 21 } },
  { "keymap", "<Spc>zl follow Link",     { "DevIconLeex",   0, 6 },    { "Comment", 6, 21 } },
  { "keymap", "<Spc>zL insert Link",     { "DevIconLeex",   0, 6 },    { "Comment", 6, 21 } },
  { "keymap", "<Spc>zd find Daily",      { "DevIconLeex",   0, 6 },    { "Comment", 6, 21 } },
  { "keymap", "<Spc>zD go toDay",        { "DevIconLeex",   0, 6 },    { "Comment", 6, 21 } },
  { "keymap", "<Spc>zw find Weekly",     { "DevIconLeex",   0, 6 },    { "Comment", 6, 21 } },
  { "keymap", "<Spc>zW go Weekly",       { "DevIconLeex",   0, 6 },    { "Comment", 6, 21 } },
  { "keymap", "<Spc>zr Rename note",     { "DevIconLeex",   0, 6 },    { "Comment", 6, 21 } },
}

local zettelkasten2 = {
  { "keymap", " <Spc>zy Yank notelink", { "DevIconLeex", 0, 7 }, { "Comment", 7, 21 } },
  { "keymap", " <Spc>zc show calendar",  { "DevIconLeex", 0, 7 }, { "Comment", 7, 21 } },
  { "keymap", " <Spc>zb show Backlink", { "DevIconLeex", 0, 7 }, { "Comment", 7, 21 } },
  { "keymap", " <Spc>zF find Friends",   { "DevIconLeex", 0, 7 }, { "Comment", 7, 21 } },
  { "keymap", " <Spc>zp Preview img",    { "DevIconLeex", 0, 7 }, { "Comment", 7, 21 } },
  { "keymap", " <Spc>zm browse Media",   { "DevIconLeex", 0, 7 }, { "Comment", 7, 21 } },
  { "keymap", " <Spc>zt show Tags",      { "DevIconLeex", 0, 7 }, { "Comment", 7, 21 } },
}

--}}}

-- layout
-- {{{

-- { hi = { sc = "DevIconLeex", sc_use_right_now = "DevIconLeex", desc = "Grey", desc_important = "Normal" } }
-- { hi = { sc = "DevIconLess", sc_use_right_now = "DevIconLeex", desc = "Grey", desc_important = "Normal" } }

local shortcut = function()
  local content = {
    { "title", "    Recent files & Shortcuts", { "AlphaSubTitle", 0, 30 } },
  }
  for _, v in pairs(mru(vim.fn.getcwd(), 5)) do
    table.insert(content, v)
  end
  table.insert(content, { "title", "" })
  table.insert(
    content,
    { "button", "[e]  Edit new file", "e", "<cmd>ene <CR>", { "Orange", 0, 3 }, { "Green", 4, 8 } }
  )
  table.insert(
    content,
    { "button", "[s]  open last Session", "s", "<cmd>RestoreSession<CR>", { "Orange", 0, 3 }, { "Blue", 4, 8 } }
  )
  table.insert(
    content,
    { "button", "[c]  edit vim Config", "c", ":e $MYVIMRC <CR>", { "Orange", 0, 3 }, { "Yellow", 4, 8 } }
  )
  table.insert(content, {
    "button",
    "[q]  Quit",
    "q",
    ":qa<CR>",
    { "Orange", 0, 3 },
    { "Grey", 4, 8 },
  })
  return content
end

local section_keymaps_1 = {
  type = "group",
  val = function()
    local sc = shortcut()
    if maxlen(sc, 2) < 40 then
      return col({ sc, navigation, editing, naming })
    else
      return col({ sc, navigation, editing, naming })
    end
  end,
  opts = { spacing = 0 },
}

local section_keymaps_2 = {
  type = "group",
  val = function()
    return col({ finding1, zettelkasten1, git, lsp, dap, runit })
  end,
  opts = { spacing = 0 },
}

local section_keymaps_3 = {
  type = "group",
  val = function()
    return col({ finding2, zettelkasten2, terminal, trouble, switches })
  end,
  opts = { spacing = 0 },
}

local function calc_padding()
  local window = "%"
  if alpha.get_state() then
    window = alpha.get_state().window
  end
  local win_height = vim.fn.winheight(window)
  local header_height = #header_val
  local footer_height = 2
  local content_height = 36
  local p = win_height - header_height - footer_height - content_height
  return math.max(math.floor(p / 3), 1)
end

local opts = {
  layout = {
    { type = "padding", val = calc_padding },
    header,
    { type = "padding", val = calc_padding },
    section_keymaps_1,
    { type = "padding", val = 2 },
    section_keymaps_2,
    section_keymaps_3,
    -- section_test,
    { type = "padding", val = calc_padding },
    footer,
  },
  opts = {
    noautocmd = true,
  },
}

-- }}}

alpha.setup(opts)
