if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
call plug#end()

filetype on
syntax on
set hlsearch
set showmatch
set noshowmode

set relativenumber
set numberwidth=5
set ruler
set cursorline
set cursorcolumn
set colorcolumn=90

set nowrap
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent
set autoindent

colorscheme gruvbox

let g:gruvbox_contrast_dark='soft'
set background=dark

let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1
let g:airline_theme='gruvbox'
let g:hybrid_custom_term_colors=1
let g:hybrid_reduced_contrast=1
