syntax on

let mapleader = "\<Space>"
" let g:vimtex_compiler_progname = 'nvr'
" let g:node_host_prog = '/usr/local/bin/neovim-node-host'

" General settings {{{
" set guicursor=
set encoding=UTF-8
set noshowmode
set nu                          "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set belloff=all
set autoread                    "Reload files changed outside vim
" set cursorline                  " highlight current line
" set cursorcolumn                " highlight current column
set wildmenu                    " visual autocomplete for command menu
set lazyredraw                  " redraw only when we need to.
set showmatch                   " highlight matching [{()}]
set hidden                      " hide buffer instead of closing them
set nowrap                      "Don't wrap lines
set noswapfile
set nobackup
set nowb
set autoindent                  " Indentation
set smartindent
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set foldmethod=marker           " Flods
set foldlevel=20
set modelines=1
set list listchars=tab:\ \ ,trail:· " Visually display tabs and trailing spaces
set scrolloff=3                 "Start scrolling when we're 3 lines away from margins
set sidescrolloff=15
set sidescroll=1
set mouse=a
set mousehide
set splitbelow splitright       " default split
set fillchars+=vert:\
set incsearch                   " Find the next match as we type the search
set hlsearch                    " Highlight searches by default
set ignorecase                  " Ignore case when searching...
set smartcase                   " ...unless we type a capital
set clipboard+=unnamedplus
set signcolumn=yes
set cindent
set re=1
set termguicolors

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Keep undo history across sessions, by storing in file.
" Only works all the time.
" if has('persistent_undo') && isdirectory(expand('~').'/.config/nvim/backups')
"   silent !mkdir ~/.config/nvim/backups > /dev/null 2>&1
"   set undodir=~/.config/nvim/backups
"   set undofile
" endif

" }}}

" Plugins {{{

" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'wincent/ferret'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'editorconfig/editorconfig-vim'
Plug 'itchyny/lightline.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'gruvbox-community/gruvbox'
Plug 'ryanoasis/vim-devicons'
Plug 'mhinz/vim-startify'
Plug 'vimwiki/vimwiki'
Plug 'pechorin/any-jump.vim'
Plug 'mattn/emmet-vim'
Plug 'voldikss/vim-floaterm'
Plug 'wellle/targets.vim'
Plug 'ap/vim-css-color'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'peitalin/vim-jsx-typescript'
Plug 'mattn/calendar-vim'
" Plug 'lambdalisue/fern.vim'
" Plug 'w0rp/ale'
" Plug 'sheerun/vim-polyglot'
" Plug 'stsewd/fzf-checkout.vim'
" Plug 'junegunn/vim-easy-align'
" Plug 'wincent/terminus'
" Plug 'tpope/vim-eunuch'
" Plug 'tpope/vim-dispatch'
" Plug 'tpope/vim-sleuth'
" Plug 'tpope/vim-vinegar'
" Plug 'tpope/vim-abolish'
" Plug 'tpope/vim-jdaddy'
" Plug 'myusuf3/numbers.vim'
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
" Plug 'morhetz/gruvbox'
" Plug 'sjl/gundo.vim'
" Plug 'sotte/presenting.vim'
" Plug 'gyim/vim-boxdraw'
" Plug 'airblade/vim-rooter'
" Plug 'justinmk/vim-sneak'
" Plug 'unblevable/quick-scope'
" Plug 'tmux-plugins/vim-tmux'
" Plug 'inside/vim-search-pulse'
" Plug 'honza/vim-snippets'
" Plug 'vim-pandoc/vim-pandoc'
" Plug 'vim-pandoc/vim-pandoc-syntax'
" Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
" Plug 'dbeniamine/cheat.sh-vim'
" Plug 'alvan/vim-closetag'
" Plug 'nathanaelkane/vim-indent-guides'
" Plug 'AndrewRadev/splitjoin.vim'

" Initialize plugin system
call plug#end()

let g:gruvbox_contrast_dark='hard'
" let g:gruvbox_termcolors=16
colorscheme gruvbox
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_invert_selection='0'

set background=dark

" rooter
" let g:rooter_patterns = ['.git']

" Calendar
let g:calendar_keys = { 'goto_next_month': 'n', 'goto_prev_month': 'p', 'goto_next_year': 'N', 'goto_prev_year': 'P'}

" Floaterm
let g:floaterm_gitcommit='floaterm'
let g:floaterm_autoinsert=1
let g:floaterm_width=0.8
let g:floaterm_height=0.8
let g:floaterm_wintitle=0
let g:floaterm_autoclose=1

" Floaterm keymap
let g:floaterm_keymap_new = '<Leader>tn'

" emmet
let g:user_emmet_leader_key='<C-y>'

" vim close tag config
" let g:closetag_filenames = '*.html,*.js,*.jsx'
" let g:closetag_shortcut = '>'
" let g:closetag_close_shortcut = '<leader>>'

