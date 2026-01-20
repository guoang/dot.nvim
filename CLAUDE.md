# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a heavily customized Neovim configuration built as a full-featured IDE. Based on the LunarVim nvim-basic-ide template but significantly extended with custom plugins and AI integration.

## Plugin Management Commands

Plugin manager: **Packer.nvim**

Run these within Neovim:
- `:PackerSync` - Install/update all plugins (most common)
- `:PackerCompile` - Recompile after changing plugins.lua
- `:PackerStatus` - Show plugin status
- `:checkhealth` - Verify LSP, formatters, and plugin health

Keybindings (leader = space):
- `<leader>PS` - PackerSync
- `<leader>Pc` - PackerCompile
- `<leader>Pu` - PackerUpdate

## Architecture

### Module Loading Pattern
`init.lua` loads ~40 modules from `lua/user/` via `require`. Each module is self-contained:

```
lua/user/
├── plugins.lua          # Packer plugin definitions
├── options.lua          # Neovim settings (tabs=2, no wrap, etc.)
├── keymaps.lua          # Leader-based keybindings
├── autocommands.lua     # Event handlers
├── lsp/                 # LSP configs (mason, null-ls, per-server)
└── [feature].lua        # One file per plugin/feature
```

### Protected Calls Pattern
All plugin configs use this pattern for graceful degradation:
```lua
local status_ok, plugin = pcall(require, "plugin_name")
if not status_ok then
  return
end
plugin.setup({...})
```

### LSP Setup
- **Mason** auto-installs LSP servers (lua_ls, pyright, clangd, etc.)
- Per-server configs in `lua/user/lsp/*.lua`
- **null-ls** handles formatters (prettier, yapf) and linters (markdownlint)

### Keybinding Structure
- `<leader>f*` - Telescope find operations
- `<leader>e*` - File explorer (nvim-tree, aerial)
- `<leader>t*` - Terminal operations
- `<leader>P*` - Packer operations
- `<C-S-h/j/k/l>` - Smart window splits navigation
- `<S-h/l>` - Buffer navigation

## Key Custom Features

1. **Zellij Integration**: Window navigation (`smart-splits.lua`, `utils.lua`) falls back to Zellij pane movement when at Neovim edge

2. **Windows File Sync**: Autocommand in `autocommands.lua` syncs specific directories to Windows machine via SCP on save

3. **AI Integration**: Both Copilot (`copilot.lua`) and CodeCompanion (`codecompanion.lua`) configured
   - `<C-CR>` - Accept Copilot suggestion
   - `<C-f>` - Accept word
   - `<C-e>` - Accept line

4. **Custom Command**: `:Vscode [filepath]` opens file in VSCode (defined in `commands.lua`)

## Editor Settings (options.lua)

- Tab size: 2 spaces (expandtab)
- No line wrapping
- Smart case search
- System clipboard integration
- Colorcolumn: 120 for Python, 80 for C/C++

## Theme

Tokyo Night with custom highlight post-processing in `colorscheme.lua` for different window types (nvim-tree, terminals, help).
