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
    require('mini.diff').setup()
    require('mini.extra').setup()
    require('mini.files').setup()
    require('mini.fuzzy').setup()
    require('mini.git').setup()
    require('mini.icons').setup()
    require('mini.indentscope').setup({
        draw = {
            animation = require('mini.indentscope').gen_animation.none()
        }
    })
    require('mini.jump').setup()
    require('mini.jump2d').setup()
    require('mini.misc').setup()
    require('mini.move').setup()
    local notify = require('mini.notify')
    -- disable null-ls notifications
    local filterout = function(notif_arr)
        local prefixes = {'null-ls', 'rust_analyzer', 'jdtl'}
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
    require('mini.pick').setup({
        mappings = {
            move_down  = '<C-j>',
            move_up    = '<C-k>',
        }
    })
    require('mini.splitjoin').setup()
    require('mini.statusline').setup()
    require('mini.surround').setup()
    require('mini.trailspace').setup()
    require('mini.visits').setup()

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
    require('textcase').setup({ prefix = 'ge' })
end)

later(function()
    add({
        source = 'nvimdev/lspsaga.nvim',
        depends = {
            'nvim-treesitter/nvim-treesitter',
            'echasnovski/mini.nvim'
        }
    })
    require('lspsaga').setup({
        definition = {
            keys = {
                edit = 'o'
            }
        },
        lightbulb = {
            enable = false
        }
    })
end)

later(function()
    add('f-person/git-blame.nvim')
    require('gitblame').setup({
        enabled = false,
        date_format = "%r",
        delay = 1,
    })
    map('n', '<Leader>gb', '<cmd>GitBlameToggle<CR>', { noremap = true, silent = true })
    map('n', '<Leader>gc', '<cmd>GitBlameOpenCommitURL<CR>', { noremap = true, silent = true })
end)

later(function()
    add({
        source = 'MagicDuck/grug-far.nvim'
    })
    local grugfar = require('grug-far');
    grugfar.setup({
        keymaps = {
            close = { n = '<localleader>q' },
            qflist = { n = '<localleader>f' },
            historyAdd = { n = '<localleader>ha' },
            historyOpen = { n = '<localleader>ho' },
            syncLocations = { n = '<localleader>sa' },
        },
        startInInsertMode = false,
        windowCreationCommand = 'vertical 65% split',
        history = {
            autoSave = {
                enabled = false,
            },
        },
    })

    local name = 'grug-far-search'
    function OpenGrugFar(param)
        param = param or ''
        local options = {
            instanceName = name,
            prefills = { search = param }
        }
        if grugfar.has_instance(name) then
            grugfar.update_instance_prefills(options.instanceName, options.prefills, false)
            grugfar.open_instance(options.instanceName)
        else
            grugfar.toggle_instance(options)
        end
    end
    function ToggleGrugFar()
        grugfar.toggle_instance({ instanceName = name })
    end

    map('n', '<Leader>sw', '<cmd>lua OpenGrugFar(vim.fn.expand("<cword>"))<CR>', { noremap = true, silent = true })
    map('n', '<Leader>sr', '<cmd>lua OpenGrugFar()<CR>', { noremap = true, silent = true })
    map('n', '<Leader>st', '<cmd>lua ToggleGrugFar()<CR>', { noremap = true, silent = true })
end)

later(function()
    add('dstein64/vim-startuptime')
end)

later(function()
    add('otavioschwanck/arrow.nvim')
    require('arrow').setup({
        show_icons = true,
        leader_key = 'm',
        mappings = {
            next_item = "j",
            prev_item = "k"
        }
    })
end)
