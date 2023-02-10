local status_ok, pretty_fold = pcall(require, "pretty-fold")
if not status_ok then
  return
end

pretty_fold.setup({
  fill_char = " ",
  process_comment_signs = false,
  sections = {
    left = { "content" },
    right = {},
  },
})

local M = {}

local function ellipsis(config)
  local content = vim.fn.getline(vim.v.foldstart)
  content = content:gsub("\t", string.rep(" ", vim.bo.tabstop))
  if config.keep_indentation then
    local indent = content:match("^%s%s+") or ""
    content = indent .. "..."
  else
    content = "..."
  end
  return content
end

local comment_signs = {
  lua = "--",
  python = "#",
  cmake = "#",
  sh = "#",
  bash = "#",
  zsh = "#",
  c = "//",
  cpp = "//",
  go = "//",
  rust = "//",
  csharp = "//",
  java = "//",
  javascript = "//",
  typescript = "//",
  markdown = "<!--",
  html = "<!--",
}

-- setup for fmd=marker
function M.setup_for_marker()
  local comment_sign = comment_signs[vim.bo.filetype]
  if comment_sign == nil then
    comment_sign = ""
  else
    comment_sign = comment_sign .. " "
  end
  pretty_fold.setup({
    fill_char = " ",
    sections = {
      left = { comment_sign, "{{{ ... ", "number_of_folded_lines", " ... }}}" },
      right = {},
    },
  })
end

-- setup for fmd=expr
function M.setup_for_expr()
  local ft = vim.bo.filetype
  if vim.tbl_contains({ "lua", "python" }, ft) then
    pretty_fold.ft_setup(ft, {
      sections = {
        left = { ellipsis, " ", "number_of_folded_lines" },
        right = {},
      },
      fill_char = " ",
    })
  else
    pretty_fold.ft_setup(ft, {
      sections = {
        left = { "content", " ... ", "number_of_folded_lines" },
        right = {},
      },
      fill_char = " ",
      process_comment_signs = false,
    })
  end
end

return M
