-- Shorten function name
local keymap = vim.keymap.set

--Remap space as leader key
keymap("", "<Space>", "<Nop>", { silent = true, desc = "<leader>" })
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Navigate windows
keymap("n", "<C-h>", "<C-w>h",             { silent = true, desc = "move to window on the left"  })
keymap("n", "<C-l>", "<C-w>l",             { silent = true, desc = "move to window on the right" })
keymap("n", "<C-j>", "<C-w>j",             { silent = true, desc = "move to window below"        })
keymap("n", "<C-k>", "<C-w>k",             { silent = true, desc = "move to window above"        })
keymap('t', '<C-h>', [[<C-\><C-n><C-W>h]], { silent = true, noremap = true                       })
keymap('t', '<C-j>', [[<C-\><C-n><C-W>j]], { silent = true, noremap = true                       })
keymap('t', '<C-k>', [[<C-\><C-n><C-W>k]], { silent = true, noremap = true                       })
keymap('t', '<C-l>', [[<C-\><C-n><C-W>l]], { silent = true, noremap = true                       })

-- Navigate buffers
keymap("n", "<S-l>", "<cmd>lua require'user.bufferline'.buffer_next()<cr>", { silent = true, desc = "buffer next" })
keymap("n", "<S-h>", "<cmd>lua require'user.bufferline'.buffer_prev()<cr>", { silent = true, desc = "buffer prev" })

-- Navigate tabs
keymap("n", "<tab>", "<cmd>tabnext<cr>", { silent = true, desc = "tab next"})
keymap("n", "<S-tab>", "<cmd>tabprevious<cr>", { silent = true, desc = "tab previous"})

-- Navigate in Insert Mode
keymap({"i", "c"}, "<C-b>", "<left>",  { silent = true, desc = "<left>"  })
keymap({"i", "c"}, "<C-f>", "<right>", { silent = true, desc = "<right>" })
keymap({"i", "c"}, "<C-e>", "<end>",   { silent = true, desc = "<end>"   })
keymap({"i", "c"}, "<C-a>", "<home>",  { silent = true, desc = "<home>"  })
keymap({"c"}, "<C-p>", "<up>",    { silent = true, desc = "prev cmd"  })
keymap({"c"}, "<C-n>", "<down>",  { silent = true, desc = "next cmd"  })

-- Resize with arrows
keymap("n", "<C-Up>",    ":resize -2<cr>",                 { silent = true, desc = "resize- horizontal" })
keymap("n", "<C-Down>",  ":resize +2<cr>",                 { silent = true, desc = "resize+ horizontal" })
keymap("n", "<C-Left>",  ":vertical resize -2<cr>",        { silent = true, desc = "resize- vertical"   })
keymap("n", "<C-Right>", ":vertical resize +2<cr>",        { silent = true, desc = "resize+ vertical"   })
keymap("n", "<C-,>",     ":vertical resize -2<cr>",        { silent = true, desc = "resize- vertical"   })
keymap("n", "<C-.>",     ":vertical resize +2<cr>",        { silent = true, desc = "resize+ vertical"   })
keymap("t", "<C-Up>",    [[<Cmd>:resize -2<CR>]],          { silent = true, noremap = true              })
keymap("t", "<C-Down>",  [[<Cmd>:resize +2<CR>]],          { silent = true, noremap = true              })
keymap("t", "<C-Left>",  [[<Cmd>:vertical resize -2<CR>]], { silent = true, noremap = true              })
keymap("t", "<C-Right>", [[<Cmd>:vertical resize +2<CR>]], { silent = true, noremap = true              })
keymap("t", "<C-,>",     [[<Cmd>:vertical resize -2<CR>]], { silent = true, noremap = true              })
keymap("t", "<C-.>",     [[<Cmd>:vertical resize +2<CR>]], { silent = true, noremap = true              })

-- Better paste
keymap("v", "p", '"_dP', { silent = true, desc = "better paste" })

-- Esc
keymap('n', '<F1>', "<Esc>",        { silent = true, noremap = true })
keymap('i', '<F1>', "<Esc>",        { silent = true, noremap = true })
keymap('t', '<F1>', [[<C-\><C-n>]], { silent = true, noremap = true })

