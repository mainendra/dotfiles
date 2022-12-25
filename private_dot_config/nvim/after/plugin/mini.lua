local status_ok = pcall(require, 'mini.align')
if not status_ok then
  return
end

require('mini.align').setup()
require('mini.comment').setup()
require('mini.completion').setup()
require('mini.fuzzy').setup()
require('mini.jump').setup()
require('mini.jump2d').setup()
require('mini.misc').setup()
require('mini.pairs').setup()
require('mini.statusline').setup()
require('mini.surround').setup()
require('mini.trailspace').setup()
require('mini.ai').setup()
