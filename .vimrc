" TODO
" Peek here: https://github.com/rluba/neovim-config/blob/master/init.vim
" fix file search previews on Windows
" Don't open new tab for vimrc if it's open, activate it
" We jump with <C-u> 1 line less the first time than <C-d>

" Snippets
if has('mac')
    :ab ws [weak self] in<Left><Left><Left>
    :ab gl guard let self else { return }
    :ab si .store(in: &subscribers)
endif
 
" Setup File Search
if has('win32')
    nnoremap <C-S-up> :tabnew D:\Documents\GitHub\vimrc\.vimrc<CR>
    nnoremap <C-]> :Files D:\Documents\GitHub\miseq<CR>
    nnoremap <C-p> :AgIn D:\Documents\GitHub\miseq<CR>
    nnoremap <C-h> :History<CR>
elseif has('mac')
    nnoremap <C-S-down> :tabnew ~/Documents/Check24/check24-worklog/worklog.txt<CR>
    nnoremap <C-S-up> :tabnew ~/Documents/GitHub/vimrc/.vimrc<CR>
    nnoremap <C-]> :Files ~/Documents/Check24/ios-pod-mobile-sim<CR>
    nnoremap <C-p> :AgIn ~/Documents/Check24/ios-pod-mobile-sim<CR>
    nnoremap <C-h> :History<CR>
endif

" List of installed plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Syntax highlighting
Plug 'keith/swift.vim' " Swift support
Plug 'jansedivy/jai.vim' " Jai support

Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive' " Git
Plug 'itchyny/lightline.vim' " Status line
Plug 'mhinz/vim-startify' " Startup screen
Plug 'airblade/vim-gitgutter' " Git diffs
Plug 'tpope/vim-commentary' " Comment lines of code
Plug 'preservim/nerdtree' " Project tree
Plug 'Mofiqul/vscode.nvim'
call plug#end()

let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_action = { 'enter': 'tab split' }

" Files setup
command! -bang -nargs=+ -complete=dir Files
	\ call fzf#vim#files(<q-args>, 
    \ fzf#vim#with_preview({'options': [
	\     '--reverse', '-i', '--info=inline', '--keep-right'
	\ ]}, 'right:40%'), <bang>0)

" AgIn setup
function! s:ag_in(bang, ...)
    call fzf#vim#ag(join(a:000[1:], ' '),
        \ '--ignore=*.pbxproj',
        \ fzf#vim#with_preview({'dir': expand(a:1), 'options': [
        \     '--reverse', '-i', '--info=inline', '--keep-right'
        \ ]}, 'down:60%'), a:bang)
endfunction
command! -bang -nargs=+ -complete=dir AgIn call s:ag_in(<bang>0, <f-args>)

" Setup Plugin Manager
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Setup nerd tree
let NERDTreeShowHidden=1
let NERDTreeCustomOpenArgs={'file':{'where': 't'}}

" Disable Copilot by default on macbook
if has('mac')
    let g:copilot_enabled = v:true
    let g:copilot_auto_enable = v:true
    let g:copilot_filetypes = { '*': v:false, 'swift': v:true, 'jai': v:true, 'c': v:true, 'h': v:true, 'vim': v:true, 'javascript': v:true }
endif

" Setup lightline
set noshowmode
let g:lightline = { 'colorscheme': 'one', 
      \   'active': {
      \     'left': [ [ 'mode', 'paste' ],
      \               [ 'gitbranch', 'readonly', 'filename', 'modified' ]]
      \   },
      \   'component_function': {
      \     'gitbranch': 'FugitiveHead'
      \   },
      \ }

colorscheme vscode
set background=dark
noremap <C-S-Right> :set background=light<CR><C-l>
noremap <C-S-Left> :set background=dark<CR><C-l>

" Copy paste stuff
noremap p "+p
noremap P "+P
noremap y "+y
noremap Y "+Y

" Visuals
if has('win32')
    set guifont=Fira\ Code:h15
else
    set guifont=Fira_Code_Retina:h16
endif

if has('win32')
    set backspace=indent,eol,start
    set belloff=all
endif

syntax on
set ruler
set rnu
set number 
set autowrite
set wildignorecase
set scroll=15

" Search
let g:searchindex_line_limit=2000000
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

if has('win32') " TODO: fix windows commands
    " nnoremap <leader>p *ve"+y:exe 'AgIn ~\Documents\ ' . @+<CR>
    " vnoremap <leader>p "+y:exe 'AgIn ~\Documents\ ' . @+<CR>
else
    nnoremap <leader>p *ve"+y:exe 'AgIn ~/Documents/Check24/ios-pod-mobile-sim ' . @+<CR>
    vnoremap <leader>p "+y:exe 'AgIn ~/Documents/Check24/ios-pod-mobile-sim ' . @+<CR>
endif

" Navigation
" nnoremap <C-d> <C-d>zz 
" nnoremap <C-u> <C-u>zz 
nnoremap n nzzzv
nnoremap N Nzzzv

" Brackets around selection
xnoremap <leader>[ <ESC>a]<ESC>gv`<<ESC>i[<ESC>
xnoremap <leader>( <ESC>a)<ESC>gv`<<ESC>i(<ESC>
xnoremap <leader>{ <ESC>a}<ESC>gv`<<ESC>i{<ESC>

" Jump to next empty line
noremap } <Cmd>call search('^\s*$\\|\%$', 'W')<CR>
noremap { <Cmd>call search('^\s*$\\|\%^', 'Wb')<CR>

" Jump to next git change
nmap ]h <Plug>(GitGutterNextHunk)zz
nmap [h <Plug>(GitGutterPrevHunk)zz

" Create new tab
nnoremap tg gT
nnoremap <leader>' :tabnew<CR>
nnoremap <leader>q :bd<CR>

" Funny command to quit insert mode without escape
imap jk <Esc>:cd %:p:h<CR>

" Tab lines
vnoremap < <gv
vnoremap > >gv

" Nerd tree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Prettify json (depends on installed jq)
command! Prettify :%!jq .

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

" Build xcode project
if has('mac')
else
    nnoremap <C-b> :make<CR>
endif
