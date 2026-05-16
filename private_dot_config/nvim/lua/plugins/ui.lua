-- UI plugins: colorscheme, cloak, treesitter

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

vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
    local web = { 'html', 'css', 'javascript', 'typescript' }
    local dominated = {
      svelte = web,
      vue = web,
      astro = web,
      html = { 'css', 'javascript' },
      markdown = { 'html' },
      php = web,
    }
    local deps = dominated[vim.bo[ev.buf].filetype]
    if deps then
      local ts = require('nvim-treesitter')
      local installed = ts.get_installed()
      for _, lang in ipairs(deps) do
        if not vim.tbl_contains(installed, lang) then ts.install(lang) end
      end
    end
  end,
})

PackAdd('nvim-treesitter/nvim-treesitter')
require('nvim-treesitter').setup({ auto_install = true })

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }
vim.opt.spelloptions = 'camel'

-- Gruvbox colorscheme
PackAdd('ellisonleao/gruvbox.nvim')
require('gruvbox').setup({
  contrast = 'hard',
  invert_selection = true,
  palette_overrides = {
    dark0_hard = '#1b1b1b',
  },
})
vim.cmd('colorscheme gruvbox')

-- Cloak (hide sensitive values)
PackAdd('laytan/cloak.nvim')
require('cloak').setup()
