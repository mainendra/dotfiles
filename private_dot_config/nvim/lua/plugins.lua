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
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'echasnovski/mini.nvim', -- for picker
        },
        event = { 'BufRead', 'BufNewFile' },
        cmd = 'Mason',
        config = function()
            require('lsp').setup()
        end
    },

    -- utilities. autocomplete, surround, pair, etc ...
    {
        'echasnovski/mini.nvim',
        event = { 'BufRead', 'BufNewFile' },
        version = false,
        cmd = { 'Pick', 'Mason' }, -- mason search requires mini.pick
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
            local notify = require('mini.notify')
            -- disable null-ls notifications
            local filterout = function(notif_arr)
                local prefixes = {'null-ls', 'rust_analyzer'}
                local not_diagnosing = function(notif)
                    for _, prefix in ipairs(prefixes) do
                        if vim.startswith(notif.msg, prefix) then
                            return false
                        end
                    end
                    return true
                end

                notif_arr = vim.tbl_filter(not_diagnosing, notif_arr)
                return notify.default_sort(notif_arr)
            end
            notify.setup({
                content = { sort = filterout },
            })
            require('mini.operators').setup()
            require('mini.pick').setup()
            require('mini.splitjoin').setup()
            require('mini.statusline').setup()
            require('mini.surround').setup()
            require('mini.trailspace').setup()
            require('mini.visits').setup()

            -- use Mini.pick for vim.ui.select
            vim.ui.select = require('mini.pick').ui_select
            vim.cmd('highlight MiniPickNormal guibg=NONE')
            vim.cmd('highlight MiniFilesNormal guibg=NONE')
        end
    },

    -- linter, formatter, etc...
    {
        'nvimtools/none-ls.nvim',
        event = { 'BufRead', 'BufNewFile' },
        config = function()
            local null_ls = require('null-ls')
            null_ls.setup({
                debug = false,
                log_level = 'off',
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.diagnostics.deno_lint,
                    null_ls.builtins.code_actions.gitsigns,
                    null_ls.builtins.code_actions.ltrs,
                    null_ls.builtins.code_actions.refactoring,
                    null_ls.builtins.completion.spell,
                    null_ls.builtins.formatting.deno_fmt,
                    null_ls.builtins.formatting.rustywind,
                    null_ls.builtins.formatting.rustfmt,
                },
            })
        end,
    },

    -- emmet
    {
        'mattn/emmet-vim',
        event = { 'BufRead', 'BufNewFile' },
    },

    -- Highlight, edit, and navigate code
    {
        'nvim-treesitter/nvim-treesitter',
        event = { 'BufRead', 'BufNewFile' },
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
        event = { 'BufRead', 'BufNewFile' },
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
        event = { 'BufRead', 'BufNewFile' },
        config = true,
    },

    -- theme
    {
        'ellisonleao/gruvbox.nvim',
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('gruvbox').setup({
                contrast = 'hard',
                invert_selection = true,
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

    -- games
    {
        'alec-gibson/nvim-tetris',
        cmd = 'Tetris',
    },
}, { install = { colorscheme = { 'gruvbox' } } })
