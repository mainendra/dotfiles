-------------------- HELPERS ------------------------------

local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local execute = vim.api.nvim_command
local fn = vim.fn

-------------------- PACKER PLUGIN MANAGER ------------------------------

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packadd packer.nvim'
end

-- Only required if you have packer in your `opt` pack
cmd [[packadd packer.nvim]]

-------------------- PLUGINS ------------------------------

require('packer').startup(function()
    -- Packer can manage itself as an optional plugin
    use {'wbthomason/packer.nvim', opt = true}

    use 'folke/neodev.nvim'

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }

    -- Useful status updates for LSP
    use 'j-hui/fidget.nvim'

    use { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        run = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end
    }

    -- Git related plugins
    use 'f-person/git-blame.nvim'
    use {
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        }
    }


    -- theme
    use 'ellisonleao/gruvbox.nvim'
    -- status line
    use 'nvim-lualine/lualine.nvim'
    -- Commenting
    use 'numToStr/Comment.nvim'
    -- Detect tabstop and shiftwidth automatically
    use 'tpope/vim-sleuth'

    -- Fuzzy Finder (files, lsp, etc)
    use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

    -- improve default vim ui. e.g. code actions
    use { 'stevearc/dressing.nvim' }

    -- search and replace
    use {
        'windwp/nvim-spectre',
        requires = {
            'nvim-lua/plenary.nvim'
        }
    }

    -- file explorer
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- for file icons
        },
        tag = 'nightly'
    }

    -- easy motion, jump to
    use {
        'phaazon/hop.nvim',
        branch='v1'
    }
    -- surround motion
    use 'kylechui/nvim-surround'
    -- startup page
    use 'mhinz/vim-startify'
    -- startup time
    use 'dstein64/vim-startuptime'
    -- jk to escape
    use 'max397574/better-escape.nvim'
    -- case convert
    use 'tpope/vim-abolish'
    -- editor config
    use 'gpanders/editorconfig.nvim'


    -- Add custom plugins to packer from /nvim/lua/custom/plugins.lua
    local has_plugins, plugins = pcall(require, 'custom.plugins')
    if has_plugins then
        plugins(use)
    end
end)

