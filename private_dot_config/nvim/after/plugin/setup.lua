local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.setup()

require('spectre').setup()

require('nvim-tree').setup()

require('gitsigns').setup()

require('kommentary.config').use_extended_mappings()

require('hop').setup{keys = 'etovxqpdygfblzhckisuran'}

require('nvim-surround').setup{}

require('lualine').setup({
    options = { theme = 'gruvbox' }
})

require('better_escape').setup()