-- Stay in indent mode
keymap("v", "<", "<gv", { silent = true, desc = "indent -" })
keymap("v", ">", ">gv", { silent = true, desc = "indent +" })

-- Packer
keymap("n", "<leader>Pc", "<cmd>PackerCompile<cr>",                            { silent = true, desc = "packer Compile" })
keymap("n", "<leader>Pi", "<cmd>PackerInstall<cr>",                            { silent = true, desc = "packer Install" })
keymap("n", "<leader>PS", "<cmd>source lua/user/plugins.lua | PackerSync<cr>", { silent = true, desc = "packer Sync"    })
keymap("n", "<leader>Ps", "<cmd>PackerStatus<cr>",                             { silent = true, desc = "packer Status"  })
keymap("n", "<leader>Pu", "<cmd>PackerUpdate<cr>",                             { silent = true, desc = "packer Update"  })

-- Nvim-tree
keymap("n", "<leader>ee", "<cmd>NvimTreeToggle<cr>", { silent = true, desc = "Explorer files" })
keymap("n", "<leader>es", "<cmd>AerialToggle<cr>", { silent = true, desc = "Explorer Symbols" })
keymap("n", "<leader>eb", "<cmd>BlameToggle<cr>", { silent = true, desc = "Explorer Blame" })
keymap("n", "<leader>eq", "<cmd>lua require('user.utils').toggle_qf()<cr>", { silent = true, desc = "Explorer Quickfix" })

-- Lightspeed
-- use s/x/gs/f/t by default

-- Comment
-- <leader>c*, see comment.lua

-- Find and open things
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>",                                            { silent = true, desc = "find Files"                  })
keymap("n", "<leader>fp", "<cmd>Telescope projects<cr>",                                              { silent = true, desc = "find Projects"               })
keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",                                              { silent = true, desc = "find Recent files"           })
keymap("n", "<leader>fl", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { silent = true, desc = "find by Live grep"           })
keymap("n", "<leader>fw", "<cmd>Telescope grep_string<cr>",                                           { silent = true, desc = "find Word under the cursor"  })
keymap("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",                                  { silent = true, desc = "find lsp document Symbols"   })
keymap("n", "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",                         { silent = true, desc = "find lsp workspace Symbols"  })
keymap("n", "<leader>ft", "<cmd>Telescope treesitter<cr>",                                            { silent = true, desc = "find symbols by Treesitter"  })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>",                                               { silent = true, desc = "find Buffers"                })
keymap("n", "<leader>fM", "<cmd>Telescope man_pages<cr>",                                             { silent = true, desc = "find Man pages"              })
keymap("n", "<leader>fR", "<cmd>Telescope registers<cr>",                                             { silent = true, desc = "find Registers"              })
keymap("n", "<leader>fc", "<cmd>Telescope commands<cr>",                                              { silent = true, desc = "find vim Commands"           })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",                                             { silent = true, desc = "find vim Help"               })
keymap("n", "<leader>fk", "<cmd>Telescope keymaps<cr>",                                               { silent = true, desc = "find vim Keymaps"            })
keymap("n", "<leader>fa", "<cmd>Telescope autocommands<cr>",                                          { silent = true, desc = "find vim Auto commands"      })

-- Terminal
-- keymap("n", "<leader>tf", "<cmd>exe v:count1 . 'ToggleTerm direction=float'<cr>",   { silent = true, desc = "terminal toggle Float" })
-- keymap("n", "<leader>th", "<cmd>exe v:count1 . 'ToggleTerm direction=horizontal'<cr>", { silent = true, desc = "terminal toggle Horizontal" })
-- keymap("n", "<leader>tv", "<cmd>exe v:count1 . 'ToggleTerm direction=vertical'<cr>",   { silent = true, desc = "terminal toggle Vertical" })
-- keymap("n", "<leader>tH", "<cmd>exe 1 . 'ToggleTerm direction=horizontal'<cr><cmd>exe 2 . 'ToggleTerm direction=horizontal'<cr>", { silent = true, desc = "terminal toggle 2 Horizontal" })
-- keymap("n", "<leader>tV", "<cmd>exe 1 . 'ToggleTerm direction=vertical'<cr><cmd>exe 2 . 'ToggleTerm direction=vertical'<cr>",   { silent = true, desc = "terminal toggle 2 Vertical" })
-- keymap("n", "<leader>tp", "<cmd>lua require('user.toggleterm').python()<cr>",   { silent = true, desc = "terminal Python" })

