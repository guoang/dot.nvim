local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
  git = {
    clone_timeout = 300, -- Timeout, in seconds, for git clones
  },
})

-- Disable builtin plugins
local disable_builtin_plugins = {
  "matchit",
  "netrwPlugin",
}
for _, plugin in pairs(disable_builtin_plugins) do
  vim.g["loaded_" .. plugin] = 1
end

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use({ "wbthomason/packer.nvim" }) -- Have packer manage itself
  use({ "nvim-lua/plenary.nvim" })  -- Useful lua functions used by lots of plugins
  use({ "windwp/nvim-autopairs" })  -- Autopairs, integrates with both cmp and treesitter
  use({ "numToStr/Comment.nvim" })
  use({ "JoosepAlviste/nvim-ts-context-commentstring" })
  use({ "nvim-tree/nvim-web-devicons" })
  use({ "nvim-tree/nvim-tree.lua" })
  use({ "ahmedkhalf/project.nvim" })
  use({ "akinsho/bufferline.nvim" })
  use({ "famiu/bufdelete.nvim" })
  use({ "nvim-lualine/lualine.nvim" })
  use({ "akinsho/toggleterm.nvim" })
  use({ "lewis6991/impatient.nvim" })
  use({ "lukas-reineke/indent-blankline.nvim" })
  use({ "junegunn/vim-easy-align" })
  use({
    "wellle/targets.vim",
    config = function()
      -- Seek: Only consider targets around cursor
      vim.g.targets_seekRanges = "cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB"
    end,
  })
  use({ 'echasnovski/mini.icons' })
  use({ "folke/which-key.nvim" })
  use({ "folke/trouble.nvim" })
  use({
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup()
    end,
  })
  use({ "ggandor/lightspeed.nvim" })
  use({ "andymass/vim-matchup", event = "VimEnter" })
  use({ "nvim-pack/nvim-spectre" })
  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  })
  -- use({
  --   "OXY2DEV/markview.nvim",
  --   config = function()
  --     require("markview").setup({
  --       preview = {
  --         filetypes = { "markdown", "codecompanion" },
  --         ignore_buftypes = {},
  --       }
  --     })
  --   end
  -- })
  use({ "dstein64/vim-startuptime" })
  -- use({ "tweekmonster/startuptime.vim" })
  use({ "RRethy/vim-illuminate" })
  use({ "tpope/vim-surround" })
  use({ "tpope/vim-dadbod", opt = true, cmd = { "DB" } })
  use({ "tpope/vim-abolish" })
  use({ "tpope/vim-repeat" })
  use({
    "tpope/vim-dispatch",
    opt = true,
    cmd = { "Dispatch", "Make", "Focus", "Start" },
    config = function()
      vim.g.dispatch_no_maps = 1
    end,
  })
  use({ "rmagatti/auto-session" })
  use({ "AndrewRadev/switch.vim" })
  use({ "kevinhwang91/nvim-bqf", ft = "qf" })
  use({ "AckslD/nvim-neoclip.lua" })
  use({ "anuvyklack/pretty-fold.nvim" })
  use({
    "anuvyklack/fold-preview.nvim",
    requires = "anuvyklack/keymap-amend.nvim",
    config = function()
      require("fold-preview").setup({})
    end,
  })
  use({ "stevearc/aerial.nvim" })
  use({ "goolord/alpha-nvim" })

  use({ "guoang/im-select.nvim" })
  use({ "j-hui/fidget.nvim" })

  -- AI
  -- use { "zbirenbaum/copilot.lua" }
  -- use({ "git@code.byted.org:chenjiaqi.cposture/codeverse.vim.git" })
  use({
    -- "olimorris/codecompanion.nvim",
    "~/git/codecompanion.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "j-hui/fidget.nvim", -- Display status
    },
  })

  -- Colorschemes
  use({ "xiyaowong/nvim-transparent" })
  use({ "sainnhe/sonokai" })
  use({ "folke/tokyonight.nvim" })

  use({ "cocopon/iceberg.vim" })
  use({ "shaunsingh/nord.nvim" })
  use({ "catppuccin/nvim" })
  -- use({ "lunarvim/darkplus.nvim" })
  -- use({ "navarasu/onedark.nvim" })
  -- use({ "rafamadriz/neon" })
  -- use({ "glepnir/zephyr-nvim" })

  -- cmp plugins
  use({ "hrsh7th/nvim-cmp" })         -- The completion plugin
  use({ "hrsh7th/cmp-buffer" })       -- buffer completions
  use({ "hrsh7th/cmp-path" })         -- path completions
  use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions
  use({ "hrsh7th/cmp-nvim-lsp" })
  use({ "hrsh7th/cmp-nvim-lsp-signature-help" })
  use({ "hrsh7th/cmp-nvim-lsp-document-symbol" })
  use({ "hrsh7th/cmp-nvim-lua" })
  use({ "hrsh7th/cmp-cmdline" })
  -- use({ "dmitmel/cmp-cmdline-history" })
  use({ "petertriho/cmp-git" })
  use({
    "wxxxcxx/cmp-browser-source",
    config = function()
      require("cmp-browser-source").start_server()
    end,
  })
  use({ "octaltree/cmp-look" })
  use({ "kristijanhusak/vim-dadbod-completion" })
  use({ "onsails/lspkind.nvim" })

  -- snippets
  use({ "L3MON4D3/LuaSnip" })             --snippet engine
  use({ "rafamadriz/friendly-snippets" }) -- a bunch of snippets to use

  -- LSP
  use({ "neovim/nvim-lspconfig" }) -- enable LSP
  use({ "williamboman/mason.nvim" })
  use({ "williamboman/mason-lspconfig.nvim" })
  use({ "nvimtools/none-ls.nvim" }) -- for formatters and linters

  -- Telescope
  use({ "nvim-telescope/telescope.nvim" })
  use({
    "nvim-telescope/telescope-fzf-native.nvim",
    run =
    "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  })
  use({ "nvim-telescope/telescope-symbols.nvim" })
  use({ "nvim-telescope/telescope-ui-select.nvim" })
  use({ "nvim-telescope/telescope-live-grep-args.nvim" })

  -- Treesitter
  use({ "nvim-treesitter/nvim-treesitter" })
  use({ "nvim-treesitter/nvim-treesitter-textobjects" })
  use({ "nvim-treesitter/playground" })

  -- Git
  use({ "lewis6991/gitsigns.nvim" })
  use({ "FabijanZulj/blame.nvim" })

  -- DAP
  use({ "mfussenegger/nvim-dap" })
  use({ "rcarriga/nvim-dap-ui" })

  -- Telekasten
  -- use({ "renerocksai/telekasten.nvim" })
  -- use({ "renerocksai/calendar-vim" })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
