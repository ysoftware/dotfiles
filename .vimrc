set path+=~/Documents/ios-pod-mobile-sim/**
set ruler
set rnu
set number 

set belloff=all

nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

colorscheme onehalflight 
noremap <C--> :colorscheme onehalflight<CR> 
noremap <C-=> :colorscheme onehalfdark<CR>

set guifont=Fira\ Code:h12

syntax on
set autowrite
set backspace=indent,eol,start

nnoremap <C-d> <C-d>zz 
nnoremap <C-u> <C-u>zz 

nnoremap n nzzzv
nnoremap N Nzzzv

imap jk <Esc>

nnoremap <S-down> :m .+1<CR>==
nnoremap <S-up> :m .-2<CR>==
inoremap <S-down> <Esc>:m .+1<CR>==gi
inoremap <S-up> <Esc>:m .-2<CR>==gi
vnoremap <S-down> :m '>+1<CR>gv=gv
vnoremap <S-up> :m '<-2<CR>gv=gv


set shiftwidth=4
set smartindent
set tabstop=4

