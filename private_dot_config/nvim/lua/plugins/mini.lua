-- mini.nvim modules

local map = vim.keymap.set

PackAdd('nvim-mini/mini.nvim')

require('mini.ai').setup()
require('mini.align').setup()
require('mini.basics').setup({ options = { extra_ui = true } })
require('mini.bracketed').setup()

local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
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
    fixme     = { pattern = '%f[%w]()[Ff][Ii][Xx][Mm][Ee]()%f[%W]', group = 'MiniHipatternsFixme' },
    hack      = { pattern = '%f[%w]()[Hh][Aa][Cc][Kk]()%f[%W]', group = 'MiniHipatternsHack' },
    todo      = { pattern = '%f[%w]()[Tt][Oo][Dd][Oo]()%f[%W]', group = 'MiniHipatternsTodo' },
    note      = { pattern = '%f[%w]()[Nn][Oo][Tt][Ee]()%f[%W]', group = 'MiniHipatternsNote' },
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

require('mini.icons').setup()
require('mini.indentscope').setup({
  draw = { animation = require('mini.indentscope').gen_animation.none() },
})

require('mini.input').setup()

-- Keymap multistep and combos
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

-- Notifications (filter noisy LSP messages)
local notify = require('mini.notify')
local filterout = function(notif_arr)
  local prefixes = { 'rust_analyzer', 'jdtl', 'vtsls' }
  notif_arr = vim.tbl_filter(function(notif)
    for _, prefix in ipairs(prefixes) do
      if vim.startswith(notif.msg, prefix) then return false end
    end
    return true
  end, notif_arr)
  return notify.default_sort(notif_arr)
end
notify.setup({ content = { sort = filterout } })

-- Picker
require('mini.pick').setup({
  mappings = { move_down = '<C-j>', move_up = '<C-k>' },
})

require('mini.splitjoin').setup()
require('mini.statusline').setup()
require('mini.surround').setup()
require('mini.trailspace').setup()
require('mini.visits').setup()

-- Use Mini.pick for vim.ui.select
vim.ui.select = require('mini.pick').ui_select
vim.cmd('highlight MiniPickNormal guibg=NONE')
vim.cmd('highlight MiniFilesNormal guibg=NONE')

-- Picker keymaps
map('n', '<Leader>fl', '<cmd>Pick buf_lines scope="current"<CR>', { noremap = true, silent = true, desc = 'Pick buffer lines' })
map('n', '<Leader>ff', '<cmd>Pick files<CR>', { noremap = true, silent = true, desc = 'Pick files' })
map('n', '<Leader>fg', '<cmd>Pick grep_live<CR>', { noremap = true, silent = true, desc = 'Pick grep' })
map('n', '<Leader>fb', '<cmd>Pick buffers<CR>', { noremap = true, silent = true, desc = 'Pick buffers' })
map('n', '<Leader>fh', '<cmd>Pick git_hunks<CR>', { noremap = true, silent = true, desc = 'Pick git hunks' })
map('n', '<Leader>fv', '<cmd>Pick git_files<CR>', { noremap = true, silent = true, desc = 'Pick git files' })
map('n', '<Leader>fk', '<cmd>Pick keymaps<CR>', { noremap = true, silent = true, desc = 'Pick keymaps' })
map('n', '<Leader>fc', '<cmd>lua MiniPick.builtin.files(nil, { source={ cwd="~/.config" } })<CR>', { noremap = true, silent = true, desc = 'Pick config files' })

-- File explorer
function ShowMiniFiles()
  local files = require('mini.files')
  if not files.close() then
    files.open(vim.api.nvim_buf_get_name(0), false)
  else
    files.close()
  end
end

map('n', '<Leader>e', '<cmd>lua ShowMiniFiles()<CR>', { noremap = true, silent = true, desc = 'Toggle file explorer' })
