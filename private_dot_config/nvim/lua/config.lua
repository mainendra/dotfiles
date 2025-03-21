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

g['have_nerd_font'] = true

g['node_host_prog'] = vim.call('system', 'which neovim-node-host | tr -d "\n"')

-- highlight yanked text
cmd [[au TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false, timeout=200}]]

-- Remove trailing space
cmd [[autocmd InsertLeavePre * :%s/\s\+$//e]]

-------------------- MAPPINGS -------------------------------

map('n', '<Leader>sv', ':source $MYVIMRC<CR>')

map('n', '<Space>', '<Nop>', { noremap = true, silent = true })

-- better escape
map('i', 'jj', '<Esc>', { noremap = true, silent = true })
map('i', 'jk', '<Esc>', { noremap = true, silent = true })

-- escape visual selection
map('v', ';;', '<Esc>')

-- move selection
map('v', '>', '>gv')
map('v', '<', '<gv')

-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', { expr = true, noremap = true, silent = true })
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true, noremap = true, silent = true })

map('n', '\\', '<cmd>noh<CR>')    -- Clear highlights

map('n', '<Leader>j', ':j<CR>')
map('n', '<Leader>J', ':j!<CR>')

map('n', '<Leader>w', ':w<CR>')
map('n', '<Leader>W', ':wq<CR>')

-- copy file path
map('n', '<Leader>cp', ':let @*=expand("%")<CR>')
map('n', '<Leader>cn', ':let @*=expand("%:t")<CR>')
map('n', '<Leader>cf', ':let @*=expand("%:p")<CR>')

map('n', '<S-u>', '<C-u>');
map('n', '<S-d>', '<C-d>');

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

map('n', '<Leader>q', ':q<CR>')
map('n', '<Leader>Q', ':q!<CR>')

-- toggle diff
map('n', '<Leader>dt', ':diffthis<CR>')
map('n', '<Leader>do', ':diffoff<CR>')
map('n', '<Leader>dv', ':vs | :enew | :only | :vs | :enew<CR>')

-- paste on selection
map('x', 'p', [["_dP]])
