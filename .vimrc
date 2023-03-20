if has('win32')
	set path+=.\Documents\GitHub\Lobstard\**
    set backspace=indent,eol,start
	set belloff=all
elseif has('mac')
	set macligatures

    set path+=~/Documents/ios-pod-mobile-sim/Pod**
	nnoremap <C-o> :Files ~/Documents/ios-pod-mobile-sim/Pod<CR>
	nnoremap <C-p> :AgIn ~/Documents/ios-pod-mobile-sim/Pod<CR>
	
	" Search (Files)
	command! -bang -nargs=? -complete=dir Files
   		\ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': [
		\	'--layout=reverse', '-i', '--info=inline'
		\ ]}), <bang>0)
	
	" Search in files (Ag)
    function! s:ag_in(bang, ...)
        call fzf#vim#ag(join(a:000[1:], ' '), fzf#vim#with_preview({'dir': expand(a:1), 'options': [
			\ '--layout=reverse', '-i', '--info=inline'
	  		\ ]}, 'right:70%'), a:bang)
    endfunction
    command! -bang -nargs=+ -complete=dir AgIn call s:ag_in(<bang>0, <f-args>)

	" Plugins for mac
    let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
    if empty(glob(data_dir . '/autoload/plug.vim'))
      silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
    
    call plug#begin('~/.local/share/nvim/plugged')
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    call plug#end()
endif

set ruler
set rnu
set number 

nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

colorscheme onehalflight 
noremap <C-S-Left> :colorscheme onehalflight<CR> 
noremap <C-S-Right> :colorscheme onehalfdark<CR>

set guifont=Fira\ Code:h16

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
set scroll=20

set wildignorecase
