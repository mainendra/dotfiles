-------------------- HELPERS ------------------------------

local cmd = vim.cmd         -- to execute Vim commands e.g. cmd('pwd')
local g = vim.g             -- a table to access global variables
local map = vim.keymap.set  -- new function for keymap

-------------------- CONFIG -------------------------------
g['mapleader'] = ' ' -- leader key
g['maplocalleader'] = ' ' -- leader key

g['have_nerd_font'] = true

g['node_host_prog'] = vim.call('system', 'which neovim-node-host | tr -d "\n"')

-- Remove trailing space
cmd [[autocmd InsertLeavePre * :%s/\s\+$//e]]

-------------------- MAPPINGS -------------------------------

map('n', '<Leader>sv', ':source $MYVIMRC<CR>')

map('n', '<Space>', '<Nop>', { noremap = true, silent = true })

-- E end of line
map('n', 'E', '$', { noremap = true, silent = true })
-- B begin of line
map('n', 'B', '^', { noremap = true, silent = true })

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

map('n', 'U', '<C-u>');
map('n', 'D', '<C-d>');

map('n', '<Leader>on', ':only<CR>')

map('', '<C-S-Left>', ':vertical resize -5<CR>')
map('', '<C-S-Right>', ':vertical resize +5<CR>')
map('', '<C-S-Up>', ':resize +5<CR>')
map('', '<C-S-Down>', ':resize -5<CR>')

-- switch window using hjkl
map('n', 'H', '<C-w>h')
map('n', 'J', '<C-w>j')
map('n', 'K', '<C-w>k')
map('n', 'L', '<C-w>l')

map('n', '<Leader>q', ':q<CR>')
map('n', '<Leader>Q', ':q!<CR>')

-- toggle diff
map('n', '<Leader>dt', ':diffthis<CR>')
map('n', '<Leader>do', ':diffoff<CR>')
map('n', '<Leader>dv', ':vs | :enew | :only | :vs | :enew<CR>')

-- paste on selection
map('x', 'p', [["_dP]])
