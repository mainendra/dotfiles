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
        require'nvim-treesitter.configs'.setup {
            -- ensure_installed = 'all',
            auto_install = true,
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
            autotag = {
                enable = true,
            }
        }
    end
}

-- Auto completion
use {
    'ms-jpq/coq_nvim',
    branch = 'coq',
}
use { 'ms-jpq/coq.artifacts', branch = 'artifacts' }
use { 'ms-jpq/coq.thirdparty', branch = '3p' }

use {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig'
}
require('mason').setup()
require('mason-lspconfig').setup({
    automatic_installation = true
})
require('mason-lspconfig').setup_handlers {
    function (server_name)
        local lspconfig = require('lspconfig')
        local coq = require 'coq'
        if server_name == 'tsserver' then
            lspconfig[server_name].setup(coq.lsp_ensure_capabilities{root_dir = lspconfig.util.root_pattern('package.json')})
        elseif server_name == 'denols' then
            lspconfig[server_name].setup(coq.lsp_ensure_capabilities{root_dir = lspconfig.util.root_pattern('deno.json'), single_file_support = false})
        else
            lspconfig[server_name].setup(coq.lsp_ensure_capabilities{})
        end
    end
}

-- improve default vim ui. e.g. code actions
use { 'stevearc/dressing.nvim' }

use {
    'kevinhwang91/nvim-ufo',
    requires = 'kevinhwang91/promise-async'
}

-- vim registers
use 'gennaro-tedesco/nvim-peekup'

-- search and replace
use {
    'windwp/nvim-spectre',
    requires = {
        'nvim-lua/plenary.nvim'
    },
    config = function()
        require('spectre').setup()
    end
}

-- fuzzy finder
use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
    }
}

use {
    'nvim-telescope/telescope-file-browser.nvim',
    config = function()
        require('telescope').load_extension('file_browser')
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
        local fterm = require('FTerm')

        local lazygit = fterm:new({
           cmd = 'lazygit',
        })
        local tig = fterm:new({
            cmd = 'tig %',
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

use {
    'kevinhwang91/nvim-hlslens',
    config = function()
        require('hlslens').setup()
    end
}

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

use {
    'windwp/nvim-autopairs',
    config = function()
       require('nvim-autopairs').setup()
    end
}

use {
    'ellisonleao/gruvbox.nvim',
    config = function()
        require('gruvbox').setup({
            contrast = 'hard',
        })
        vim.cmd[[colorscheme gruvbox]]
    end
}

use {
    'mhinz/vim-startify',
}
use 'dstein64/vim-startuptime' -- startup time
-- use 'markonm/traces.vim' -- search and replace
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
  'max397574/better-escape.nvim',
  config = function()
    require('better_escape').setup()
  end
}

-- create missing directory on save
use {
  'jghauser/mkdir.nvim',
}

-- case convert
use {
    'tpope/vim-abolish',
}

-- editor config
use {
    'gpanders/editorconfig.nvim'
}

end)

