-- Plugin loader
-- Manages builtin plugins, LSP attach handler, and loads plugin modules

local map = vim.keymap.set

-- Enable new UI (neovim 0.12+)
require('vim._core.ui2').enable({})

-- Builtin plugins
vim.cmd('packadd nvim.difftool')
vim.cmd('packadd nvim.undotree')
map('n', '<Leader>u', '<cmd>Undotree<CR>', { noremap = true, silent = true, desc = 'Toggle undotree' })
vim.cmd('packadd cfilter')
vim.cmd('packadd justify')

-- LSP plugins
PackAdd('mason-org/mason.nvim')
PackAdd('neovim/nvim-lspconfig')
PackAdd('mason-org/mason-lspconfig.nvim')

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
    vim.keymap.set('n', '=', function() vim.lsp.buf.format({ async = true }) end, vim.tbl_extend('force', bufopts, { desc = 'Format buffer' }))
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', bufopts, { desc = 'Go to definition' }))
    vim.keymap.set('n', '<Leader>sh', vim.lsp.buf.signature_help, vim.tbl_extend('force', bufopts, { desc = 'Signature help' }))
    vim.keymap.set('n', '<Leader>ld', vim.diagnostic.open_float, vim.tbl_extend('force', bufopts, { desc = 'Line diagnostics' }))
  end,
})

require('lsp').setup()

-- UI plugins (loaded synchronously for colorscheme)
require('plugins.ui')

-- Deferred plugins (loaded after UI is ready)
vim.schedule(function()
  require('plugins.mini')
  require('plugins.tools')
end)

-- Pack management commands
vim.api.nvim_create_user_command('PackUpdate', function()
  vim.pack.update()
end, { desc = 'Update all packs' })

vim.api.nvim_create_user_command('PackClean', function()
  local unused = vim.iter(vim.pack.get())
    :filter(function(plugin) return not plugin.active end)
    :map(function(plugin) return plugin.spec.name end)
    :totable()

  if vim.tbl_isempty(unused) then
    vim.notify('No unused plugins found.')
    return
  end

  vim.pack.del(unused)
end, { desc = 'Remove unused packs' })
