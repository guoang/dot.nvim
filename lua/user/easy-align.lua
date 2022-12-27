-- " Start interactive EasyAlign in visual mode (e.g. vipga)
-- xmap ga <Plug>(EasyAlign)
-- " Start interactive EasyAlign for a motion/text object (e.g. gaip)
-- nmap ga <Plug>(EasyAlign)

vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", {silent = true})
vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", {silent = true})

vim.g.easy_align_delimiters = {
  ["#"] = { pattern = "#", delimiter_align = "l", left_margin = 2 },
}
