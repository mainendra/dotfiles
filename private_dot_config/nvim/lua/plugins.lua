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
            -- picker
            { '<Leader>fl', '<cmd>Pick buf_lines<CR>' },
            { '<Leader>ff', '<cmd>Pick files<CR>' },
            { '<Leader>fg', '<cmd>Pick grep_live<CR>' },
            { '<Leader>fb', '<cmd>Pick buffers<CR>' },
            { '<Leader>fh', '<cmd>Pick help<CR>' },
            { '<Leader>fv', '<cmd>Pick git_files<CR>' },
            { '<Leader>fk', '<cmd>Pick keymaps<CR>' },
            { '<Leader>fc', '<cmd>lua MiniPick.builtin.files(nil, { source={ cwd="~/.config" } })<CR>' },
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
            require('mini.misc').setup()
            require('mini.move').setup()
            require('mini.notify').setup()
            require('mini.operators').setup()
            require('mini.pick').setup()
            require('mini.splitjoin').setup()
            require('mini.statusline').setup()
            require('mini.surround').setup()
            require('mini.trailspace').setup()
            require('mini.visits').setup()

            -- use Mini.pick for vim.ui.select
            vim.ui.select = require('mini.pick').ui_select
        end
    },

    -- emmet
    {
        'mattn/emmet-vim',
        event = { 'BufRead' },
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
        branch = 'harpoon2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = function()
            local harpoon = require('harpoon');
            return {
                { '<Leader>ha', function() harpoon:list():append() end },
                { '<Leader>ht', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end },
                { '<Leader>hn', function() harpoon:list():next() end },
                { '<Leader>hp', function() harpoon:list():prev() end },
            };
        end,
        config = true
    },

    -- startup time
    {
        'dstein64/vim-startuptime',
        cmd = 'StartupTime',
    },

    -- hide env content
    {
        'laytan/cloak.nvim',
        ft = 'env',
        config = true
    },
})
