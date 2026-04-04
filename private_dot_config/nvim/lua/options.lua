-------------------- HELPERS ------------------------------

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= 'o' then scopes['o'][key] = value end
end

-------------------- OPTIONS -------------------------------
local indent = 4
opt('b', 'shiftwidth', indent)                        -- Size of an indent
opt('b', 'tabstop', indent)                           -- Number of spaces tabs count for
opt('b', 'softtabstop', indent)                       -- Number of spaces for soft tab
opt('b', 'expandtab', true)                           -- Use spaces instead of tabs
opt('b', 'smartindent', true)                         -- Insert indents automatically
opt('o', 'completeopt', 'menuone,noinsert,noselect')  -- Completion options (for deoplete)
opt('o', 'hidden', true)                              -- Enable modified buffers in background
opt('o', 'ignorecase', true)                          -- Ignore case
opt('o', 'joinspaces', false)                         -- No double spaces with join after a dot
opt('o', 'scrolloff', 4 )                             -- Lines of context
opt('o', 'shiftround', true)                          -- Round indent
opt('o', 'sidescrolloff', 8 )                         -- Columns of context
opt('o', 'smartcase', true)                           -- Don't ignore case with capitals
opt('o', 'splitbelow', true)                          -- Put new windows below current
opt('o', 'splitright', true)                          -- Put new windows right of current
opt('o', 'termguicolors', true)                       -- True color support
opt('o', 'wildmode', 'list:longest')                  -- Command-line completion mode
opt('w', 'list', true)                                -- Show some invisible characters (tabs...)
opt('w', 'number', true)                              -- Print line number
opt('w', 'relativenumber', false)                     -- Relative line numbers
opt('w', 'wrap', false)                               -- Disable line wrap
opt('o', 'swapfile', false)                           -- Disable swapfile
opt('o', 'history', 1000)                             -- Command history size
opt('o', 'autoread', true)                            -- Auto reload files changed outside vim
opt('o', 'backup', false)                             -- Disable backup files
opt('o', 'writebackup', false)                        -- Disable write backup
opt('w', 'cursorline', true)                          -- Highlight current line
opt('o', 'pumheight', 10)                             -- Popup menu max height
opt('o', 'fileencoding', 'utf-8')                     -- File encoding
opt('o', 'cmdheight', 2)                              -- Command line height
opt('o', 'mouse', 'a')                                -- Enable mouse in all modes
opt('o', 'updatetime', 50)                            -- Faster CursorHold events
opt('o', 'clipboard', 'unnamedplus')                  -- Use system clipboard
opt('o', 'wildmenu', true)                            -- Enhanced command-line completion
opt('o', 'hls', true)                                 -- Highlight search matches
opt('o', 'incsearch', true)                           -- Show matches while typing
opt('o', 'wildmode', 'full')                          -- Complete first full match
opt('o', 'lazyredraw', true)                          -- Don't redraw during macros
opt('o', 'signcolumn', 'yes:1')                       -- Always show sign column
opt('o', 'background', 'dark')                        -- Dark background
opt('o', 'synmaxcol', 200)                            -- Limit syntax highlight for long lines
opt('o', 'foldlevelstart', 99)                        -- Start with all folds open
opt('o', 'cmdheight', 1)                              -- Command line height
opt('o', 'inccommand', 'split')                       -- Preview substitutions live, as you type!
opt('o', 'autochdir', false)                          -- Don't auto change directory
