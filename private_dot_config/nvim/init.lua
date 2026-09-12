-- Entry point for Neovim configuration
-- Sets up global variables and loads all modules

-- Leader keys (must be set before any keymaps)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Provider configuration
vim.g.have_nerd_font = true
-- No plugins use language providers, so disable them all to skip
-- the provider checks (and speed up startup slightly).
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

require('options')
require('keymaps')
require('autocmds')
require('globals')
require('plugins')
