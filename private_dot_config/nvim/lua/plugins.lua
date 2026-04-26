-------------------- HELPERS ------------------------------

local map = vim.keymap.set -- new function for keymap
local add = function(plugin)
    vim.pack.add({ 'https://github.com/' .. plugin })
end

-------------------- PLUGINS ------------------------------

-- Enable new UI (neovim 0.12+)
require('vim._core.ui2').enable({})

-- enable builtin plugin
vim.cmd('packadd nvim.difftool')
vim.cmd('packadd nvim.undotree')
map('n', '<Leader>u', '<cmd>Undotree<CR>', { noremap = true, silent = true })

vim.cmd('packadd cfilter')
vim.cmd('packadd justify')

add('mason-org/mason.nvim')
add('neovim/nvim-lspconfig')
add('mason-org/mason-lspconfig.nvim')

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local bufnr = ev.buf
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
        vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.buf.format({ async = true })'

        vim.diagnostic.config({
            virtual_text = { severity = { min = vim.diagnostic.severity.INFO } },
            severity_sort = true,
            float = true,
        })

        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', '=', function() vim.lsp.buf.format({ async = true }) end, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', '<Leader>sh', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<Leader>ld', vim.diagnostic.open_float, bufopts)
    end,
})

require('lsp').setup() -- lsp.lua file

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'nvim-treesitter' and kind == 'update' then
            if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
            vim.cmd('TSUpdate')
        end
    end
})

vim.api.nvim_create_autocmd('FileType', {
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
        local web = { 'html', 'css', 'javascript', 'typescript' }
        local dominated = {
            svelte = web,
            vue = web,
            astro = web,
            html = { 'css', 'javascript' },
            markdown = { 'html' },
            php = web,
        }
        local deps = dominated[vim.bo[ev.buf].filetype]
        if deps then
            local ts = require('nvim-treesitter')
            local installed = ts.get_installed()
            for _, lang in ipairs(deps) do
                if not vim.tbl_contains(installed, lang) then ts.install(lang) end
            end
        end
    end,
})

add('nvim-treesitter/nvim-treesitter')

require('nvim-treesitter').setup({ auto_install = true })

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }
vim.opt.spelloptions = 'camel'

add('ellisonleao/gruvbox.nvim')
require('gruvbox').setup({
    contrast = 'hard',
    invert_selection = true,
    palette_overrides = {
        dark0_hard = "#1b1b1b",
    },
})
vim.cmd('colorscheme gruvbox')

add('laytan/cloak.nvim')
require('cloak').setup()

vim.schedule(function()
    add('nvim-mini/mini.nvim')

    require('mini.ai').setup()
    require('mini.align').setup()
    require('mini.basics').setup({
        options = {
            extra_ui = true,
        }
    })
    require('mini.bracketed').setup()
    local miniclue = require('mini.clue')
    miniclue.setup({
        triggers = {
            -- `[` and `]` keys
            { mode = 'n', keys = '[' },
            { mode = 'n', keys = ']' },

            -- `g` key
            { mode = { 'n', 'x' }, keys = 'g' },
        },
        clues = {
            miniclue.gen_clues.square_brackets(),
        },
    })
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
            fixme     = { pattern = '%f[%w]()[Ff][Ii][Xx][Mm][Ee]()%f[%W]', group = 'MiniHipatternsFixme' },
            hack      = { pattern = '%f[%w]()[Hh][Aa][Cc][Kk]()%f[%W]', group = 'MiniHipatternsHack' },
            todo      = { pattern = '%f[%w]()[Tt][Oo][Dd][Oo]()%f[%W]', group = 'MiniHipatternsTodo' },
            note      = { pattern = '%f[%w]()[Nn][Oo][Tt][Ee]()%f[%W]', group = 'MiniHipatternsNote' },

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
    map_multistep('i', '<Tab>', { 'pmenu_next' })
    map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
    map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
    map_multistep('i', '<BS>', { 'minipairs_bs' })

    local map_combo = require('mini.keymap').map_combo
    local mode = { 'i', 'c', 'x', 's' }
    map_combo(mode, 'jk', '<BS><BS><Esc>')
    map_combo(mode, 'kj', '<BS><BS><Esc>')
    map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
    map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')

    require('mini.misc').setup()
    require('mini.move').setup()
    local notify = require('mini.notify')
    -- disable notifications
    local filterout = function(notif_arr)
        local prefixes = { 'rust_analyzer', 'jdtl', 'vtsls' }
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
    require('mini.pick').setup({
        mappings = {
            move_down = '<C-j>',
            move_up   = '<C-k>',
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
    map('n', '<Leader>fl', '<cmd>Pick buf_lines scope="current"<CR>', { noremap = true, silent = true })
    map('n', '<Leader>ff', '<cmd>Pick files<CR>', { noremap = true, silent = true })
    map('n', '<Leader>fg', '<cmd>Pick grep_live<CR>', { noremap = true, silent = true })
    map('n', '<Leader>fb', '<cmd>Pick buffers<CR>', { noremap = true, silent = true })
    map('n', '<Leader>fh', '<cmd>Pick git_hunks<CR>', { noremap = true, silent = true })
    map('n', '<Leader>fv', '<cmd>Pick git_files<CR>', { noremap = true, silent = true })
    map('n', '<Leader>fk', '<cmd>Pick keymaps<CR>', { noremap = true, silent = true })
    map('n', '<Leader>fc', '<cmd>lua MiniPick.builtin.files(nil, { source={ cwd="~/.config" } })<CR>',
    { noremap = true, silent = true })

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

    add('johmsalas/text-case.nvim')
    require('textcase').setup({ prefix = 'ge' })

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

    add('mangelozzi/rgflow.nvim')
    require('rgflow').setup({
        cmd_flags = "--smart-case --fixed-strings --ignore --max-columns 200",
        default_trigger_mappings = true,
        default_ui_mappings = true,
        default_quickfix_mappings = true,
    })
    -- enable cfilter
    vim.cmd('packadd cfilter')

    add('otavioschwanck/arrow.nvim')
    require('arrow').setup({
        show_icons = true,
        leader_key = 'm',
        mappings = {
            next_item = "j",
            prev_item = "k"
        }
    })

    add('kevinhwang91/promise-async')
    add('kevinhwang91/nvim-ufo')
    require('ufo').setup({
        provider_selector = function()
            return { 'treesitter', 'indent' }
        end
    })

    add('chrisgrieser/nvim-chainsaw')
    require('chainsaw').setup({
        logStatements = {
            variableLog = {
                javascript = 'console.warn(\'{{marker}} {{filename}}:{{lnum}} {{var}}:\', {{var}});',
            },
            objectLog = {
                javascript =
                'console.warn(\'{{marker}} {{filename}}:{{lnum}} {{var}}:\', JSON.stringify({{var}}, null, 2));',
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

    add('alexpasmantier/tv.nvim')
    require('tv').setup({})
end)

-- Pack management commands
-- :PackUpdate          - Update all packs
vim.api.nvim_create_user_command('PackUpdate', function()
    vim.pack.update()
end, { desc = 'Update all packs' })

-- remove unused plugins
local function remove_unused_plugins()
    local unused = vim.iter(vim.pack.get())
        :filter(function(plugin)
            return not plugin.active
        end)
        :map(function(plugin)
            return plugin.spec.name
        end)
        :totable()

    if vim.tbl_isempty(unused) then
        vim.notify('No unused plugins found.')
        return
    end

    vim.pack.del(unused)
end
vim.api.nvim_create_user_command('PackClean', remove_unused_plugins, { desc = 'Remove unused packs' })
