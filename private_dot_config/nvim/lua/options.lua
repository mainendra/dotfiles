-- Editor options
-- Only options that differ from Neovim defaults are set here

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
opt.inccommand = 'split'     -- Show live preview of :substitute in a split

-- UI
opt.number = true            -- Show absolute line numbers
opt.cursorline = true        -- Highlight the current line
opt.wrap = false             -- Disable line wrapping
opt.list = true              -- Show invisible characters (tabs, trailing spaces)
opt.signcolumn = 'yes:1'     -- Always show sign column with width of 1
opt.pumheight = 10           -- Max number of items in popup menu
opt.winblend = 0             -- Opaque floating windows (opt out of mini.basics extra_ui transparency)
opt.pumblend = 0             -- Opaque popup menu (opt out of mini.basics extra_ui transparency)
opt.background = 'dark'      -- Use dark variant of colorscheme
opt.synmaxcol = 200          -- Max column for syntax highlighting (performance)
opt.winborder = 'rounded'    -- Border for floating windows

-- Splits
opt.splitbelow = true        -- Open horizontal splits below current window
opt.splitright = true        -- Open vertical splits to the right

-- Scrolling
opt.scrolloff = 4            -- Min lines to keep above/below cursor
opt.sidescrolloff = 8        -- Min columns to keep left/right of cursor

-- Files and buffers
opt.swapfile = false         -- Disable swap file creation
opt.backup = false           -- Disable backup file creation
opt.writebackup = false      -- Disable backup before overwriting a file
opt.undofile = true          -- Persist undo history to disk
opt.confirm = true           -- Prompt to save changes instead of failing

-- Completion
opt.completeopt = 'menuone,noinsert,noselect' -- Show menu even for one match, don't auto-insert or select
opt.wildmode = 'full'        -- Complete the next full match

-- Folding (treesitter-based)
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldlevelstart = 99      -- Start with all folds open

-- Spelling
opt.spell = true
opt.spelllang = { 'en_us' }
opt.spelloptions = 'camel'

-- Misc
opt.mouse = 'a'              -- Enable mouse in all modes
opt.updatetime = 200         -- CursorHold delay (ms)
opt.clipboard = 'unnamedplus' -- Use system clipboard for all yank/paste
