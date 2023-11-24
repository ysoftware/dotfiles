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
    nnoremap <C-S-up> :tabnew ~\Documents\GitHub\vimrc\.vimrc<CR>
    nnoremap <C-]> :Files ~\Documents\<CR>
    nnoremap <C-p> :AgIn ~\Documents\<CR>
    nnoremap <C-h> :History<CR>
elseif has('mac')
    nnoremap <C-S-up> :tabnew ~/Documents/GitHub/vimrc/.vimrc<CR>
    nnoremap <C-]> :Files ~/Documents/<CR>
    nnoremap <C-p> :AgIn ~/Documents/<CR>
    nnoremap <C-h> :History<CR>
endif

let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_action = { 'enter': 'tab split' }
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

" LSP
Plug 'keith/swift.vim' " Swift support
Plug 'jansedivy/jai.vim' " Jai support
Plug 'tpope/vim-fugitive' " Git
Plug 'itchyny/lightline.vim' " Status line
Plug 'mhinz/vim-startify' " Startup screen
Plug 'airblade/vim-gitgutter' " Git diffs
Plug 'tpope/vim-commentary' " Comment lines of code
Plug 'preservim/nerdtree' " Project tree
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'Mofiqul/vscode.nvim'

call plug#end()

" Setup nerd tree
let NERDTreeShowHidden=1
let NERDTreeCustomOpenArgs={'file':{'where': 't'}}

" SourceKit-LSP configuration
" if executable('sourcekit-lsp')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'sourcekit-lsp',
"         \ 'cmd': {server_info->['sourcekit-lsp']},
"         \ 'whitelist': ['swift'],
"         \ })
" endif

" Disable Copilot by default
let g:copilot_enabled = v:false

" vim-lsp setup
if executable('sourcekit-lsp')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'sourcekit-lsp',
        \ 'cmd': {server_info->['sourcekit-lsp']},
        \ 'whitelist': ['swift'],
        \ })
endif
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction
augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
augroup filetype
  au! BufRead,BufNewFile *.swift set ft=swift
augroup END

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

syntax on
set ruler
set rnu
set number 
set autowrite
set scroll=15
set wildignorecase

if has('win32')
    set backspace=indent,eol,start
    set belloff=all
endif

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

" Jump to next empty line
noremap } <Cmd>call search('^\s*$\\|\%$', 'W')<CR>
noremap { <Cmd>call search('^\s*$\\|\%^', 'Wb')<CR>

" Jump to next git change
nmap ]h <Plug>(GitGutterNextHunk)zz
nmap [h <Plug>(GitGutterPrevHunk)zz

" Create new tab
nnoremap <leader>' :tabnew<CR>
nnoremap <leader>q :bd<CR>

" Switch tabs and buffers
nnoremap <Tab> :tabnext<CR>
nnoremap <S-Tab> :tabprevious<CR>
nnoremap § :bnext<CR>
nnoremap ` :bnext<CR>
nnoremap ± :bprevious<CR>

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
    function! ReRunLastFileCommand()
      if exists("g:vim_terminal") && exists("g:last_run_in_terminal")
        call RunInTerminal(g:last_run_in_terminal)
      endif
    endfunction
    command! Xb :!osascript ~/Documents/GitHub/vimrc/build_xcode.applescript
    nnoremap <C-b> :Xb<CR><CR>
endif
