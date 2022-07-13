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
            -- ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
            highlight = {
                enable = true,              -- false will disable the whole extension
                disable = {'lua'},          -- list of language that will be disabled
            },
            autotag = {
                enable = true,
            },
        }
    end
}
use {
    "williamboman/nvim-lsp-installer",
    "neovim/nvim-lspconfig",
    config = function()
        require("nvim-lsp-installer").setup {
            automatic_installation = true
        }
    end,
}
local lsp_installer = require("nvim-lsp-installer")
local lspconfig = require("lspconfig")
lsp_installer.on_server_ready(function (server)
    if server.name == 'tsserver' then
        server:setup {root_dir = lspconfig.util.root_pattern("package.json")}
    elseif server.name == 'denols' then
        server:setup {root_dir = lspconfig.util.root_pattern("deno.json"),}
    else
        server:setup {}
    end
end)

use {
  'ojroques/nvim-lspfuzzy',
  requires = {
    {'junegunn/fzf'},
    {'junegunn/fzf.vim'},  -- to enable preview (optional)
  },
  config = function()
      require('lspfuzzy').setup {
          methods = 'all',         -- either 'all' or a list of LSP methods (see below)
          fzf_preview = {          -- arguments to the FZF '--preview-window' option
          'right:+{2}-/2'          -- preview on the right and centered on entry
          },
          fzf_modifier = ':~:.',   -- format FZF entries, see |filename-modifiers|
          fzf_trim = true,         -- trim FZF entries
      }
  end
}

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
  requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
}

use 'andymass/vim-matchup'

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

-- Interactive interface for json files
use 'gennaro-tedesco/nvim-jqx'

-- terminal
use {
    'voldikss/vim-floaterm',
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
    'echasnovski/mini.nvim',
    branch = 'stable',
    config = function()
        require('mini.surround').setup()
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

-- Ack search (vim script)
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
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
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

