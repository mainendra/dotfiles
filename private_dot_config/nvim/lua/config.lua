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

-- let g:node_host_prog = '/usr/local/bin/neovim-node-host'
g['node_host_prog'] = vim.call('system', 'volta which neovim-node-host | tr -d "\n"')

g.coq_settings = {
    auto_start = 'shut-up',
}

g['gitblame_date_format'] = '%r' -- relative date
g['gitblame_enabled'] = 0 -- default disabled

-- g['startify_disable_at_vimenter'] = 1
g['startify_lists'] = {{type = 'bookmarks', header = {'Bookmarks'}}}
g['startify_bookmarks'] = {
    { i = '~/.config/nvim/init.lua' },
    { p = '~/.config/nvim/lua/plugins.lua' },
    { c = '~/.config/nvim/lua/config.lua' },
    { o = '~/.config/nvim/lua/options.lua' },
    { z = '~/.zshrc' },
    { g = '~/.gitconfig' },
    { t = '~/.tmux.conf'},
}

-- register
g['peekup_paste_before'] = '<leader>P'
g['peekup_paste_after'] = '<leader>p'

cmd [[au TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false, timeout=200}]]


-------------------- MAPPINGS -------------------------------

map('n', '<Space>sv', ':source $MYVIMRC<CR>')

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

-- terminal
local fterm = require("FTerm")

local lazygit = fterm:new({
    cmd = "lazygit",
})
local tig = fterm:new({
    cmd = "tig %",
})
vim.keymap.set('n', '<Leader>lg', function()
    lazygit:toggle()
end)
vim.keymap.set('n', '<Leader>tg', function()
    tig:toggle()
end)

-- Telescope
map('n', '<Leader>fl', '<cmd>Telescope current_buffer_fuzzy_find theme=get_ivy layout_config={height=0.5}<CR>')
map('n', '<Leader>ff', '<cmd>Telescope find_files theme=get_ivy layout_config={height=0.5}<CR>')
map('n', '<Leader>fg', '<cmd>Telescope live_grep theme=get_ivy layout_config={height=0.5}<CR>')
map('n', '<Leader>fb', '<cmd>Telescope buffers theme=get_ivy layout_config={height=0.5}<CR>')
map('n', '<Leader>fh', '<cmd>Telescope help_tags theme=get_ivy layout_config={height=0.5}<CR>')
map('n', '<Leader>fv', '<cmd>Telescope git_files theme=get_ivy layout_config={height=0.5}<CR>')
map('n', '<Leader>fp', '<cmd>Telescope planets theme=get_ivy layout_config={height=0.5}<CR>')
map('n', '<Leader>fk', '<cmd>Telescope keymaps theme=get_ivy layout_config={height=0.5}<CR>')

-- ferret mappings
map('n', '<Leader>x', ':Ack ')
map('n', '<Leader>y', ':Lack ')
map('n', '<Leader>ur', ':Ack <C-R><C-W><CR>')

map('n', '<S-u>', '<C-u>')
map('n', '<S-d>', '<C-d>')

map('n', 'qo', ':only<CR>')

map('', '<C-S-Left>', ':vertical resize -5<CR>')
map('', '<C-S-Right>', ':vertical resize +5<CR>')
map('', '<C-S-Up>', ':resize +5<CR>')
map('', '<C-S-Down>', ':resize -5<CR>')


map('n', '<Leader>e', ':NvimTreeFindFileToggle<CR>')

-- switch window using hjkl
map('n', '<S-h>', '<C-w>h')
map('n', '<S-j>', '<C-w>j')
map('n', '<S-k>', '<C-w>k')
map('n', '<S-l>', '<C-w>l')

-- move selection using jk
map('v', '<S-j>', ':m\'>+<CR>gv=gv')
map('v', '<S-k>', ':m-2<CR>gv=gv')

-- disable recording macros
map('n', 'q', '<Nop>')
map('n', 'Q', '<Nop>')

map('n', 'qq', ':q<CR>')
map('n', 'QQ', ':q!<CR>')

-- hop
map('n', '<Leader>hc', ':HopChar1<cr>')
map('n', '<Leader>hw', ':HopWord<cr>')
map('n', '<Leader>hl', ':HopLine<cr>')
map('n', '<Leader>hp', ':HopPattern<cr>')

-- lsp config
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
map('n', 'ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', 'rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')

-- startify
map('n', '<Leader>S', ':Startify<CR>')

map('n', '<Leader>gb', ':GitBlameToggle<CR>')

