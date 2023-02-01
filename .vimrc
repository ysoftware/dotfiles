if has('win32')
	set path+=.\Documents\GitHub\Lobstard\**
    set backspace=indent,eol,start
	map <C-I> :py3f .\Documents\GitHub\swift\utils\swift-indent.py<cr>
	imap <C-I> <c-o>:py3f .\Documents\GitHub\swift\utils\swift-indent.py<cr>
	set pythonthreedll="C:\Program Files (x86)\Python311-32\python3.dll"
    set pythonthreehome="C:\Program Files (x86)\Python311-32"
elseif has('mac')
    set path+=~/Documents/ios-pod-mobile-sim/**
endif

set ruler
set rnu
set number 

set belloff=all

nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

colorscheme onehalfdark 
noremap <C--> :colorscheme onehalflight<CR> 
noremap <C-=> :colorscheme onehalfdark<CR>

set guifont=Fira\ Code:h12

syntax on
set autowrite

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

set wildignorecase


