-- Editor options
-- Uses modern vim.opt API for all settings

local opt = vim.opt
local indent = 4

-- Indentation
opt.shiftwidth = indent      -- Number of spaces for each step of (auto)indent
opt.tabstop = indent         -- Number of spaces a <Tab> counts for
opt.softtabstop = indent     -- Number of spaces a <Tab> counts for while editing
opt.expandtab = true         -- Convert tabs to spaces
opt.smartindent = true       -- Auto-indent new lines based on syntax
opt.shiftround = true        -- Round indent to multiple of shiftwidth

-- Search
opt.ignorecase = true        -- Ignore case in search patterns
opt.smartcase = true         -- Override ignorecase if pattern has uppercase
opt.hlsearch = true          -- Highlight all search matches
opt.incsearch = true         -- Show matches as you type the search pattern
opt.inccommand = 'split'     -- Show live preview of :substitute in a split

-- UI
opt.number = true            -- Show absolute line numbers
opt.relativenumber = false   -- Disable relative line numbers
opt.cursorline = true        -- Highlight the current line
opt.wrap = false             -- Disable line wrapping
opt.list = true              -- Show invisible characters (tabs, trailing spaces)
opt.termguicolors = true     -- Enable 24-bit RGB colors in the TUI
opt.signcolumn = 'yes:1'     -- Always show sign column with width of 1
opt.pumheight = 10           -- Max number of items in popup menu
opt.cmdheight = 1            -- Height of the command-line area
opt.background = 'dark'      -- Use dark variant of colorscheme
opt.lazyredraw = true        -- Don't redraw screen during macros/scripts
opt.synmaxcol = 200          -- Max column for syntax highlighting (performance)

-- Splits
opt.splitbelow = true        -- Open horizontal splits below current window
opt.splitright = true        -- Open vertical splits to the right

-- Scrolling
opt.scrolloff = 4            -- Min lines to keep above/below cursor
opt.sidescrolloff = 8        -- Min columns to keep left/right of cursor

-- Files and buffers
opt.hidden = true            -- Allow switching buffers without saving
opt.swapfile = false         -- Disable swap file creation
opt.backup = false           -- Disable backup file creation
opt.writebackup = false      -- Disable backup before overwriting a file
opt.undofile = true          -- Persist undo history to disk
opt.autoread = true          -- Auto-reload files changed outside of Neovim
opt.fileencoding = 'utf-8'   -- File encoding for the current buffer
opt.confirm = true           -- Prompt to save changes instead of failing

-- Completion
opt.completeopt = 'menuone,noinsert,noselect' -- Show menu even for one match, don't auto-insert or select
opt.wildmenu = true          -- Enhanced command-line completion menu
opt.wildmode = 'full'        -- Complete the next full match

-- Misc
opt.joinspaces = false       -- Don't insert two spaces after punctuation on join
opt.mouse = 'a'              -- Enable mouse in all modes
opt.updatetime = 50          -- Faster CursorHold event trigger (ms)
opt.clipboard = 'unnamedplus' -- Use system clipboard for all yank/paste
opt.history = 1000           -- Number of commands/searches to remember
opt.foldlevelstart = 99      -- Start with all folds open
opt.autochdir = false        -- Don't auto-change directory to current file
