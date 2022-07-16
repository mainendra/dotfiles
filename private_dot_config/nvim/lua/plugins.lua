-------------------- HELPERS ------------------------------

local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local execute = vim.api.nvim_command
local fn = vim.fn

-------------------- PLUGINS ------------------------------

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

-- Only required if you have packer in your `opt` pack
cmd [[packadd packer.nvim]]

require('packer').startup(function()

-- Packer can manage itself as an optional plugin
use {'wbthomason/packer.nvim', opt = true}

use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
        require'nvim-treesitter.configs'.setup {}
    end
}
use {
    'williamboman/nvim-lsp-installer',
    'neovim/nvim-lspconfig',
    config = function()
        require('nvim-lsp-installer').setup {
            automatic_installation = true,
            matchup = {
                enable = true, -- mandatory, false will disable the whole extension
            },
        }
    end,
}
local lsp_installer = require('nvim-lsp-installer')
local lspconfig = require('lspconfig')
lsp_installer.on_server_ready(function (server)
    if server.name == 'tsserver' then
        server:setup {root_dir = lspconfig.util.root_pattern("package.json")}
    elseif server.name == 'denols' then
        server:setup {root_dir = lspconfig.util.root_pattern("deno.json"),}
    else
        server:setup {}
    end
end)

-- improve default vim ui. e.g. code actions
use { 'stevearc/dressing.nvim' }

-- Auto completion
use {
    'ms-jpq/coq_nvim',
    branch = 'coq',
}
use { 'ms-jpq/coq.artifacts', branch = 'artifacts' }
use { 'ms-jpq/coq.thirdparty', branch = '3p' }

-- vim registers
use 'gennaro-tedesco/nvim-peekup'

-- fuzzy finder
use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
    }
}

use {
  'kyazdani42/nvim-tree.lua',
  requires = {
    'kyazdani42/nvim-web-devicons', -- optional, for file icons
  },
  config = function()
      require("nvim-tree").setup()
  end
}

use {
  'lewis6991/gitsigns.nvim',
  requires = {
    'nvim-lua/plenary.nvim'
  },
  config = function()
    require('gitsigns').setup()
  end
}

use {
    'f-person/git-blame.nvim',
}

-- terminal
use {
    'numToStr/FTerm.nvim',
    config = function()
        local fterm = require("FTerm")

        local lazygit = fterm:new({
           cmd = "lazygit",
        })
        local tig = fterm:new({
            cmd = "tig %",
        })

        vim.keymap.set('n', '<Leader>lg', function()
            lazygit:toggle()
        end)
        vim.keymap.set('n', '<Leader>tg', function()
            tig:toggle()
        end)
    end
}

-- Commenting
use {
    'b3nj5m1n/kommentary',
    config = function()
        require('kommentary.config').use_extended_mappings()
    end
}

-- easy motion
use {
    'phaazon/hop.nvim',
    branch='v1',
    config = function()
        require('hop').setup{keys = 'etovxqpdygfblzhckisuran'}
    end
}

use 'kevinhwang91/nvim-hlslens'

use {
    'kylechui/nvim-surround',
    config = function()
        require('nvim-surround').setup{}
    end
}

-- quick fix fzf
use {
    'kevinhwang91/nvim-bqf',
    config = function()
        require('bqf').setup({
            auto_enable = true,
            preview = {
                win_height = 12,
                win_vheight = 12,
                delay_syntax = 80,
                border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'}
            },
            func_map = {
                vsplit = '',
                ptogglemode = 'z,',
                stoggleup = ''
            },
            filter = {
                fzf = {
                    extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}
                }
            }
        })
    end
}

-- Ack search (vim script), TODO: find lua alternative
use 'wincent/ferret'

use {
    'windwp/nvim-autopairs',
    config = function()
       require('nvim-autopairs').setup()
    end
}

use {
    'ellisonleao/gruvbox.nvim',
    config = function()
        require("gruvbox").setup({
            contrast = "hard",
        })
        vim.cmd[[colorscheme gruvbox]]
    end
}

use {
    'mhinz/vim-startify',
}
use 'dstein64/vim-startuptime' -- startup time
use 'markonm/traces.vim' -- search and replace
use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
        require('lualine').setup({
            options = { theme = 'gruvbox' }
        })
    end
}

-- jk to escape
use {
  "max397574/better-escape.nvim",
  config = function()
    require("better_escape").setup()
  end
}

-- create missing directory on save
use {
  "jghauser/mkdir.nvim",
}

end)

