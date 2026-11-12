-- Tool plugins: text-case, git-blame, rgflow, arrow, chainsaw, pounce

local map = vim.keymap.set
local pack_add = require('util').pack_add

-- Text case conversion
pack_add('johmsalas/text-case.nvim')
require('textcase').setup({ prefix = 'ge' })

-- Git blame
pack_add('f-person/git-blame.nvim')
require('gitblame').setup({
  enabled = false,
  date_format = '%r',
  delay = 1,
})
map('n', '<Leader>bt', '<cmd>GitBlameToggle<CR>', { silent = true, desc = 'Toggle git blame' })
map('n', '<Leader>bc', '<cmd>GitBlameOpenCommitURL<CR>', { silent = true, desc = 'Open commit URL' })
map('n', '<Leader>bf', '<cmd>GitBlameOpenFileURL<CR>', { silent = true, desc = 'Open file URL' })
map('v', '<Leader>bf', ":'<,'>GitBlameOpenFileURL<CR>", { silent = true, desc = 'Open file URL (selection)' })

-- Ripgrep flow
pack_add('mangelozzi/rgflow.nvim')
require('rgflow').setup({
  cmd_flags = '--smart-case --fixed-strings --ignore --max-columns 200',
  default_trigger_mappings = true,
  default_ui_mappings = true,
  default_quickfix_mappings = true,
  -- Hide the bar above the dialog: blank character, same colors as the dialog
  ui_top_line_char = ' ',
  colors = { RgFlowHeadLine = { link = 'NormalFloat' } },
})

-- Arrow (bookmarks)
pack_add('otavioschwanck/arrow.nvim')
require('arrow').setup({
  show_icons = true,
  leader_key = 'm',
  mappings = { next_item = 'j', prev_item = 'k' },
})

-- Chainsaw (logging)
pack_add('chrisgrieser/nvim-chainsaw')
require('chainsaw').setup({
  logStatements = {
    variableLog = {
      javascript = "console.warn('{{marker}} {{filename}}:{{lnum}} {{var}}:', {{var}});",
    },
    objectLog = {
      javascript = "console.warn('{{marker}} {{filename}}:{{lnum}} {{var}}:', JSON.stringify({{var}}, null, 2));",
    },
    messageLog = {
      javascript = "console.warn('{{marker}} {{filename}}:{{lnum}}');",
    },
  },
  marker = '[CW]',
})
map('n', '<Leader>cwm', '<Cmd>Chainsaw messageLog<CR>', { silent = true, desc = 'Log message' })
map('n', '<Leader>cwv', '<Cmd>Chainsaw variableLog<CR>', { silent = true, desc = 'Log variable' })
map('n', '<Leader>cwo', '<Cmd>Chainsaw objectLog<CR>', { silent = true, desc = 'Log object' })

-- Pounce (motion)
pack_add('rlane/pounce.nvim')
map('n', '<CR>', '<Cmd>Pounce<CR>', { silent = true, desc = 'Pounce' })

-- Restore <CR> in special buffers (quickfix, help, ...) and cmdwin
local gr = vim.api.nvim_create_augroup('Pounce', {})
local revert_cr = function(ev)
  vim.keymap.set('n', '<CR>', '<CR>', { buffer = ev.buf })
end
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'qf', 'help', 'man', 'checkhealth' },
  group = gr,
  callback = revert_cr,
  desc = 'Revert <CR>',
})
vim.api.nvim_create_autocmd('CmdwinEnter', { group = gr, callback = revert_cr, desc = 'Revert <CR>' })
