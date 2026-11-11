-- UI plugins: treesitter, colorscheme, cloak

local pack_add = require('util').pack_add

-- Treesitter
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end,
})

pack_add('nvim-treesitter/nvim-treesitter')
require('nvim-treesitter').setup()

-- Parsers for languages embedded in other filetypes
local web = { 'html', 'css', 'javascript', 'typescript' }
local embedded_deps = {
  svelte = web,
  vue = web,
  astro = web,
  html = { 'css', 'javascript' },
  markdown = { 'html' },
  php = web,
}

vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
    local deps = embedded_deps[vim.bo[ev.buf].filetype]
    if deps then
      local ts = require('nvim-treesitter')
      local installed = ts.get_installed()
      for _, lang in ipairs(deps) do
        if not vim.tbl_contains(installed, lang) then ts.install(lang) end
      end
    end
  end,
})

-- Gruvbox colorscheme
pack_add('ellisonleao/gruvbox.nvim')
require('gruvbox').setup({
  contrast = 'hard',
  invert_selection = true,
  palette_overrides = {
    dark0_hard = '#1b1b1b',
  },
})
vim.cmd('colorscheme gruvbox')

-- Cloak (hide sensitive values)
pack_add('laytan/cloak.nvim')
require('cloak').setup()
