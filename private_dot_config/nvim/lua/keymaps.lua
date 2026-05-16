-- General keymaps (non-plugin)

local map = vim.keymap.set

map('n', '<Space>', '<Nop>', { noremap = true, silent = true })

-- Source config
map('n', '<Leader>sv', ':source $MYVIMRC<CR>', { desc = 'Source vimrc' })

-- Line navigation
map('n', 'E', '$', { noremap = true, silent = true })
map('n', 'B', '^', { noremap = true, silent = true })

-- Indentation (keep selection)
map('v', '>', '>gv')
map('v', '<', '<gv')

-- Clear highlights
map('n', '\\', '<cmd>noh<CR>')

-- Join lines
map('n', '<Leader>j', ':j<CR>')
map('n', '<Leader>J', ':j!<CR>')

-- Save/quit
map('n', '<Leader>w', ':w<CR>', { desc = 'Save' })
map('n', '<Leader>W', ':wq<CR>', { desc = 'Save and quit' })
map('n', '<Leader>q', ':q<CR>', { desc = 'Quit' })
map('n', '<Leader>Q', ':q!<CR>', { desc = 'Force quit' })

-- Copy file path to clipboard
map('n', '<Leader>cp', ':let @*=expand("%")<CR>', { desc = 'Copy relative path' })
map('n', '<Leader>cn', ':let @*=expand("%:t")<CR>', { desc = 'Copy filename' })
map('n', '<Leader>cf', ':let @*=expand("%:p")<CR>', { desc = 'Copy full path' })

-- Scroll half-page
map('n', 'U', '<C-u>')
map('n', 'D', '<C-d>')

-- Only window
map('n', '<Leader>on', ':only<CR>', { desc = 'Close other windows' })

-- Window navigation
map('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
map('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
map('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
map('n', '<C-l>', '<C-w>l', { desc = 'Window right' })

-- Window resize
map('', '<C-S-Left>', ':vertical resize -5<CR>')
map('', '<C-S-Right>', ':vertical resize +5<CR>')
map('', '<C-S-Up>', ':resize +5<CR>')
map('', '<C-S-Down>', ':resize -5<CR>')

-- Diff
map('n', '<Leader>dt', ':diffthis<CR>', { desc = 'Diff this' })
map('n', '<Leader>do', ':diffoff<CR>', { desc = 'Diff off' })
map('n', '<Leader>dv', ':vs | :enew | :only | :vs | :enew<CR>', { desc = 'Diff view setup' })

-- Paste over selection without yanking
map('x', 'p', [["_dP]])

-- Quickfix
map('n', '<Leader>co', ':copen<CR>', { desc = 'Open quickfix' })
map('n', '<Leader>cq', ':cclose<CR>', { desc = 'Close quickfix' })
map('n', '<Leader>cj', ':cnext<CR>', { desc = 'Next quickfix' })
map('n', '<Leader>ck', ':cprevious<CR>', { desc = 'Prev quickfix' })
