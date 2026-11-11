-- Autocommands

-- Trim trailing whitespace on save (uses mini.trailspace)
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    if _G.MiniTrailspace then MiniTrailspace.trim() end
  end,
})
