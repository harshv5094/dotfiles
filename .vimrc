"------------------------------
" Basic Settings
"------------------------------
set nocompatible            " Disable Vi compatibility
set number                  " Show line numbers
set relativenumber          " Show relative numbers
set tabstop=2               " Tabs are 2 spaces
set shiftwidth=2            " Indent by 2 spaces
set expandtab               " Convert tabs to spaces
set smartindent             " Auto-indent new lines
set splitright              " Split to right of the current window
set wrap                    " Wrap long lines
set mouse=a                 " Enable mouse support
set clipboard=unnamedplus   " ✅ Use system clipboard for copy/paste
set cursorline              " Enable Cursor Line
set confirm                 " Enable quit before save
syntax on                   " Enable syntax highlighting
filetype plugin indent on   " Enable filetype detection

"------------------------------
" Plugin Manager (vim-plug)
"------------------------------
call plug#begin('~/.vim/plugged')

" Tpope's Sensible Settings plugin
Plug 'tpope/vim-sensible'

" Gruvbox colorscheme
Plug 'morhetz/gruvbox'

" Airline statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" File tree navigation
Plug 'preservim/nerdtree'

" Undo Tree
Plug 'mbbill/undotree'

call plug#end()

"------------------------------
" Colorscheme & UI
"------------------------------
set background=dark         " or light if you prefer
colorscheme gruvbox

" Airline settings
let g:airline_powerline_fonts = 1
let g:airline_theme = 'gruvbox'

"------------------------------
" Key mappings
"------------------------------

" Space as leader key
let mapleader=" "
let maplocalleader="\\"

" Open NERDTree explorer with
map <leader>e <CMD>NERDTreeToggle<CR>
map <leader>u <CMD>UndotreeToggle<CR>

" Open netrw explorer
map <localleader>e <CMD>Ex<CR>

" Split Screen
nmap ss <CMD>split<CR>
nmap sv <CMD>vsplit<CR>

" Move windows
nmap sh <C-w>h
nmap sj <C-w>j
nmap sk <C-w>k
nmap sl <C-w>l

" Resize Window
nmap <C-h> <C-w><
nmap <C-j> <C-w>-
nmap <C-k> <C-w>+
nmap <C-l> <C-w>>

" Current file to executable
nmap <localleader>x <CMD>!chmod +x %<CR>
