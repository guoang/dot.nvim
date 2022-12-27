local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end
local path_ok, plenary_path = pcall(require, "plenary.path")
if not path_ok then
	return
end

local WIDTH = 160
local POSITION = "center"

-- header & footer
-- {{{

local header = {
  type = "text",
  val = {
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
  },
  opts = {
    position = "center",
    hl = "Type",
  },
}

local footer = {
  type = "group",
  val = {
    {
      type = "text",
      val = "The computing scientist's main challenge is not to get confused by the complexities of his own making.",
      opts = {
        position = POSITION,
        width = WIDTH,
        hl = "Comment",
      },
    },
    {
      type = "text",
      val = "- Edsger W. Dijkstra",
      opts = {
        position = POSITION,
        width = WIDTH,
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
		position = POSITION,
    width = WIDTH,
		cursor = 1,
    hl = {}
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

local mru_width = 50
local default_mru_ignore = { "gitcommit" }
local mru_opts = {
  ignore = function(path, ext)
    return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
  end,
  autocd = false,
}
local padding = function(str, len)
  if #str < len then
    return str .. string.rep(' ', len - #str)
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
        oldfiles[#oldfiles + 1] = { "file", txt, short_fn, hl_sc, hl_ico, hl_path }
      else
        oldfiles[#oldfiles + 1] = { "file", txt, short_fn, hl_sc, hl_ico }
      end
    end
  end

  return oldfiles
end

-- }}}

-- col
-- {{{

local col_padding = 5

local trim = function(s)
  return s:match "^(.-)%s*$"
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
    local len = maxlen(column, idx) + 1
    -- process all the items but last,
    -- because we dont wand extra padding after last column
    for i = 1, nline do
      if i > #column then
        table.insert(column, {"title", "",})
      end
      local str = column[i][idx]
      if #str < len then
        if column[i][1] == "file" or column[i][1] == "button" then
          column[i][idx] = padding(str, len + 1)
        else
          column[i][idx] = padding(str, len)
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
        position = POSITION,
        width = WIDTH,
      },
    }

    for j = 1, #columns do
      if #columns[j] >= i then
        local hl_start = 0
        local tp = columns[j][i][1]
        local txt = columns[j][i][2]
        if tp == "file" then  -- only at left
          local fn = columns[j][i][3]
          local sc = tostring(i - 1)
          line = file_button(sc, txt, fn)
          hl_start = 4
        elseif tp == "button" then  -- only at left
          local sc = columns[j][i][3]
          local keybind = columns[j][i][4]
          line = button(sc, txt, keybind)
          hl_start = 5
        else
          hl_start = 3
          -- column spacing
          local p = ''
          if j > 1 then
            p = string.rep(' ', col_padding)
          end
          line.val = line.val .. p .. txt
        end
        for k = hl_start, #columns[j][i] do
          local hl = columns[j][i][k]
          local h1 = hl[2] + #line.val - #txt
          local h2 = hl[3] + #line.val - #txt
          table.insert(line.opts.hl, {hl[1], h1, h2})
        end
      end
    end
    -- insert result into output table
    line.val = padding(line.val, WIDTH)
    table.insert(values, line)
  end

	return values
end
-- }}}

-- keymaps
-- {{{

local find_things = {
  { "title",  "Find",                            { "SpecialComment", 0, 4 }},
	{ "keymap", "<Spc>ff  Files",                  { "DevIconLeex",    0, 7 }},
	{ "keymap", "<Spc>fp  Projects",               { "DevIconLeex",    0, 7 }},
	{ "keymap", "<Spc>fr  Recent files",           { "DevIconLeex",    0, 7 }},
	{ "keymap", "<Spc>fs  Sessions",               { "DevIconLeex",    0, 7 }},
	{ "keymap", "<Spc>fg  text by live Grep",      { "DevIconLeex",    0, 7 }},
	{ "keymap", "<Spc>fw  Word under cursor",      { "DevIconLeex",    0, 7 }},
	{ "keymap", "<Spc>fl  Lsp document symbol",    { "DevIconLeex",    0, 7 }},
	{ "keymap", "<Spc>fb  text in current Buffer", { "DevIconLeex",    0, 7 }},
	{ "keymap", "<Spc>fL  Lsp workspace symbol",   { "DevIconLeex",    0, 7 }, { "Comment", 8, 30 }},
	-- { "keymap", "<Spc>ft  Treesitter symbol",      { "DevIconLeex",    0, 7 }, { "Comment", 8, 30 }},
	{ "keymap", "<Spc>fB  Buffers",                { "DevIconLeex",    0, 7 }, { "Comment", 8, 30 }},
	{ "keymap", "<Spc>fR  Registers",              { "DevIconLeex",    0, 7 }, { "Comment", 8, 30 }},
	{ "keymap", "<Spc>fc  vim Commands",           { "DevIconLeex",    0, 7 }, { "Comment", 8, 30 }},
	{ "keymap", "<Spc>fC  vim Color schemes",      { "DevIconLeex",    0, 7 }, { "Comment", 8, 30 }},
	{ "keymap", "<Spc>fh  vim Help",               { "DevIconLeex",    0, 7 }, { "Comment", 8, 30 }},
	{ "keymap", "<Spc>fk  vim Keymaps",            { "DevIconLeex",    0, 7 }, { "Comment", 8, 30 }},
	{ "keymap", "<Spc>fa  vim Auto commands",      { "DevIconLeex",    0, 7 }, { "Comment", 8, 30 }},
	-- { "keymap", "<Spc>fm  Man pages",              { "DevIconLeex",    0, 7 }, { "Comment", 8, 30 }},
}

local git = {
  { "title", "Git", { "SpecialComment", 0, 3 } },
	{ "keymap", "<Spc>gl  Lazygit",          { "DevIconLeex", 0, 7 }},
	{ "keymap", "<Spc>gd  Diff",             { "DevIconLeex", 0, 7 }},
	{ "keymap", "<Spc>gs  Status",           { "DevIconLeex", 0, 7 }},
	{ "keymap", "<Spc>gc  Commits",          { "DevIconLeex", 0, 7 }},
	{ "keymap", "<Spc>gb  Branches",         { "DevIconLeex", 0, 7 }},
	{ "keymap", "<Spc>gB  Blame",            { "DevIconLeex", 0, 7 }},
	{ "keymap", "<Spc>gr  Reset Hunk",       { "DevIconLeex", 0, 7 }},
	{ "keymap", "<Spc>gR  Reset Buffer",     { "DevIconLeex", 0, 7 }},
	{ "keymap", "<Spc>gS  Stage Hunk",       { "DevIconLeex", 0, 7 }},
	{ "keymap", "<Spc>gU  Undo Stage Hunk",  { "DevIconLeex", 0, 7 }},
	{ "keymap", "<Spc>gj  Next Hunk",        { "DevIconLeex", 0, 7 }},
	{ "keymap", "<Spc>gn  Next Hunk",        { "DevIconLeex", 0, 7 }},
	{ "keymap", "<Spc>gk  Prev Hunk",        { "DevIconLeex", 0, 7 }},
	{ "keymap", "<Spc>gp  Prev Hunk",        { "DevIconLeex", 0, 7 }},
	{ "keymap", "<Spc>gP  Preview Hunk",     { "DevIconLeex", 0, 7 }},
}

local terminal = {
  { "title",  "Terminal",                            { "SpecialComment", 0, 8 }},
  { "keymap", "<C-\\>    toggle terminal",           { "DevIconLeex",    0, 7 }},
  { "keymap", "<Spc>tf  Floating window",            { "DevIconLeex",    0, 7 }},
  { "keymap", "<Spc>th  Horizontal window",          { "DevIconLeex",    0, 7 }},
  { "keymap", "<Spc>tv  Vertical window",            { "DevIconLeex",    0, 7 }},
  { "keymap", "<Spc>ts  Send selection to terminal", { "DevIconLeex",    0, 7 }},
}

local trouble = {
  { "title",  "Trouble",                             { "SpecialComment", 0, 8 }},
  { "keymap", "<Spc>tt  Toggle trouble window",      { "DevIconLeex",    0, 7 }},
  { "keymap", "<Spc>tw  workspace_diagnostics",      { "DevIconLeex",    0, 7 }},
  { "keymap", "<Spc>td  document_diagnostics",       { "DevIconLeex",    0, 7 }},
  { "keymap", "<Spc>tq  quickfix",                   { "DevIconLeex",    0, 7 }},
  { "keymap", "<Spc>tl  loclist",                    { "DevIconLeex",    0, 7 }},
}

local lsp = {
  { "title", "LSP", { "SpecialComment", 0, 3 } },
  { "keymap", "<Spc>li  Info",              { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>lf  Format",            { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>lI  Install",           { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>la  code Action",       { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>ll  CodeLens Action",   { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>lr  Rename",            { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>ls  Signature",         { "DevIconLeex", 0, 7 }},
  { "keymap", "" },
  { "keymap", "      K  hover",             { "DevIconLeex", 0, 7 }},
  { "keymap", "     gd  go Definition",     { "DevIconLeex", 0, 7 }},
  { "keymap", "     gD  go Declaration",    { "DevIconLeex", 0, 7 }},
  { "keymap", "     gI  go Implementation", { "DevIconLeex", 0, 7 }},
  { "keymap", "     gr  go References",     { "DevIconLeex", 0, 7 }},
}

local dap = {
  { "title", "DAP", { "SpecialComment", 0, 3 }},
  { "keymap", "<Spc>dc  Run/Continue",      { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>db  toggle Breakpoint", { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>dB  clear Breakpoint",  { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>di  step In",           { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>do  step Over",         { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>dO  step Out",          { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>dr  toggle Repl",       { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>dR  Run last",          { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>dt  Terminate",         { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>du  toggle Ui",         { "DevIconLeex", 0, 7 }},
}

local switches = {
  { "title", "Switches", { "SpecialComment", 0, 8 }},
  { "keymap", "<Spc>ss  word under cursor",     { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>si  Im-select auto insert", { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>sd  Diagnostic visible",    { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>sq  Quickfix list",         { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>sl  Location list",         { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>sc  colorColumn",           { "DevIconLeex", 0, 7 }},
  { "keymap", "<Spc>sS  Spell checking",        { "DevIconLeex", 0, 7 }},
}

local runit = {
  { "title",  "Run it",                     { "SpecialComment", 0, 6 }},
  { "keymap", "<Spc>rb  run Build",         { "DevIconLeex",    0, 7 }},
  { "title",  "" },
  { "title",  "Replace",                    { "SpecialComment", 0, 7 }},
  { "keymap", "<Spc>Rw  Word under cursor", { "DevIconLeex",    0, 7 }},
  { "keymap", "<Spc>Rd  in current Doc",    { "DevIconLeex",    0, 7 }},
}

local naming = {
  { "title", "Naming", { "SpecialComment", 0, 6 }},
  { "keymap", "crs      snake_case", { "DevIconLeex", 0, 7 }},
  { "keymap", "cru      UPPER_CASE", { "DevIconLeex", 0, 7 }},
  { "keymap", "crm      MixedCase",  { "DevIconLeex", 0, 7 }},
  { "keymap", "crc      camelCase",  { "DevIconLeex", 0, 7 }},
  { "keymap", "cr-      dash-case",  { "DevIconLeex", 0, 7 }},
  { "keymap", "cr.      dot.case",   { "DevIconLeex", 0, 7 }},
  { "keymap", "cr<Spc>  space case", { "DevIconLeex", 0, 7 }},
}

local navigation = {
  { "title",  "Navigation",                         { "SpecialComment", 0, 10 }},
  { "keymap", "f/F/t/T      1-char motion",         { "DevIconLeex",    0, 11 },  { "Grey", 1, 2 },  { "Grey",    3,  4 },   { "Grey", 5, 6 }},
  { "keymap", "s/S          2-char motion",         { "DevIconLeex",    0, 11 },  { "Grey", 1, 2 }},
  { "keymap", "x/X          2-char motion (o)",     { "DevIconLeex",    0, 11 },  { "Grey", 1, 2 },  { "Comment", 13, 30 }},
  { "keymap", "<C-b/f>      left/right (i)",        { "DevIconLeex",    0, 11 },  { "Grey", 4, 5 }},
  { "keymap", "<C-a/e>      home/end (i)",          { "DevIconLeex",    0, 11 },  { "Grey", 4, 5 }},
  { "keymap", "<C-h/l/j/k>  move between windows",  { "DevIconLeex",    0, 11 },  { "Grey", 4, 5 },  { "Grey",    6,  7 },   { "Grey", 8, 9 }},
  { "keymap", "H/L          move between buffers",  { "DevIconLeex",    0, 11 },  { "Grey", 1, 2 }},
  { "keymap", "]>/)/}/m     next >,),},method",     { "DevIconLeex",    0, 11 },  { "Grey", 2, 3 },  { "Grey",    4,  5 },   { "Grey", 6, 7 },  { "Comment", 13, 35 }},
  { "keymap", "[</(/{/m     previous >,),},method", { "DevIconLeex",    0, 11 },  { "Grey", 2, 3 },  { "Grey",    4,  5 },   { "Grey", 6, 7 },  { "Comment", 13, 35 }},
}

local editing = {
  { "title",  "Editing",                            { "SpecialComment", 0, 10 }},
  { "keymap", "gi        Insert at last position",  { "DevIconLeex",    0, 8 }},
  { "keymap", "ga        Alignment",                { "DevIconLeex",    0, 8 }},
  { "keymap", "gcc       toggle Comment line",      { "DevIconLeex",    0, 8 }},
  { "keymap", "gcb       toggle Comment block",     { "DevIconLeex",    0, 8 }},
  { "keymap", "cs        change surround mark",     { "DevIconLeex",    0, 8 }},
  { "keymap", "ds        delete surround mark",     { "DevIconLeex",    0, 8 }},
  { "keymap", "ys        add surround mark",        { "DevIconLeex",    0, 8 }},
  { "keymap", "<C-w>     delete previous word (i)", { "DevIconLeex",    0, 8 }},
  { "keymap", "<C-l>     fast wrap pairs(i)",       { "DevIconLeex",    0, 8 }},
  { "keymap", "\"/<C-r>   paste in (nv)/(i) mode",  { "DevIconLeex",    0, 8 },   { "Grey", 1, 2}},
}

--}}}

-- layout
-- {{{

-- { hi = { sc = "DevIconLeex", sc_use_right_now = "DevIconLeex", desc = "Grey", desc_important = "Normal" } }
-- { hi = { sc = "DevIconLess", sc_use_right_now = "DevIconLeex", desc = "Grey", desc_important = "Normal" } }

local shortcut = function()
  local content = {
    { "title", " Recent files & Shortcuts", { "SpecialComment", 0, 30 }},
  }
  for _, v in pairs(mru(vim.fn.getcwd(), 5)) do
    table.insert(content, v)
  end
  table.insert(content, { "title", "" })
  table.insert(content, {"button", "[e]  Edit new file",     "e", "<cmd>ene <CR>",           {"Orange", 0, 3}, {"Green", 4, 8}})
  table.insert(content, {"button", "[s]  open last Session", "s", "<cmd>RestoreSession<CR>", {"Orange", 0, 3}, {"Blue", 4, 8}})
  table.insert(content, {"button", "[c]  edit vim Config",   "c", ":e $MYVIMRC <CR>",        {"Orange", 0, 3}, {"Yellow", 4, 8}})
  table.insert(content, {"button", "[q]  Quit",              "q", ":qa<CR>",                 {"Orange", 0, 3}, {"Grey", 4, 8}})
  return content
end

local section_keymaps_1 = {
  type = "group",
  val = function() 
    local sc = shortcut()
    if maxlen(sc, 2) < 30 then
      return col({ sc, navigation, editing, naming})
    else
      return col({ sc, navigation, editing})
    end
  end,
  opts = { spacing = 0 },
}

local section_keymaps_2 = {
  type = "group",
  val = col({ find_things, git, lsp, dap}),
  opts = { spacing = 0 },
}

local section_keymaps_3 = {
  type = "group",
  val = col({ terminal, trouble, switches, runit, }),
  opts = { spacing = 0 },
}

local opts = {
  layout = {
    { type = "padding", val = 2 },
    header,
    { type = "padding", val = 2 },
    -- section_mru,
    -- { type = "padding", val = 2 },
    section_keymaps_1,
    { type = "padding", val = 1 },
    section_keymaps_2,
    { type = "padding", val = 1 },
    section_keymaps_3,
    { type = "padding", val = 2 },
    footer,
  },
  opts = {
    noautocmd = true,
    margin = 5,
  },
}

-- }}}

alpha.setup(opts)
