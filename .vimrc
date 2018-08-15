set nocompatible

" Install plug if it's not already installed.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Bring in a bunch of packages.
call plug#begin()
" UI / Theme
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'rakr/vim-one'
Plug 'scrooloose/nerdtree'
Plug 'mhinz/vim-startify'

" Tools
Plug 'ervandew/supertab'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'ctrlpvim/ctrlp.vim'
" TODO: This still does things *wrong* with jumpping to closing pairs.
Plug 'jiangmiao/auto-pairs'
Plug 'jremmen/vim-ripgrep'
Plug 'mbbill/undotree'
Plug 'ntpeters/vim-better-whitespace'
" `gcc`, `gc` and others for commenting.
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'

" Languages
Plug 'cespare/vim-toml'
Plug 'dag/vim-fish'
Plug 'elixir-lang/vim-elixir'
Plug 'elzr/vim-json'
Plug 'plasticboy/vim-markdown'
Plug 'rust-lang/rust.vim'
Plug 'timonv/vim-cargo'
Plug 'vim-latex/vim-latex'
Plug 'wlangstroth/vim-racket'
call plug#end()

set wildmode=longest,list:longest
set wildmenu
set complete=.,kspell,t
set completeopt=menuone,preview
let g:SuperTabDefaultCompletionType = "context"

let g:startify_change_to_dir = 0
let g:startify_custom_header = 'startify#fortune#quote()'

" Colorize color strings.
let g:colorizer_auto_color = 1

" Highlight search matches.
set hlsearch
let g:rg_highlight = 1
" Map Ctrl-/ to clear highlighting.
" NOTE: It's very strange that <C-_> is vim's way of saying this.
nnoremap <silent> <C-_> :nohl<CR>
" vimgrep the current word.
noremap <F2> :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>

" Find the current word.
noremap <F3> :/<C-r><C-w><CR>

" Persist undos.
:silent call system('mkdir -p $HOME/.vim/undo')
set undodir=$HOME/.vim/undo
set undofile

" Use 24-bit colors (required for the 'one' theme to work).
set termguicolors

" Setup the color theme.
syntax enable
set background=dark
colorscheme one

" Distraction free.
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" Configure lightline to always show.
" TODO: Git information in lightline.
set noshowmode
set laststatus=2
let g:lightline = { 'colorscheme': 'one' }

" Add a numberline gutter.
:set number

" Highlight the line the cursor is on.
:set cursorline

" Text overflows and requires scrolling.
" This is an intentionally long line to allow easy testing of the editor overflow. In general we like to have ~80 char max.
set colorcolumn=80
set textwidth=0
set nowrap sidescroll=1 listchars=extends:>
set sidescrolloff=10

" Show tabs.
set list
set listchars=tab:>-

" Unbind the cursor keys in insert, normal and visual modes.
for prefix in ['i', 'n', 'v', 'c']
  for key in ['<up>', '<down>', '<left>', '<right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor
endfor

" Bind vim style movement keys for command mode.
cnoremap <C-h> <left>
cnoremap <C-j> <down>
cnoremap <C-k> <up>
cnoremap <C-l> <right>

" Bind standard movement C-a for moving to the start of the line.
" C-e is already bound.
cnoremap <C-a> <C-b>

" Bind F1 to look up under the cursor.
" TODO: This fails if nothing is under the cursor.
nnoremap <F1> :help <C-r><C-w><CR>

" Open the NERDTree directory viewer.
noremap <C-Bslash> :NERDTreeToggle<CR>

" Testing keybinds.
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
let g:test#preserve_screen = 1

" Execute . once for each line in visual selection.
vnoremap . :normal .<CR>

" Clipboard support
set clipboard=unnamedplus

" Strip whitespace on save.
autocmd BufEnter * EnableStripWhitespaceOnSave

" Folding
set nofoldenable

" Default indentation values.
set expandtab
set shiftwidth=4
set tabstop=4

" Some filetypes we default to smaller tab length.
filetype plugin indent on
autocmd FileType ruby setlocal tabstop=2 shiftwidth=2
autocmd FileType html setlocal tabstop=2 shiftwidth=2
autocmd FileType eruby setlocal tabstop=2 shiftwidth=2
autocmd FileType css setlocal tabstop=2 shiftwidth=2
autocmd FileType scss setlocal tabstop=2 shiftwidth=2
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2

" Use C-style comments.
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

" Allow clicking with the mouse.
set mouse=a

" Allow subshells to detect running in vim.
let $INSIDE='vim'

" Vim command tab completion.
set wildmode=longest,list,full
set wildmenu

" Spell checking.
hi clear SpellBad
hi SpellBad cterm=underline ctermfg=red
map <F5> :setlocal spell! spelllang=en_us<CR>

" Don't play with my JSON.
let g:vim_json_syntax_conceal = 0

" Markdown
let g:vim_markdown_conceal = 0
let g:tex_conceal = 0
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1

