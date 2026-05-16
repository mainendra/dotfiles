-- Entry point for Neovim configuration
-- Sets up PATH for Homebrew, global variables, and loads all modules

if vim.fn.isdirectory('/opt/homebrew/bin') == 1 then
  vim.env.PATH = '/opt/homebrew/bin:/opt/homebrew/sbin:' .. vim.env.PATH
end

-- Leader keys (must be set before any keymaps)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Provider configuration
vim.g.have_nerd_font = true
vim.g.node_host_prog = vim.call('system', 'which neovim-node-host | tr -d "\n"')
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

require('options')
require('keymaps')
require('autocmds')
require('globals')
require('plugins')
