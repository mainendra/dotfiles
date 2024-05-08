-------------------- HELPERS ------------------------------

local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------- MINI DEPS ------------------------------

-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        'git', 'clone', '--filter=blob:none',
        'https://github.com/echasnovski/mini.nvim', mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

local MiniDeps = require('mini.deps')

-- Set up 'mini.deps' (customize to your liking)
MiniDeps.setup({ path = { package = path_package } })

-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
    add({
        source = 'neovim/nvim-lspconfig',
        depends = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'echasnovski/mini.nvim', -- for picker
        }
    })

    require('lsp').setup()
end)

now(function()
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        hooks = {
            post_checkout = function()
                pcall(require('nvim-treesitter.install').update { with_sync = true })
            end
        }
    })

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
end)

now(function()
    add('ellisonleao/gruvbox.nvim')

    require('gruvbox').setup({
        contrast = 'hard',
        invert_selection = true,
    })
    vim.cmd('colorscheme gruvbox')
end)

now(function()
    add('laytan/cloak.nvim')

    require('cloak').setup()
end)

later(function()
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

    -- use Mini.pick for vim.ui.select
    vim.ui.select = require('mini.pick').ui_select
    vim.cmd('highlight MiniPickNormal guibg=NONE')
    vim.cmd('highlight MiniFilesNormal guibg=NONE')

    -- picker
    map('n', '<Leader>fl', '<cmd>Pick buf_lines scope="current"<CR>' , { noremap = true, silent = true })
    map('n', '<Leader>ff', '<cmd>Pick files<CR>' , { noremap = true, silent = true })
    map('n', '<Leader>fg', '<cmd>Pick grep_live<CR>' , { noremap = true, silent = true })
    map('n', '<Leader>fb', '<cmd>Pick buffers<CR>' , { noremap = true, silent = true })
    map('n', '<Leader>fh', '<cmd>Pick git_hunks<CR>' , { noremap = true, silent = true })
    map('n', '<Leader>fv', '<cmd>Pick git_files<CR>' , { noremap = true, silent = true })
    map('n', '<Leader>fk', '<cmd>Pick keymaps<CR>' , { noremap = true, silent = true })
    map('n', '<Leader>fc', '<cmd>lua MiniPick.builtin.files(nil, { source={ cwd="~/.config" } })<CR>' , { noremap = true, silent = true })

    function ShowMiniFiles()
        local files = require('mini.files')
        if not files.close() then
            files.open(vim.api.nvim_buf_get_name(0), false)
            -- files.reveal_cwd()
        else
            files.close()
        end
    end
    map('n', '<Leader>e', '<cmd>lua ShowMiniFiles()<CR>', { noremap = true, silent = true })
end)

later(function()
    add('johmsalas/text-case.nvim')
    require('textcase').setup({ prefix = 'gr' })
end)

later(function()
    add('mattn/emmet-vim')
end)

later(function()
    add({
        source = 'utilyre/barbecue.nvim',
        depends = {
            'SmiteshP/nvim-navic',
            'nvim-tree/nvim-web-devicons', -- optional dependency
        }
    })
    require('barbecue').setup()
end)

later(function()
    add('f-person/git-blame.nvim')
    vim.g['gitblame_date_format'] = '%r' -- relative date
    vim.g['gitblame_enabled'] = 0        -- default disabled
    vim.g['gitblame_delay'] = 10         -- delay in Ms
    vim.cmd('GitBlameToggle')            -- workaround
    map('n', '<Leader>gb', '<cmd>GitBlameToggle<CR>', { noremap = true, silent = true })
end)

later(function()
    add('lewis6991/gitsigns.nvim')
    require('gitsigns').setup()
end)

later(function()
    add('kevinhwang91/nvim-bqf')
end)

later(function()
    add({
        source = 'windwp/nvim-spectre',
        depends = {
            'nvim-lua/plenary.nvim'
        }
    })
    require('spectre').setup({ is_block_ui_break = true, mapping = { ['send_to_qf'] = { map = "<leader>k" } } })
    map('n', '<Leader>st', '<cmd>lua require("spectre").toggle()<CR>', { noremap = true, silent = true })
    map('n', '<Leader>sr', '<cmd>lua require("spectre").open()<CR>', { noremap = true, silent = true })
    map('n', '<Leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { noremap = true, silent = true })
    map('n', '<Leader>sp', '<cmd>lua require("spectre").open_file_search()<CR>', { noremap = true, silent = true })
end)

later(function()
    add({
        source = 'ThePrimeagen/harpoon',
        checkout = 'harpoon2',
        monitor = 'harpoon2',
        depends = { 'nvim-lua/plenary.nvim', 'echasnovski/mini.nvim' }
    })
    local harpoon = require('harpoon');
    harpoon:setup()
    vim.keymap.set("n", "<Leader>ha", function() harpoon:list():add() end)
    vim.keymap.set("n", "<Leader>ht", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
    vim.keymap.set("n", "<Leader>hn", function() harpoon:list():prev() end)
    vim.keymap.set("n", "<Leader>hp", function() harpoon:list():next() end)
end)

later(function()
    add('dstein64/vim-startuptime')
end)

later(function()
    add('alec-gibson/nvim-tetris')
end)

later(function()
    add('lukas-reineke/indent-blankline.nvim')
    require('ibl').setup()
end)

later(function()
    add('michaelrommel/nvim-silicon')

    require('silicon').setup({
        font = "JetBrainsMono Nerd Font=34",
        background = "#00000000",
    })
end)
