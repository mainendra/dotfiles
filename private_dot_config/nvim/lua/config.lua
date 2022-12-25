-------------------- HELPERS ------------------------------

local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local g = vim.g      -- a table to access global variables

local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------- CONFIG -------------------------------
g['mapleader'] = ' ' -- leader key
g['maplocalleader'] = ' ' -- leader key

g['node_host_prog'] = vim.call('system', 'which neovim-node-host | tr -d "\n"')

-- register
g['peekup_paste_before'] = '<leader>P'
g['peekup_paste_after'] = '<leader>p'

cmd [[au TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false, timeout=200}]]

-- Remove trailing space
cmd [[autocmd InsertLeavePre * :%s/\s\+$//e]]

-- color scheme
vim.cmd.colorscheme('gruvbox')
-- remove bg color (after setting colorscheme)
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })


-------------------- MAPPINGS -------------------------------

map('n', '<Leader>sv', ':source $MYVIMRC<CR>')

map('n', '<Space>', '<Nop>', { noremap = true, silent = true })

-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

map('n', '\\', '<cmd>noh<CR>')    -- Clear highlights

map('n', '<Leader>j', ':j<CR>')
map('n', '<Leader>J', ':j!<CR>')

map('n', '<Leader>w', ':w<CR>')

-- keep visual selection after indenting
map('v', '>', '>gv');
map('v', '<', '<gv');

-- copy file path
map('n', '<Leader>cp', ':let @*=expand("%")<CR>')

map('n', '<S-u>', '<C-u>')
map('n', '<S-d>', '<C-d>')

map('n', 'qo', ':only<CR>')

map('', '<C-S-Left>', ':vertical resize -5<CR>')
map('', '<C-S-Right>', ':vertical resize +5<CR>')
map('', '<C-S-Up>', ':resize +5<CR>')
map('', '<C-S-Down>', ':resize -5<CR>')

-- switch window using hjkl
map('n', '<S-h>', '<C-w>h')
map('n', '<S-j>', '<C-w>j')
map('n', '<S-k>', '<C-w>k')
map('n', '<S-l>', '<C-w>l')

-- move selection using jk
map('v', '<S-j>', ':m\'>+<CR>gv=gv')
map('v', '<S-k>', ':m-2<CR>gv=gv')

-- escape visual selection
map('v', ';;', '<Esc>')

-- disable recording macros
map('n', 'q', '<Nop>')
map('n', 'Q', '<Nop>')

map('n', 'qq', ':q<CR>')
map('n', 'QQ', ':q!<CR>')

-- paste on selection
map('x', 'p', [["_dP]])

---------------------------------------- Plugins configs ------------------------------------------------

-- gitblame
g['gitblame_date_format'] = '%r' -- relative date
g['gitblame_enabled'] = 0 -- default disabled
map('n', '<Leader>gb', ':GitBlameToggle<CR>')

-- startify
g['startify_lists'] = {{type = 'bookmarks', header = {'Bookmarks'}}}
g['startify_bookmarks'] = {
    { i = '~/.config/nvim/init.lua' },
    { p = '~/.config/nvim/lua/plugins.lua' },
    { c = '~/.config/nvim/lua/config.lua' },
    { o = '~/.config/nvim/lua/options.lua' },
    { s = '~/.config/nvim/after/plugin' },
    { z = '~/.zshrc' },
    { g = '~/.gitconfig' },
    { t = '~/.tmux.conf'},
}
map('n', '<Leader>S', ':Startify<CR>')

-- search and replace
map('n', '<Leader>sr', '<cmd>lua require("spectre").open()<CR>')
map('n', '<Leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>')
map('n', '<Leader>sp', '<cmd>lua require("spectre").open_file_search()<CR>')

-- Telescope
map('n', '<Leader>fl', '<cmd>Telescope current_buffer_fuzzy_find theme=get_ivy layout_config={height=0.5}<CR>')
map('n', '<Leader>ff', '<cmd>Telescope find_files theme=get_ivy layout_config={height=0.5}<CR>')
map('n', '<Leader>fg', '<cmd>Telescope live_grep theme=get_ivy layout_config={height=0.5}<CR>')
map('n', '<Leader>fb', '<cmd>Telescope buffers theme=get_ivy layout_config={height=0.5}<CR>')
map('n', '<Leader>fh', '<cmd>Telescope help_tags theme=get_ivy layout_config={height=0.5}<CR>')
map('n', '<Leader>fv', '<cmd>Telescope git_files theme=get_ivy layout_config={height=0.5}<CR>')
map('n', '<Leader>fp', '<cmd>Telescope planets theme=get_ivy layout_config={height=0.5}<CR>')
map('n', '<Leader>fk', '<cmd>Telescope keymaps theme=get_ivy layout_config={height=0.5}<CR>')
map('n', '<Leader>fc', '<cmd>Telescope builtin theme=get_ivy layout_config={height=0.5}<CR>')

-- file explorer
map('n', '<Leader>e', '<cmd>CHADopen<CR>')

-- harpoon
map('n', '<Leader>ha', '<cmd>lua require("harpoon.mark").add_file()<CR>')
map('n', '<Leader>ht', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>')
map('n', '<Leader>hn', '<cmd>lua require("harpoon.ui").nav_next()<CR>')
map('n', '<Leader>hp', '<cmd>lua require("harpoon.ui").nav_prev()<CR>')
