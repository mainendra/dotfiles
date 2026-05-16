-- Autocommands

-- Remove trailing whitespace on leaving insert mode
vim.api.nvim_create_autocmd('InsertLeavePre', {
  pattern = '*',
  command = ':%s/\\s\\+$//e',
})
