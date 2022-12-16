require('nvim-treesitter.configs').setup {
    -- ensure_installed = 'all',
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
    autotag = {
        enable = true,
    }
}

local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.setup()
-- diagnostics
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = false,
    float = true,
})

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
