-------------------- PLUGIN MANAGER ------------------------------

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        '--single-branch',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

-------------------- PLUGINS ------------------------------

require('lazy').setup({
    -- lsp
    {
        'williamboman/mason.nvim',
        lazy = true,
        config = true,
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
        },
        event = { 'BufRead' },
        cmd = 'Mason',
        config = function()
            require('lsp').setup()
        end
    },

    -- utilities. autocomplete, surround, pair, etc ...
    {
        'echasnovski/mini.nvim',
        event = { 'BufRead' },
        version = false,
        cmd = 'Pick',
        keys = {
            {
                '<Leader>e',
                function()
                    local files = require('mini.files')
                    if not files.close() then
                        files.open(vim.api.nvim_buf_get_name(0), false)
                        -- files.reveal_cwd()
                    else
                        files.close()
                    end
                end
            },
            { '<Leader>mm', '<cmd>lua MiniMap.toggle()<CR>' }
        },
        config = function()
            require('mini.ai').setup()
            require('mini.align').setup()
            require('mini.basics').setup()
            require('mini.bracketed').setup()
            require('mini.comment').setup()
            require('mini.completion').setup()
            require('mini.cursorword').setup()
            require('mini.extra').setup()
            require('mini.files').setup()
            require('mini.fuzzy').setup()
            require('mini.jump').setup()
            require('mini.jump2d').setup()
            local map = require('mini.map')
            map.setup({
                integrations = {
                    map.gen_integration.builtin_search(),
                    map.gen_integration.gitsigns(),
                    map.gen_integration.diagnostic(),
                },
                symbols = {
                    encode = map.gen_encode_symbols.shade('2x1')
                },
            })
            require('mini.misc').setup()
            require('mini.move').setup()
            require('mini.operators').setup()
            require('mini.pairs').setup()
            require('mini.pick').setup()
            require('mini.splitjoin').setup()
            require('mini.statusline').setup()
            require('mini.surround').setup()
            require('mini.trailspace').setup()
        end
    },

    -- emmet
    {
        'mattn/emmet-vim',
        event = { 'BufRead' },
    },

    -- Useful status updates for LSP
    {
        'j-hui/fidget.nvim',
        tag = 'legacy',
        config = true,
        event = { 'BufRead' }
    },

    -- Highlight, edit, and navigate code
    {
        'nvim-treesitter/nvim-treesitter',
        event = { 'BufRead' },
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
            vim.opt.foldmethod = 'expr'
            vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
        end
    },

    -- Copilot for neovim
    {
        'Exafunction/codeium.vim',
        keys = {
            { '<Leader>ce', '<cmd>CodeiumEnable<CR>' },
            { '<Leader>cd', '<cmd>CodeiumDisable<CR>' },
        },
        config = function()
            vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true })
        end
    },

    -- A VS Code like winbar for Neovim
    {
        'utilyre/barbecue.nvim',
        name = 'barbecue',
        version = '*',
        event = { 'BufRead' },
        dependencies = {
            'SmiteshP/nvim-navic',
            'nvim-tree/nvim-web-devicons', -- optional dependency
        },
        opts = {
            -- configurations go here
        },
    },

    -- Git related plugins
    {
        'f-person/git-blame.nvim',
        cmd = 'GitBlameToggle',
        keys = { { '<Leader>gb', '<cmd>GitBlameToggle<CR>' } },
        config = function()
            vim.g['gitblame_date_format'] = '%r' -- relative date
            vim.g['gitblame_enabled'] = 0        -- default disabled
            vim.cmd('GitBlameToggle')            -- workaround
        end
    },
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufRead' },
        config = true,
    },

    -- theme
    {
        'ellisonleao/gruvbox.nvim',
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('gruvbox').setup({
                contrast = 'hard',
                transparent_mode = true,
            })
            vim.cmd('colorscheme gruvbox')
        end,
    },

    -- Detect tabstop and shiftwidth automatically
    {
        'tpope/vim-sleuth',
        event = { 'BufRead' }
    },

    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        keys = {
            { '<Leader>ft', '<cmd>Telescope builtin theme=get_ivy layout_config={height=0.5}<CR>' },
            { '<Leader>fl', '<cmd>Telescope current_buffer_fuzzy_find theme=get_ivy layout_config={height=0.5}<CR>' },
            { '<Leader>ff', '<cmd>Telescope find_files theme=get_ivy layout_config={height=0.5}<CR>' },
            { '<Leader>fg', '<cmd>Telescope live_grep theme=get_ivy layout_config={height=0.5}<CR>' },
            { '<Leader>fb', '<cmd>Telescope buffers theme=get_ivy layout_config={height=0.5}<CR>' },
            { '<Leader>fh', '<cmd>Telescope help_tags theme=get_ivy layout_config={height=0.5}<CR>' },
            { '<Leader>fv', '<cmd>Telescope git_files theme=get_ivy layout_config={height=0.5}<CR>' },
            { '<Leader>fp', '<cmd>Telescope planets theme=get_ivy layout_config={height=0.5}<CR>' },
            { '<Leader>fk', '<cmd>Telescope keymaps theme=get_ivy layout_config={height=0.5}<CR>' },
            { '<Leader>fc', '<cmd>lua require("telescope.builtin").fd(require("telescope.themes").get_ivy({ prompt_title="Find config files", cwd="~/.config", hidden = true, layout_config={height=0.5} }))<CR>' },
        },
        cmd = 'Telescope',
        opts = {
            defaults = {
                mappings = {
                    i = {
                        ['<C-u>'] = false,
                        ['<C-d>'] = false,
                    },
                },
            },
        }
    },

    -- ui select and input
    {
        'stevearc/dressing.nvim',
        event = { 'BufRead' },
    },

    -- quick fix list
    {
        'kevinhwang91/nvim-bqf',
        ft = 'qf'
    },

    -- search and replace
    {
        'windwp/nvim-spectre',
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
        keys = {
            { '<Leader>st', '<cmd>lua require("spectre").toggle()<CR>' },
            { '<Leader>sr', '<cmd>lua require("spectre").open()<CR>' },
            { '<Leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>' },
            { '<Leader>sp', '<cmd>lua require("spectre").open_file_search()<CR>' },
        },
        opts = { is_block_ui_break = true, mapping = { ['send_to_qf'] = { map = "<leader>k" } } },
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

    -- startup time
    {
        'dstein64/vim-startuptime',
        cmd = 'StartupTime',
    },
    -- jk to escape
    {
        'max397574/better-escape.nvim',
        event = 'InsertEnter',
        config = true,
    },
    -- case convert
    {
        'tpope/vim-abolish',
        event = { 'BufRead' },
    },
})