" ferret config
let g:FerretMap=0

" Any jump config
let g:any_jump_disable_default_keybindings = 1
let g:any_jump_grouping_enabled = 1

" search pulse
" let g:vim_search_pulse_mode = 'pattern'
" let g:vim_search_pulse_color_list = [9, 9, 9, 9, 9]

" " sneak
" let g:sneak#s_next = 1
" " Cool prompts
" let g:sneak#prompt = '🔎 '

" Startify
let g:startify_lists = [
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ ]
let g:startify_bookmarks = [
            \ { 'i': '~/.config/nvim/init.vim' },
            \ { 'z': '~/.zshrc' },
            \ { 'g': '~/.gitconfig' },
            \ { 'b': '~/Library/Preferences/org.dystroy.broot/conf.toml' },
            \ { 't': '~/.tmux.conf'},
            \ { 'a': '~/.config/alacritty/alacritty.yml'},
            \ { 'l': '~/Library/Application\ Support/jesseduffield/lazygit/config.yml' }
            \ ]

" Trigger a highlight in the appropriate direction when pressing these keys:
" let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
" let g:qs_max_chars=200
" highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
" highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline

" set highlight to 1000 ms
" let g:highlightedyank_highlight_duration = 1000
" highlight HighlightedyankRegion cterm=reverse gui=reverse

" vimwiki
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

" Coc status line
" lightline
let g:lightline = {
      \ 'mode_map': {
      \ 'n' : 'N',
      \ 'i' : 'I',
      \ 'R' : 'R',
      \ 'v' : 'V',
      \ 'V' : 'VL',
      \ "\<C-v>": 'VB',
      \ 'c' : 'C',
      \ 's' : 'S',
      \ 'S' : 'SL',
      \ "\<C-s>": 'SB',
      \ 't': 'T',
      \ },
      \ 'active': {
      \   'left': [
      \     [ 'mode', 'paste' ],
      \     [ 'gitbranch', 'filename', 'gitblame' ]
      \   ],
      \   'right': [
      \   ],
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'gitblame': 'LightlineGitBlame',
      \ }
      \ }

function! LightlineGitBlame() abort
    let blame = get(b:, 'coc_git_blame', '')
    return winwidth(0) > 120 ? blame[0:120] : ''
endfunction

" editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" }}}

" Key Mappings {{{

" Join line
noremap <Leader>j :j<cr>
noremap <Leader>J :j!<cr>

" Toggle syntax fold marker
noremap <Leader>cy :set foldmethod=syntax<cr>

" coc-smartf
nmap f <Plug>(coc-smartf-forward)
nmap F <Plug>(coc-smartf-backward)
nmap ; <Plug>(coc-smartf-repeat)
nmap , <Plug>(coc-smartf-repeat-opposite)

augroup Smartf
  autocmd User SmartfEnter :hi Conceal ctermfg=220 guifg=#FFFF00
  autocmd User SmartfLeave :hi Conceal ctermfg=239 guifg=#504945
augroup end

" RG for word under cursor
nnoremap <silent> <Leader>ur :Ack <C-R><C-W><CR>

noremap <Leader>pi :PlugInstall<cr>
noremap <Leader>pc :PlugClean<cr>
nnoremap <silent> \ :noh<return>
nnoremap <Leader>s :w<CR>
nmap <Leader><Leader> V
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Startify
nnoremap <Leader>S :Startify<cr>

" Anyjump mappings
nnoremap <leader>aj :AnyJump<CR>
xnoremap <leader>aj :AnyJumpVisual<CR>
nnoremap <leader>ab :AnyJumpBack<CR>
nnoremap <leader>al :AnyJumpLastResults<CR>

" ferret mappings
nmap <leader>x <Plug>(FerretAck)
nmap <leader>y <Plug>(FerretLack)
nmap <leader>z <Plug>(FerretAckWord)
nmap <leader>r <Plug>(FerretAcks)

" disable recording macros: I hit this key accidentally too often
nnoremap q <Nop>

" Quickfix list movement
nmap <Leader>cj :cnext<cr>
nmap <Leader>ck :cprevious<cr>
nmap <Leader>co :copen<cr>

" CocCommand
nmap <Leader>cc :<C-u>CocList commands<cr>
" Find commands
nmap <Leader>cm :Commands<cr>

" set working directory to git project root
" or directory of current file if not git project
function! ToggleEslint()
    if filereadable(".eslintrc.json")
        call coc#config('eslint.enable', v:true)
    elseif filereadable(".eslintrc.js")
        call coc#config('eslint.enable', v:true)
    else
        call coc#config('eslint.enable', v:false)
    endif
endfunction

function! SetProjectRoot()
  " default to the current file's directory
  lcd %:p:h
  let git_dir = system("git rev-parse --show-toplevel")
  " See if the command output starts with 'fatal' (if it does, not in a git repo)
  let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
  " if git project, change local directory to git project root
  if empty(is_not_git_dir)
    lcd `=git_dir`
    call ToggleEslint()
  endif
