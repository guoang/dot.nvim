local status_ok, pretty_fold = pcall(require, "pretty-fold")
if not status_ok then
  return
end

pretty_fold.setup({
  fill_char = " ",
})

local function ellipsis(config)
  local content = vim.fn.getline(vim.v.foldstart)
  content = content:gsub("\t", string.rep(" ", vim.bo.tabstop))
  if config.keep_indentation then
    content = content:match("^%s%s+") .. "..."
  else
    content = "..."
  end
  return content
end

for _, ft in ipairs({ "python", "lua" }) do
  pretty_fold.ft_setup(ft, {
    sections = {
      left = { ellipsis },
      right = {
        " ",
        "number_of_folded_lines",
        ": ",
        "percentage",
        " ",
        function(config)
          return config.fill_char:rep(3)
        end,
      },
    },
    fill_char = " ",
  })
end
