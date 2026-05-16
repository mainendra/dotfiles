---@param plugin string
function PackAdd(plugin)
  vim.pack.add({ 'https://github.com/' .. plugin })
end