endfunction

nnoremap <silent> <leader>cd :call SetProjectRoot()<CR>

" enable eslint only if eslintrc is available
call ToggleEslint()

" Easy align
" xmap ga <Plug>(EasyAlign)
" nmap ga <Plug>(EasyAlign)

" Fugitive config
nmap <Leader>gs :G<cr>
nmap <Leader>gf :diffget //2<cr>
nmap <Leader>gj :diffget //3<cr>

" Coc-git mapping
" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" " show chunk diff at current position
nmap gs <Plug>(coc-git-chunkinfo)

" Find in current file
nmap <Leader>f :BLines<cr>
nmap <Leader>F :Lines<cr>

" " Toggle numbers
" nmap <Leader>n :NumbersToggle<cr>
nmap <Leader>n :set nu!<cr>
nmap <Leader>N :set rnu!<cr>

" Coc explorer
nmap <Leader>e :CocCommand explorer<CR>

" format pasted text
:nnoremap p ]p
:nnoremap <c-p> p
inoremap <c-p> <c-r>"
inoremap <c-S-p> <c-r>*

" Copy file path
nmap <Leader>cp :let @+ = expand("%")<cr>

" Higher - Middle - Lower
nnoremap <Leader>h H
nnoremap <Leader>m M
nnoremap <Leader>l L

" Remap ctrl+u or ctrl+d to shift+u and shift+d
noremap <S-u> <C-u>
noremap <S-d> <C-d>

" exit insert mode
vmap ;; <esc>
imap jk <esc>
tmap ;; <esc>
cmap ;; <esc>

" Stop that stupid window from popping up
map q: :q
noremap QQ :q!<cr>
noremap qq :q<cr>
nnoremap Q <nop>
" Close all splits
nmap qo :only<cr>

" edit vimrc/zshrc and load vimrc bindings
nnoremap <Leader>ve :e $MYVIMRC<cr>
nnoremap <Leader>vr :source $MYVIMRC<cr>
" nnoremap <Leader>ze :e ~/.zshrc<cr>

" Remap splits navigation to just CTRL + hjkl
nnoremap <S-h> <C-w>h
nnoremap <S-j> <C-w>j
nnoremap <S-k> <C-w>k
nnoremap <S-l> <C-w>l
tnoremap <S-h> <C-\><C-n><C-w>h
tnoremap <S-j> <C-\><C-n><C-w>j
tnoremap <S-k> <C-\><C-n><C-w>k
tnoremap <S-l> <C-\><C-n><C-w>l

" Quicklist navigation
nnoremap <C-j> :cnext<cr>
nnoremap <C-k> :cprev<cr>

" Make adjusing split sizes a bit more friendly
noremap <silent> <C-S-Left> :vertical resize -5<CR>
noremap <silent> <C-S-Right> :vertical resize +5<CR>
noremap <silent> <C-S-Up> :resize +5<CR>
noremap <silent> <C-S-Down> :resize -5<CR>

" Change 2 split windows from vert to horiz or horiz to vert
map <Leader>th <C-w>t<C-w>H
map <Leader>tk <C-w>t<C-w>K

" nnoremap <leader>u :GundoToggle<CR>
" nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" coc
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" use <c-space>for trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Use <Tab> and <S-Tab> to navigate the completion list
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" <cr> select the first completion item and confirm the completion when no item has been selected
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" Close the preview window when completion is done
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Symbol renaming.
nmap <leader>2 <Plug>(coc-rename)

" Fzf
nnoremap <silent> <leader>o :GFiles<cr>
nnoremap <silent> <leader>b :Files<cr>

" Coc multicursor
nmap <silent> <C-c> <Plug>(coc-cursors-position)
nmap <silent> <C-d> <Plug>(coc-cursors-word)
xmap <silent> <C-d> <Plug>(coc-cursors-range)

" Coc spell check
nmap <leader>a <Plug>(coc-codeaction-selected)<cr>
vmap <leader>a <Plug>(coc-codeaction-selected)<cr>
nmap <leader>c <Plug>(coc-cspell-toggle)<cr>

noremap <silent> <leader>pv :call OpenMarkdownPreview()<cr>
function! OpenMarkdownPreview() abort
  if exists('s:markdown_job_id') && s:markdown_job_id > 0
    call jobstop(s:markdown_job_id)
    unlet s:markdown_job_id
  endif
  let s:markdown_job_id = jobstart('grip ' . shellescape(expand('%:p')))
  if s:markdown_job_id <= 0 | return | endif
  call system('open http://localhost:6419')
endfunction

" }}}

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()

command! Diary VimwikiDiaryIndex
augroup vimwikigroup
    autocmd!
    " automatically update links on read diary
    autocmd BufRead,BufNewFile diary.md VimwikiDiaryGenerateLinks
augroup end

" vim:foldmethod=marker
