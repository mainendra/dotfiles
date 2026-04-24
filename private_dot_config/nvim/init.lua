if vim.fn.isdirectory("/opt/homebrew/bin") == 1 then
  vim.env.PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:" .. vim.env.PATH
end

require('options');
require('config');
require('plugins');
