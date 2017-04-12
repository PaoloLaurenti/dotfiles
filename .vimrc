set nocompatible              " be iMproved, required
filetype off                  " required

" Sets how many lines of history VIM has to remember
set history=1000
set undolevels=1000
" Set to auto read when a file is changed from the outside
set autoread
" Set to show line number
set number
" Set to show the cursor position all the time
set ruler
" Display the mode you're in
set showmode
" Set show matching parenthesis
set showmatch
" Set to highlighting the last used search pattern.
set hlsearch
" Set to do incremental searching
set incsearch
" Case-insensitive search
set ignorecase
" But case-sensitive if expression contains a capital letter
set smartcase
" Set autoindent
set autoindent
" Copy previous indentation
set copyindent
" Set the terminal's title
set title
" Don't make a backup before overwriting a file.
set nobackup
" And again.
set nowritebackup
" Don't make swap file
set noswapfile
" No word wrap
set nowrap
" Height of the command bar
set cmdheight=2
" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8
" Prevents some security exploits
set modelines=0
" Enhaced command line completion
set wildmenu
" Complete files like a shell
set wildmode=list:longest,full
" Ignore when expand
set wildignore=*.swp,*.bak,*.o,*.obj
" Always show status line
set laststatus=2
" Highlight current line
" set cursorline
" Faster esc in visual/insert mode
set ttimeout
set ttimeoutlen=10
" No sound bell, flash screen
set visualbell
" Fast terminal connection
set ttyfast
" Global tab width.
set tabstop=4
" And again, related.
set softtabstop=4
" And again, related.
set shiftwidth=4
" Use spaces instead of tabs
set expandtab
" Max line width
set textwidth=80

" No Arrow Keys!
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Format document
map <F7> mzgg=G`z

" Run an external command with only single bang
nnoremap ! :!

augroup FixBeforeWrite
    autocmd!
    autocmd BufWritePre * call RemoveTrailingWhitespaces()
augroup END

" Disable filetpye, this is important to do *before* plugins installation
filetype off

" Install plugins via vim-plug
call plug#begin('~/.vim/plugged')

" Elixir
Plug 'elixir-lang/vim-elixir'
Plug 'slashmili/alchemist.vim'

call plug#end()
" Enable syntax
syntax on

" Enable indentation, this is important to do *after* 'vundle#end()'
filetype plugin indent on

" Custom indentation
if has('autocmd')
    autocmd filetype ruby set tabstop=2 softtabstop=2 shiftwidth=2
    autocmd filetype javascript set tabstop=2 softtabstop=2 shiftwidth=2
    autocmd filetype json set tabstop=2 softtabstop=2 shiftwidth=2
endif

" Activate color scheme
" colorscheme molokai

" Custom function
function! RemoveTrailingWhitespaces()
    let l:save_cursor = getpos('.')
    silent! execute ':%s/\s\+$//'
    call setpos('.', l:save_cursor)
endfunction
