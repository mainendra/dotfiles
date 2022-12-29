vim.cmd 'let $PATH = "/opt/homebrew/bin:/usr/local/bin:" . $PATH'

pcall(require, 'impatient') -- ignore error

require('plugins');
require('options');
require('config');
