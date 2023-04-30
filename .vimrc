" Setup File Search
if has('win32')
    nnoremap <C-S-up> :e ~\Documents\GitHub\vimrc\.vimrc<CR>
    nnoremap <C-]> :Files ~\Documents\GitHub\<CR>
    nnoremap <C-p> :AgIn ~\Documents\GitHub\<CR>
    nnoremap <C-h> :History<CR>
elseif has('mac')
    nnoremap <C-S-up> :e ~/Documents/GitHub/vimrc/.vimrc<CR>
    nnoremap <C-]> :Files ~/Documents/ios-pod-mobile-sim<CR>
    nnoremap <C-p> :AgIn ~/Documents/ios-pod-mobile-sim<CR>
    nnoremap <C-h> :History<CR>
endif

command! -bang -nargs=+ -complete=dir Files
	\ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': [
	\	'--reverse', '-i', '--info=inline', '--keep-right'
	\ ]}, 'right:40%'), <bang>0)
function! s:ag_in(bang, ...)
    call fzf#vim#ag(join(a:000[1:], ' '), fzf#vim#with_preview({'dir': expand(a:1), 'options': [
		\ '--reverse', '-i', '--info=inline', '--keep-right'
        \ ]}, 'down:60%'), a:bang)
endfunction
command! -bang -nargs=+ -complete=dir AgIn call s:ag_in(<bang>0, <f-args>)

" Setup Plugin Manager
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" List of installed plugins
call plug#begin('~/.local/share/nvim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'dense-analysis/ale'
Plug 'github/copilot.vim'
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'

call plug#end()

" Plugins set up
let g:ale_completion_enabled = 1
let g:ale_linters = {'swift': []}

" Switch tabs
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Setup status line
let g:lightline = { 'colorscheme': 'one', 
      \   'active': {
      \     'left': [ [ 'mode', 'paste' ],
      \               [ 'gitbranch', 'readonly', 'filename', 'modified' ]]
      \   },
      \   'component_function': {
      \     'gitbranch': 'FugitiveHead'
      \   },
      \ }
set noshowmode

" Adjust color theme
colorscheme onehalfdark
noremap <C-S-Left> :colorscheme onehalflight<CR><C-l>
noremap <C-S-Right> :colorscheme onehalfdark<CR><C-l>

" Copy paste stuff
noremap p "+p
noremap P "+P
noremap y "+y
noremap Y "+Y

" Visual
set guifont=Fira\ Code:h16
syntax on
set ruler
set rnu
set number 
set autowrite
set scroll=20
set wildignorecase

if has('win32')
set backspace=indent,eol,start
set belloff=all
endif

" Search and center
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
nnoremap <C-d> <C-d>zz 
nnoremap <C-u> <C-u>zz 
nnoremap n nzzzv
nnoremap N Nzzzv

imap jk <Esc>:cd %:p:h<CR>

" Move lines
nnoremap <S-down> :m .+1<CR>==
nnoremap <S-up> :m .-2<CR>==
inoremap <S-down> <Esc>:m .+1<CR>==gi
inoremap <S-up> <Esc>:m .-2<CR>==gi
vnoremap <S-down> :m '>+1<CR>gv=gv
vnoremap <S-up> :m '<-2<CR>gv=gv

" Tabs and shit
filetype plugin indent on
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.
set shiftwidth=4    " Indents will have a width of 4.
set softtabstop=4   " Sets the number of columns for a TAB.
set expandtab       " Expand TABs to spaces.
set sw=4 

