-------------------- HELPERS ------------------------------

local map = vim.keymap.set  -- new function for keymap

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
        palette_overrides = {
            dark0_hard = "#1b1b1b",
        },
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
    local hipatterns = require('mini.hipatterns')
    hipatterns.setup({
        highlighters = {
            -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
            fixme = { pattern = '%f[%w]()[Ff][Ii][Xx][Mm][Ee]()%f[%W]', group = 'MiniHipatternsFixme' },
            hack  = { pattern = '%f[%w]()[Hh][Aa][Cc][Kk]()%f[%W]',  group = 'MiniHipatternsHack'  },
            todo  = { pattern = '%f[%w]()[Tt][Oo][Dd][Oo]()%f[%W]',  group = 'MiniHipatternsTodo'  },
            note  = { pattern = '%f[%w]()[Nn][Oo][Tt][Ee]()%f[%W]',  group = 'MiniHipatternsNote'  },

            -- Highlight hex color strings (`#rrggbb`) using that color
            hex_color = hipatterns.gen_highlighter.hex_color(),
        },
    })
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
    require('mini.splitjoin').setup() -- gS -> toggle
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
        },
        symbol_in_winbar = {
            enable = false
        }
    })
    map('n', '<Leader>tt', '<cmd>Lspsaga term_toggle<CR>', { noremap=true, silent=true })
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
    add('FabijanZulj/blame.nvim')
    require('blame').setup()
end)

later(function()
    add('mangelozzi/rgflow.nvim')
    require('rgflow').setup( {
        cmd_flags = "--smart-case --fixed-strings --ignore --max-columns 200",
        default_trigger_mappings = true,
        default_ui_mappings = true,
        default_quickfix_mappings = true,
    })
    -- enable cfilter
    vim.cmd('packadd cfilter')
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

later(function()
    add('github/copilot.vim')
    function ToggleCopilot()
        local copilot_status = vim.fn.execute("Copilot status")
        copilot_status = string.gsub(copilot_status, "\n", "")
        copilot_status = string.lower(copilot_status)

        if string.match(copilot_status, "%Cready") then
            vim.cmd("Copilot disable")
        else
            vim.cmd("Copilot enable")
        end
    end
    map('n', '<Leader>tc', '<cmd>lua ToggleCopilot()<CR>', { noremap = true, silent = true })
    -- default disable
    vim.cmd('Copilot disable')
end)

-- note taking

later(function()
    add('zk-org/zk-nvim')
    require('zk').setup()

    map('n', '<Leader>zn', "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", { noremap = true, silent = true })
    map('n', '<Leader>zo', "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", { noremap = true, silent = true })
    map('n', '<Leader>zt', "<Cmd>ZkTags<CR>", { noremap = true, silent = true })
    map('n', '<Leader>zf', "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>", { noremap = true, silent = true })
    map('v', '<Leader>zf', ":'<,'>ZkMatch<CR>", { noremap = true, silent = true })
end)

-- fzf
later(function()
    add('ibhagwan/fzf-lua')
    map('n', '<Leader>fz', "<Cmd>FzfLua<CR>", { noremap = true, silent = true })
end)

later(function()
    add({
        source = 'kevinhwang91/nvim-ufo',
        depends = { 'kevinhwang91/promise-async' }
    })
    require('ufo').setup({
        provider_selector = function()
            return {'treesitter', 'indent'}
        end
    })
end)
