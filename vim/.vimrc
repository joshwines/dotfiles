call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Syntax
Plug 'elzr/vim-json',              { 'for': ['json'] }
Plug 'othree/html5.vim',           { 'for': ['html', 'eelixir'] }
Plug 'slim-template/vim-slim',     { 'for': ['slim'] }
Plug 'pangloss/vim-javascript',    { 'for': ['javascript', 'javascript.jsx'] }
Plug 'kchmck/vim-coffee-script',   { 'for': ['coffee'] }
Plug 'mattn/emmet-vim',            { 'for': ['html', 'javascript.jsx'] }
Plug 'tpope/vim-fugitive'
Plug 'rking/ag.vim'
Plug 'kien/ctrlp.vim'

call plug#end()

" make vim more useful
set nocompatible

" improve security
set modelines=0

" color scheme
set background=dark
colorscheme solarized
let g:solarized_termtrans=1

" use osclipboard
set clipboard=unnamed

" better file name tab completion
set wildmode=longest,list,full
set wildmenu

" allow backspace in insert mode
set backspace=indent,eol,start

" optimize for fast terminal connections
set ttyfast

" use g flag for search/replace by default
set gdefault

" use utf-8 without bom
set encoding=utf-8 nobomb

" change mapleader
let mapleader=","

" centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
set undofile
set undodir=~/.vim/undo
set noswapfile

" don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" show line numbers
set number

" enable syntax highlighting
syntax on

" highlight current line
set cursorline

" tabs
set tabstop=4
set shiftwidth=2
set softtabstop=2
set expandtab

" show “invisible” characters
set lcs=tab:▸\ ,trail:·,nbsp:_
set list

" highlight searches
set hlsearch
set incsearch

" ignore case of searches
set ignorecase

" always show status line
set laststatus=2

" disable error bells
set noerrorbells

" show the cursor position
set ruler

" don’t show the intro message when starting vim
set shortmess+=I

" show the current mode
set showmode

" show the filename in the window titlebar
set title

" show the (partial) command as it’s being typed
set showcmd

" start scrolling four lines before the horizontal window border
set scrolloff=4

" show 80th character column
set colorcolumn=80

" vim-ruby is shit slow. speed it up a bit
set lazyredraw
let ruby_no_expensive=1

" strip trailing whitespace
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" save a file as root
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" shortcut to turn off previous search highlight
nmap <silent> ,/ :nohlsearch<CR>

" enable file type detection
filetype plugin indent on

" automatic commands
if has("autocmd")
	" treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript

	" treat .md files as markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif

" make ctrlp faster
if executable('ag')
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
	let g:ag_prg="ag --vimgrep"
	ca Ag Ag!
endif

" be less noob
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" search
function! FzyCommand(choice_command, vim_command)
  try
    let output = system(a:choice_command . " | fzy ")
  catch /Vim:Interrupt/
    " Swallow errors from ^C, allow redraw! below
  endtry
  redraw!
  if v:shell_error == 0 && !empty(output)
    exec a:vim_command . ' ' . output
  endif
endfunction

nnoremap <leader>e :call FzyCommand("ag . --silent -l -g ''", ":e")<cr>
nnoremap <leader>t :call FzyCommand("ag . --silent -l -g ''", ":tabe")<cr>
nnoremap <leader>v :call FzyCommand("ag . --silent -l -g ''", ":vs")<cr>
nnoremap <leader>s :call FzyCommand("ag . --silent -l -g ''", ":sp")<cr>
