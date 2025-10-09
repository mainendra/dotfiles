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
        'https://github.com/nvim-mini/mini.nvim', mini_path
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
            'mason-org/mason.nvim',
            'mason-org/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
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
        }
    })

    -- folding with treesitter
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

    -- spell check
    vim.opt.spell = true
    vim.opt.spelllang = { 'en_us' }
    vim.opt.spelloptions = 'camel'
    vim.opt.syntax = 'on'
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

-- overlay * over defined pattern
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
    require('mini.keymap').setup()
    local map_multistep = require('mini.keymap').map_multistep
    map_multistep('i', '<Tab>',   { 'pmenu_next' })
    map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
    map_multistep('i', '<CR>',    { 'pmenu_accept', 'minipairs_cr' })
    map_multistep('i', '<BS>',    { 'minipairs_bs' })

    local map_combo = require('mini.keymap').map_combo
    local mode = { 'i', 'c', 'x', 's' }
    map_combo(mode, 'jk', '<BS><BS><Esc>')
    map_combo(mode, 'kj', '<BS><BS><Esc>')
    map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
    map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')

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
    add('f-person/git-blame.nvim')
    require('gitblame').setup({
        enabled = false,
        date_format = '%r',
        delay = 1,
    })
    map('n', '<Leader>bt', '<cmd>GitBlameToggle<CR>', { noremap = true, silent = true })
    map('n', '<Leader>bc', '<cmd>GitBlameOpenCommitURL<CR>', { noremap = true, silent = true })
    map('n', '<Leader>bf', '<cmd>GitBlameOpenFileURL<CR>', { noremap = true, silent = true })
    map('v', '<Leader>bf', ":'<,'>GitBlameOpenFileURL<CR>", { noremap = true, silent = true })
end)

-- ripgrep search
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

-- startup timing
later(function()
    add('dstein64/vim-startuptime')
end)

-- bookmarks
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

-- fzf
later(function()
    add('ibhagwan/fzf-lua')
    map('n', '<Leader>fz', "<Cmd>FzfLua<CR>", { noremap = true, silent = true })
end)

-- folds
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

-- smart logs
later(function()
    add('chrisgrieser/nvim-chainsaw')
    require('chainsaw').setup({
        logStatements = {
            variableLog = {
                javascript = 'console.warn(\'{{marker}} {{filename}}:{{lnum}} {{var}}:\', {{var}});',
            },
            objectLog = {
                javascript = 'console.warn(\'{{marker}} {{filename}}:{{lnum}} {{var}}:\', JSON.stringify({{var}}, null, 2));',
            },
            messageLog = {
                javascript = 'console.warn(\'{{marker}} {{filename}}:{{lnum}}\');',
            }
        },
        marker = '[CW]',
    })

    map('n', '<Leader>cwm', "<Cmd>Chainsaw messageLog<CR>", { noremap = true, silent = true })
    map('n', '<Leader>cwv', "<Cmd>Chainsaw variableLog<CR>", { noremap = true, silent = true })
    map('n', '<Leader>cwo', "<Cmd>Chainsaw objectLog<CR>", { noremap = true, silent = true })
end)

-- fuzzy search motion plugin
later(function()
    add('rlane/pounce.nvim')
    map('n', '<CR>', "<Cmd>Pounce<CR>", { noremap = true, silent = true })

    -- Corrections for default `<CR>` mapping to not interfere with popular usages
    local gr = vim.api.nvim_create_augroup('Pounce', {})
    local au = function(event, pattern, callback, desc)
        vim.api.nvim_create_autocmd(event, { pattern = pattern, group = gr, callback = callback, desc = desc })
    end
    local revert_cr = function() vim.keymap.set('n', '<CR>', '<CR>', { buffer = true }) end
    au('FileType', 'qf', revert_cr, 'Revert <CR>')
    au('CmdwinEnter', '*', revert_cr, 'Revert <CR>')
end)
