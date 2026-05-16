-- Tool plugins: git-blame, rgflow, arrow, ufo, chainsaw, pounce, fzf-lua, text-case

local map = vim.keymap.set

-- Text case conversion
PackAdd('johmsalas/text-case.nvim')
require('textcase').setup({ prefix = 'ge' })

-- Git blame
PackAdd('f-person/git-blame.nvim')
require('gitblame').setup({
  enabled = false,
  date_format = '%r',
  delay = 1,
})
map('n', '<Leader>bt', '<cmd>GitBlameToggle<CR>', { noremap = true, silent = true, desc = 'Toggle git blame' })
map('n', '<Leader>bc', '<cmd>GitBlameOpenCommitURL<CR>', { noremap = true, silent = true, desc = 'Open commit URL' })
map('n', '<Leader>bf', '<cmd>GitBlameOpenFileURL<CR>', { noremap = true, silent = true, desc = 'Open file URL' })
map('v', '<Leader>bf', ":'<,'>GitBlameOpenFileURL<CR>", { noremap = true, silent = true, desc = 'Open file URL (selection)' })

-- Ripgrep flow
PackAdd('mangelozzi/rgflow.nvim')
require('rgflow').setup({
  cmd_flags = '--smart-case --fixed-strings --ignore --max-columns 200',
  default_trigger_mappings = true,
  default_ui_mappings = true,
  default_quickfix_mappings = true,
})
vim.cmd('packadd cfilter')

-- Arrow (bookmarks)
PackAdd('otavioschwanck/arrow.nvim')
require('arrow').setup({
  show_icons = true,
  leader_key = 'm',
  mappings = { next_item = 'j', prev_item = 'k' },
})

-- UFO (folding)
PackAdd('kevinhwang91/promise-async')
PackAdd('kevinhwang91/nvim-ufo')
require('ufo').setup({
  provider_selector = function()
    return { 'treesitter', 'indent' }
  end,
})

-- Chainsaw (logging)
PackAdd('chrisgrieser/nvim-chainsaw')
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
map('n', '<Leader>cwm', '<Cmd>Chainsaw messageLog<CR>', { noremap = true, silent = true, desc = 'Log message' })
map('n', '<Leader>cwv', '<Cmd>Chainsaw variableLog<CR>', { noremap = true, silent = true, desc = 'Log variable' })
map('n', '<Leader>cwo', '<Cmd>Chainsaw objectLog<CR>', { noremap = true, silent = true, desc = 'Log object' })

-- Pounce (motion)
PackAdd('rlane/pounce.nvim')
map('n', '<CR>', '<Cmd>Pounce<CR>', { noremap = true, silent = true })

-- Revert <CR> in quickfix and cmdwin
local gr = vim.api.nvim_create_augroup('Pounce', {})
local revert_cr = function() vim.keymap.set('n', '<CR>', '<CR>', { buffer = true }) end
vim.api.nvim_create_autocmd('FileType', { pattern = 'qf', group = gr, callback = revert_cr, desc = 'Revert <CR>' })
vim.api.nvim_create_autocmd('CmdwinEnter', { pattern = '*', group = gr, callback = revert_cr, desc = 'Revert <CR>' })

-- FzfLua
PackAdd('ibhagwan/fzf-lua')
map('n', '<Leader>fz', '<Cmd>FzfLua<CR>', { noremap = true, silent = true, desc = 'FzfLua' })
