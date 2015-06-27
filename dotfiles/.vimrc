" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" <leader> char
let mapleader="\\"

" Use OS clipboard
set clipboard=unnamed

" Enhance command-line completion
set wildmenu

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Fast terminal connections
set ttyfast

" Use UTF-8 w/o BOM
set encoding=utf-8 nobomb

" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
    set undodir=~/.vim/undo
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Keep 50 lines of command line history
set history=50

" Show the cursor position
set ruler

" Enable line numbers
set number

" Show the (partial) command as it’s being typed
set showcmd

" Highlight dynamically as pattern is typed
set incsearch

" Highlight searches
set hlsearch

" Ignore case of searches
set ignorecase

" Enable syntax highlighting
syntax on

" Make tabs as wide as four spaces
set tabstop=4

" Show invisible characters
"set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
"set list

" Enable mouse in all modes
set mouse=a

" Disable error bells
set noerrorbells

" Don’t reset cursor to start of line when moving around
set nostartofline

" Show the current mode
set showmode

" Show the filename in the window titlebar
set title

" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Always set autoindenting on
set autoindent

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

" Strip trailing whitespace (<leader>ss)
function! StripWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Automatic commands
if has("autocmd")
    " Enable file type detection
    filetype on
    " Treat .json files as .js
    autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
    " Treat .md files as Markdown
    autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif
