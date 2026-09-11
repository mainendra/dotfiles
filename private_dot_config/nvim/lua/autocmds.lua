-- Autocommands

-- Trim trailing whitespace on save (uses mini.trailspace)
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    pcall(function() require('mini.trailspace').trim() end)
  end,
})
