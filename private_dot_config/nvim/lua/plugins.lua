-------------------- PLUGIN MANAGER ------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

-------------------- PLUGINS ------------------------------

require('lazy').setup({    -- Packer can manage itself as an optional plugin
    -- lsp
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',

    -- utilities. autocomplete, surround, pair, etc ...
    {
        'echasnovski/mini.nvim',
        config = function()
            require('mini.align').setup()
            require('mini.comment').setup()
            require('mini.completion').setup()
            require('mini.fuzzy').setup()
            require('mini.jump').setup()
            require('mini.jump2d').setup()
            require('mini.misc').setup()
            require('mini.pairs').setup()
            require('mini.statusline').setup()
            require('mini.surround').setup()
            require('mini.trailspace').setup()
            require('mini.ai').setup()
        end
    },

    -- Useful status updates for LSP
    {
        'j-hui/fidget.nvim',
        config = true,
    },

    { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        build = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
        config = function()
            require('nvim-treesitter.configs').setup({
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                },
                autotag = {
                    enable = true,
                }
            })

            -- folding with treesitter
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        end
    },

    -- two slash queries
    {
        'marilari88/twoslash-queries.nvim',
        keys = {
            { '<Leader>ta', '<cmd>InspectTwoslashQueries<CR>' },
            { '<Leader>tr', '<cmd>RemoveTwoslashQueries<CR>' },
        },
        config = {
            multi_line = true,
            enable = false,
        }
    },

    -- Git related plugins
    {
        'f-person/git-blame.nvim',
        cmd = 'GitBlameToggle',
        keys = { { '<Leader>gb', '<cmd>GitBlameToggle<CR>' } },
        config = function()
            vim.g['gitblame_date_format'] = '%r' -- relative date
            vim.g['gitblame_enabled'] = 0 -- default disabled
        end
    },

    -- theme
    {
        'ellisonleao/gruvbox.nvim',
        config = function()
            require('gruvbox').setup({
                contrast = 'hard',
                transparent_mode = true,
            })
            vim.cmd('colorscheme gruvbox')
        end,
    },

    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',

    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-ui-select.nvim', -- code actions using telescoe
            'tsakirist/telescope-lazy.nvim',
        },
        keys = {
            { '<Leader>fl', '<cmd>Telescope current_buffer_fuzzy_find theme=get_ivy layout_config={height=0.5}<CR>' },
            { '<Leader>ff', '<cmd>Telescope find_files theme=get_ivy layout_config={height=0.5}<CR>' },
            { '<Leader>fg', '<cmd>Telescope live_grep theme=get_ivy layout_config={height=0.5}<CR>' },
            { '<Leader>fb', '<cmd>Telescope buffers theme=get_ivy layout_config={height=0.5}<CR>' },
            { '<Leader>fh', '<cmd>Telescope help_tags theme=get_ivy layout_config={height=0.5}<CR>' },
            { '<Leader>fv', '<cmd>Telescope git_files theme=get_ivy layout_config={height=0.5}<CR>' },
            { '<Leader>fp', '<cmd>Telescope planets theme=get_ivy layout_config={height=0.5}<CR>' },
            { '<Leader>fk', '<cmd>Telescope keymaps theme=get_ivy layout_config={height=0.5}<CR>' },
            { '<Leader>fc', '<cmd>lua require("telescope.builtin").fd(require("telescope.themes").get_ivy({ prompt_title="Find config files", cwd="~/.config", layout_config={height=0.5} }))<CR>' },
            { '<Leader>fz', '<cmd>Telescope lazy theme=get_ivy layout_config={height=0.5}<CR>' },
        },
        config = function()
            require('telescope').setup({
                defaults = {
                    mappings = {
                        i = {
                            ['<C-u>'] = false,
                            ['<C-d>'] = false,
                        },
                    },
                },
            })
            require('telescope').load_extension('ui-select')
            require('telescope').load_extension('lazy')
        end
    },

    -- quick fix list
    {'kevinhwang91/nvim-bqf', ft = 'qf'},

    -- search and replace
    {
        'windwp/nvim-spectre',
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
        keys = {
            { '<Leader>sr', '<cmd>lua require("spectre").open()<CR>' },
            { '<Leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>' },
            { '<Leader>sp', '<cmd>lua require("spectre").open_file_search()<CR>' },
        },
        config = true,
    },

    -- marks
    {
        'ThePrimeagen/harpoon',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            { '<Leader>ha', '<cmd>lua require("harpoon.mark").add_file()<CR>' },
            { '<Leader>ht', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>' },
            { '<Leader>hn', '<cmd>lua require("harpoon.ui").nav_next()<CR>' },
            { '<Leader>hp', '<cmd>lua require("harpoon.ui").nav_prev()<CR>' },
        }
    },

    -- file explorer
    {
        'nvim-tree/nvim-tree.lua',
        cmd = 'NvimTreeFindFileToggle',
        keys = { { '<Leader>e', '<cmd>NvimTreeFindFileToggle<CR>' } },
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly', -- optional, updated every week. (see issue #1193)
        config = {
            respect_buf_cwd = true,
            update_focused_file = {
                enable = true,
                update_cwd = true,
            },
            sort_by = 'case_sensitive',
            view = {
                adaptive_size = true,
                mappings = {
                    list = {
                        { key = 'u', action = 'dir_up' },
                    },
                },
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = true,
            },
        },
    },

    -- startup time
    {
        'dstein64/vim-startuptime',
        cmd = "StartupTime",
    },
    -- jk to escape
    {
        'max397574/better-escape.nvim',
        config = true,
    },
    -- case convert
    {
        'tpope/vim-abolish',
        event = 'VeryLazy',
    }
})
