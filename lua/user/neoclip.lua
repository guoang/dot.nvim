local status_ok, neoclip = pcall(require, "neoclip")
if not status_ok then
  return
end

neoclip.setup({
  keys = {
    telescope = {
      i = {
        select = {},
        paste = "<cr>",
        paste_behind = {},
        replay = "<c-q>", -- replay a macro
        delete = "<c-d>", -- delete an entry
        edit = "<c-e>", -- edit an entry
        custom = {},
      },
      n = {
        select = {},
        paste = { "p", "<cr>" },
        --- It is possible to map to more than one key.
        -- paste = { 'p', '<c-p>' },
        paste_behind = "P",
        replay = "q",
        delete = "d",
        edit = "e",
        custom = {},
      },
    },
  },
})