-- Trouble
keymap("n", "<leader>tt", "<cmd>Trouble<cr>", { silent = true, desc = "trouble telescope" })
keymap("n", "<leader>td", "<cmd>Trouble diagnostics<cr>", { silent = true, desc = "trouble diagnostics" })
keymap("n", "<leader>tq", "<cmd>Trouble qflist<cr>", { silent = true, desc = "trouble quickfix" })
keymap("n", "<leader>tl", "<cmd>Trouble loclist<cr>", { silent = true, desc = "trouble loclist" })

-- Git
keymap("n", "<leader>gl", "<cmd>lua require('user.toggleterm').lazygit()<cr>",  { silent = true, desc = "git Lazygit"         })
keymap("n", "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>",       { silent = true, desc = "git Next Hunk"       })
keymap("n", "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>",       { silent = true, desc = "git Prev Hunk"       })
keymap("n", "<leader>gn", "<cmd>lua require 'gitsigns'.next_hunk()<cr>",       { silent = true, desc = "git Next Hunk"       })
keymap("n", "<leader>gp", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>",       { silent = true, desc = "git Prev Hunk"       })
keymap("n", "<leader>gB", "<cmd>lua require 'gitsigns'.blame_line()<cr>",      { silent = true, desc = "git Blame"           })
keymap("n", "<leader>gP", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>",    { silent = true, desc = "git Preview Hunk"    })
keymap("n", "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",      { silent = true, desc = "git Reset Hunk"      })
keymap("n", "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",    { silent = true, desc = "git Reset Buffer"    })
keymap("n", "<leader>gS", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",      { silent = true, desc = "git Stage Hunk"      })
keymap("n", "<leader>gU", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", { silent = true, desc = "git Undo Stage Hunk" })
keymap("n", "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>",                   { silent = true, desc = "git Diff"            })
keymap("n", "<leader>gs", "<cmd>Telescope git_status<cr>",                     { silent = true, desc = "git Status"          })
keymap("n", "<leader>gb", "<cmd>Telescope git_branches<cr>",                   { silent = true, desc = "git Branches"        })
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<cr>",                    { silent = true, desc = "git Commits"         })

-- Spectre
keymap("n", "<leader>SS", "viw:lua require('spectre').open()<cr>",             { silent = true, desc = "spectre Substitute" })

-- LSP
keymap("n", "<leader>li", "<cmd>LspInfo<cr>",                            { silent = true, desc = "lsp Info"              })
keymap("n", "<leader>lI", "<cmd>Mason<cr>",                              { silent = true, desc = "lsp Install"           })
keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>",      { silent = true, desc = "lsp code Action"       })
keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<cr>", { silent = true, desc = "lsp Format"            })
keymap('v', '<Leader>lf', "<cmd>lua vim.lsp.buf.format()<cr>",           { silent = true, desc = "lsp Format selected text" })
keymap("n", "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>",         { silent = true, desc = "lsp CodeLens Action"   })
keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>",           { silent = true, desc = "lsp Rename"            })
keymap("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<cr>",   { silent = true, desc = "lsp Signature"         })

keymap("n", "KK", "<cmd>lua vim.lsp.buf.hover()<CR>",          { silent = true, noremap = true, desc = "hover doc"         })
keymap("n", "KD", "<cmd>DevDocsUnderCursor<CR>",               { silent = true, noremap = true, desc = "open devDocs"      })
keymap("n", "Kd", "<cmd>DevDocsAllUnderCursor<CR>",            { silent = true, noremap = true, desc = "open devDocs"      })
keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>",     { silent = true, noremap = true, desc = "go Definition"     })
keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>",    { silent = true, noremap = true, desc = "go Declaration"    })
keymap("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", { silent = true, noremap = true, desc = "go Implementation" })
keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>",     { silent = true, noremap = true, desc = "go References"     })

-- DAP
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>",          { silent = true, desc = "dap Continue"          })
keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", { silent = true, desc = "dap toggle Breakpoint" })
keymap("n", "<leader>dB", "<cmd>lua require'dap'.clear_breakpoints()<cr>", { silent = true, desc = "dap clear Breakpoint"  })
keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>",         { silent = true, desc = "dap step In"           })
keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>",         { silent = true, desc = "dap step Over"         })
keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>",          { silent = true, desc = "dap step Out"          })
keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>",       { silent = true, desc = "dap toggle Repl"       })
keymap("n", "<leader>dR", "<cmd>lua require'dap'.run_last()<cr>",          { silent = true, desc = "dap Run last"          })
keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>",         { silent = true, desc = "dap Terminate"         })
keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>",          { silent = true, desc = "dap toggle Ui"         })

-- Diagnostic
keymap("n", "<leader>df", "<cmd>lua vim.diagnostic.open_float()<CR>", { silent = true, desc = "diagnostic Float" })
keymap("n", "<leader>dj", "<cmd>lua vim.diagnostic.goto_next()<cr>",  { silent = true, desc = "diagnostic Next " })
keymap("n", "<leader>dk", "<cmd>lua vim.diagnostic.goto_prev()<cr>",  { silent = true, desc = "diagnostic Prev " })
keymap("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<cr>",  { silent = true, desc = "diagnostic Next " })
keymap("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<cr>",  { silent = true, desc = "diagnostic Prev " })
keymap("n", "<leader>dd", "<cmd>Telescope diagnostics bufnr=0<cr>",   { silent = true, desc = "lsp document Diagnostics"  })
keymap("n", "<leader>dw", "<cmd>Telescope diagnostics<cr>",           { silent = true, desc = "lsp workspace Diagnostics" })

-- Switches
keymap("n", "<leader>ss", "<cmd>Switch<cr>",                                          { silent = true, desc = "switch by Switch" })
keymap("n", "<leader>si", "<Plug>ImSelect_toggle_auto_insert",                        { silent = true, desc = "switch Im-select auto insert" })
keymap("n", "<leader>sd", "<cmd>lua require('user.switch').switch_diagnostic()<cr>",  { silent = true, desc = "switch Diagnostic visible" })
keymap("n", "<leader>sc", "<cmd>lua require('user.switch').switch_column()<cr>",      { silent = true, desc = "switch colorColumn" })
keymap("n", "<leader>sS", "<cmd>lua require('user.switch').switch_spell_check()<cr>", { silent = true, desc = "switch Spell checking" })
keymap("n", "<leader>sh", "<cmd>nohlsearch<cr>",                                      { silent = true, desc = "switch search Highlight" })

-- Cmp
keymap("n", "<leader>cc", "<cmd>lua require('user.cmp').cmp_toggle_source('copilot')<cr>", { silent = true, desc = "Cmp toggle source copilot" })
keymap("n", "<leader>cs", "<cmd>lua require('user.cmp').cmp_toggle_source('luasnip')<cr>", { silent = true, desc = "Cmp toggle source snip" })
keymap("n", "<leader>cb", "<cmd>lua require('user.cmp').cmp_toggle_source('browser')<cr>", { silent = true, desc = "Cmp toggle source browser" })
keymap("n", "<leader>cl", "<cmd>lua require('user.cmp').cmp_toggle_source('look')<cr>",    { silent = true, desc = "Cmp toggle source look" })

-- Copilot
keymap("i", "<C-l>",     "<cmd>lua require('user.copilot').accept_all()<cr>",      { silent = true, desc = "copilot accept suggestion" })
keymap("i", "<C-Space>", "<cmd>lua require('user.copilot').toggle_suggest()<cr>", { silent = true, desc = "copilot toggle suggestion" })

-- Telekasten
-- keymap("n", "<leader>zz", "<cmd>lua require('telekasten').panel()<cr>",                     { silent = true, noremap = true, desc = "Zettelkasten panel" })
-- keymap("n", "<leader>zf", "<cmd>lua require('telekasten').find_notes()<cr>",                { silent = true, noremap = true, desc = "zettelkasten Find notes" })
-- keymap("n", "<leader>zg", "<cmd>lua require('telekasten').search_notes()<cr>",              { silent = true, noremap = true, desc = "zettelkasten Grep notes" })
-- keymap("n", "<leader>zl", "<cmd>lua require('telekasten').follow_link()<cr>",               { silent = true, noremap = true, desc = "zettelkasten follow Link" })
-- keymap("n", "<leader>zL", "<cmd>lua require('telekasten').insert_link({ i=true })<cr>",     { silent = true, noremap = true, desc = "zettelkasten insert Link" })
-- keymap("n", "<leader>zd", "<cmd>lua require('telekasten').find_daily_notes()<cr>",          { silent = true, noremap = true, desc = "zettelkasten find Daily" })
-- keymap("n", "<leader>zD", "<cmd>lua require('telekasten').goto_today()<cr>",                { silent = true, noremap = true, desc = "zettelkasten go toDay" })
-- keymap("n", "<leader>zw", "<cmd>lua require('telekasten').find_weekly_notes()<cr>",         { silent = true, noremap = true, desc = "zettelkasten find Weekly" })
-- keymap("n", "<leader>zW", "<cmd>lua require('telekasten').goto_thisweek()<cr>",             { silent = true, noremap = true, desc = "zettelkasten go Weekly" })
-- keymap("n", "<leader>zn", "<cmd>lua require('telekasten').new_note()<cr>",                  { silent = true, noremap = true, desc = "zettelkasten new Note" })
-- keymap("n", "<leader>zN", "<cmd>lua require('telekasten').new_templated_note()<cr>",        { silent = true, noremap = true, desc = "zettelkasten new templated Note" })
-- keymap("n", "<leader>zr", "<cmd>lua require('telekasten').rename_note()<cr>",               { silent = true, noremap = true, desc = "zettelkasten Rename note" })
-- keymap("n", "<leader>zy", "<cmd>lua require('telekasten').yank_notelink()<cr>",             { silent = true, noremap = true, desc = "zettelkasten Yank note link" })
-- keymap("n", "<leader>zc", "<cmd>lua require('telekasten').show_calendar()<cr>",             { silent = true, noremap = true, desc = "zettelkasten show calendar" })
-- keymap("n", "<leader>zi", "<cmd>lua require('telekasten').paste_img_and_link()<cr>",        { silent = true, noremap = true, desc = "zettelkasten paste Img and link" })
-- keymap("n", "<leader>zI", "<cmd>lua require('telekasten').insert_img_link({ i=true })<cr>", { silent = true, noremap = true, desc = "zettelkasten insert img link" })
-- keymap("n", "<leader>zb", "<cmd>lua require('telekasten').show_backlinks()<cr>",            { silent = true, noremap = true, desc = "zettelkasten show backlinks" })
-- keymap("n", "<leader>zF", "<cmd>lua require('telekasten').find_friends()<cr>",              { silent = true, noremap = true, desc = "zettelkasten find Friends" })
-- keymap("n", "<leader>zp", "<cmd>lua require('telekasten').preview_img()<cr>",               { silent = true, noremap = true, desc = "zettelkasten preview img" })
-- keymap("n", "<leader>zm", "<cmd>lua require('telekasten').browse_media()<cr>",              { silent = true, noremap = true, desc = "zettelkasten browse media" })
-- keymap("n", "<leader>zt", "<cmd>lua require('telekasten').show_tags()<cr>",                 { silent = true, noremap = true, desc = "zettelkasten show tags" })

-- Buffer
keymap("n", "<leader>bq", "<cmd>Bwipeout<cr>", { silent = true, noremap = true, desc = "buffer Quit" })
keymap("n", "<leader>bp", "<cmd>BufferLinePick<cr>", { silent = true, noremap = true, desc = "buffer Pick" })
keymap("n", "<leader>bc", "<cmd>BufferLineCloseOthers<cr>", { silent = true, noremap = true, desc = "buffer Clear" })
keymap("n", "<leader>bz", "<cmd>lua require('user.bufferline').buffer_group_toggle()<cr>", { silent = true, noremap = true, desc = "buffer toggle Folder" })

-- Dispatch
keymap("n", "<leader><cr>", "<cmd>w | Make %<cr>", { silent = true, noremap = true, desc = "dispatch" })
keymap("n", "<leader>mi", "<cmd>w | Make install<cr>", { silent = true, noremap = true, desc = "dispatch make install" })
keymap("n", "<leader>mt", "<cmd>w | Make test<cr>", { silent = true, noremap = true, desc = "dispatch make test" })

-- neoclip
keymap("n", "<C-p>", "<cmd>Telescope neoclip<cr>", { silent = true, noremap = true, desc = "neoclip paste" })
