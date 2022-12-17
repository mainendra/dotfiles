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

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Turn on lsp status information
require('fidget').setup()

require('spectre').setup()

require('nvim-tree').setup()

require('gitsigns').setup()

require('Comment').setup()

require('hop').setup{keys = 'etovxqpdygfblzhckisuran'}

require('nvim-surround').setup()

require('lualine').setup({
    options = { theme = 'gruvbox' }
})

require('better_escape').setup()
