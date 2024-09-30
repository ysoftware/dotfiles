" Notes
" - To see search count above 100 - :%s///gn

" TODO
" - Disable FUCKING STUPID word wrapping (repro: when typing a long comment, it will auto break at 100th)

" Replace Xcode
" - File explorer (with single state, where certain directories stay open)
" - Jump between edited/specific set of files
" - Replace in multiple files

" Snippets
if has('mac')
  augroup SwiftSnippets
    autocmd!
    autocmd FileType swift abbrev wink .sink { [weak self] in<CR><CR>}<CR>.store(in: &subscribers)<Up><Up><Up><Left><Left><Left>
    autocmd FileType swift abbrev ws [weak self] in<Left><Left><Left>
    autocmd FileType swift abbrev gl guard let self else { return }
    autocmd FileType swift abbrev si .store(in: &subscribers)
  augroup END
endif
 
call plug#begin('~/.local/share/nvim/plugged')

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } 
Plug 'junegunn/fzf.vim'

if has('mac') " Xcode stuff
Plug 'mfussenegger/nvim-dap' " Debug adapter protocol
Plug 'nvim-neotest/nvim-nio' " dependency of DAP
Plug 'rcarriga/nvim-dap-ui' " Dap UI
Plug 'wojciech-kulik/xcodebuild.nvim' " Xcode tools
Plug 'MunifTanjim/nui.nvim' " needed for xcodebuild
Plug 'nvim-telescope/telescope.nvim' " needed for xcodebuild
Plug 'nvim-lua/plenary.nvim' " Needed for telescope
endif

" Syntax highlighting
Plug 'keith/swift.vim' " Swift support
Plug 'jansedivy/jai.vim' " Jai support

Plug 'preservim/nerdtree' | " File browser
    \ Plug 'Xuyuanp/nerdtree-git-plugin' " Plugin with git status

Plug 'neovim/nvim-lspconfig' " Lsp
Plug 'tpope/vim-fugitive' " Git
Plug 'airblade/vim-gitgutter' " More Git
Plug 'bling/vim-bufferline' " Show all open buffers
Plug 'kshenoy/vim-signature' " Show marks
Plug 'itchyny/lightline.vim' " Status line
Plug 'mhinz/vim-startify' " Startup screen
Plug 'tpope/vim-commentary' " Comment lines of code
Plug 'Mofiqul/vscode.nvim' " Color theme
call plug#end()

let g:fzf_history_dir = '~/.local/share/fzf-history'

let g:bufferline_echo = 1
let g:bufferline_inactive_highlight = 'StatusLineNC'
let g:bufferline_solo_highlight = 0

" LSP
lua require("lspconfig").rust_analyzer.setup {}
lua require("lspconfig").ols.setup {}
lua require("lspconfig").clangd.setup {}

if has('mac')
    lua require("lspconfig").sourcekit.setup {}
endif

" DAP (debug adapter protocol)
if has('mac')
    lua require("xcodebuild.integrations.dap").setup("/Users/iaroslav.erokhin/Documents/Other/codelldb-x86_64-darwin/extension/adapter")
    lua require("dapui").setup()
endif

" Files setup
command! -bang -nargs=+ -complete=dir Files
	\ call fzf#vim#files(<q-args>, 
    \     fzf#vim#with_preview(
    \         {
    \             'options': [
    \                 '--reverse', '-i', '--info=inline',
    \                 '--keep-right', '--preview="bat -p --color always {}"'
    \             ]
    \         },
    \         'right:40%'
    \     ), 
    \ <bang>0)

" AgIn setup
function! s:ag_in(bang, ...)
    call fzf#vim#ag(join(a:000[1:], ' '),
        \ '--ignore=*.pbxproj',
        \     fzf#vim#with_preview(
        \         {
        \             'dir': expand(a:1), 
        \             'options': [
        \                 '--reverse', '-i', '--info=inline', 
        \                 '--keep-right', '--preview="bat -p --color always {}"' 
        \             ]
        \         }, 
        \         'down:70%'
        \     ), 
        \ a:bang)
endfunction
command! -bang -nargs=+ -complete=dir AgIn call s:ag_in(<bang>0, <f-args>)

" Setup Plugin Manager
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

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

" weird auto-text wrapping to new line, this is horrible
autocmd Filetype * set formatoptions-=cro

" Before this theme is installed via :PlugInstall, vimrc will give an error here
colorscheme vscode
noremap <C-S-Right> :set background=light<CR><C-l>
noremap <C-S-Left> :set background=dark<CR><C-l>

if has('mac')
    if system('defaults read -g AppleInterfaceStyle') == "Dark\n"
        set background=dark
    else
        set background=light
    endif
else
    set background=dark
endif

" Copy paste with system buffer
noremap p "+p
noremap P "+P
noremap y "+y
noremap Y "+Y

" Visuals
if has('linux')
    set guifont=Fira\ Code:h20
elseif has('mac')
    set guifont=Fira_Code_Retina:h16
endif

syntax on
set ruler
set rnu
set number 
set autowrite
set wildignorecase
set scroll=15

vnoremap // "hy/\C\V<C-R>=escape(@h, '\/')<CR><CR>
vnoremap ts "hy:%s/\V<C-R>=escape(@h, '\/')<CR>//gcI<Left><Left><Left><Left>

" Navigation
let mapleader = " "
nnoremap n nzzzv
nnoremap N Nzzzv
set switchbuf+=useopen

nnoremap <leader>bn :bn<CR>
nnoremap <leader>bv :bp<CR>

" Tabs
nnoremap tg gT
nnoremap <leader>' :tabnew<CR>
nnoremap <leader>q :bd<CR>

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

nnoremap <leader>g :vertical:G<CR>
command! Diff execute 'GitGutterDiff'

" Funny command to quit insert mode without escape
imap jk <Esc>:cd %:p:h<CR>

" Tab lines
vnoremap < <gv
vnoremap > >gv

" Nerd tree
let NERDTreeShowHidden=1
let NERDTreeCustomOpenArgs={'file':{'keepopen': '0'}}
let g:NERDTreeWinSize=50

let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ 'Modified'  :'m',
    \ 'Staged'    :'s',
    \ 'Untracked' :'t',
    \ 'Renamed'   :'r',
    \ 'Unmerged'  :'n',
    \ 'Deleted'   :'d',
    \ 'Dirty'     :'x',
    \ 'Ignored'   :'i',
    \ 'Clean'     :'c',
    \ 'Unknown'   :'u',
    \ }

nnoremap <C-f> :NERDTreeFind<CR>
nnoremap <leader><C-f> :NERDTreeVCS<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

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

" buffers
command! Bufo silent! execute "%bd|e#|bd#"
nnoremap <C-W>. :vertical res +10<CR>
nnoremap <C-W>, :vertical res -10<CR>
nnoremap <C-W>> :res +10<CR>
nnoremap <C-W>< :res -10<CR>

" - SEARCH

" File Search
if has('mac')
    nnoremap <C-S-down> :e ~/Documents/Check24/check24-worklog/worklog.txt<CR>
    nnoremap <C-S-up> :e ~/Documents/GitHub/vimrc/.vimrc<CR>

    nnoremap <C-]> :Files ~/Documents/Check24/ios-pod-mobile-sim<CR>
    nnoremap <C-p> :AgIn ~/Documents/Check24/ios-pod-mobile-sim<CR>
    nnoremap <leader><C-]> :Files ~/Documents<CR>
    nnoremap <leader><C-p> :AgIn ~/Documents<CR>
elseif has('linux')
    nnoremap <C-S-down> :e ~/Documents/os-todos.txt<CR>
    nnoremap <C-S-up> :e ~/Documents/GitHub/vimrc/.vimrc<CR>
    nnoremap <C-]> :Files ~/Documents/<CR>
    nnoremap <C-p> :AgIn ~/Documents/<CR>
endif

" Symbol under cursor
if has('mac')
    nnoremap <leader>p "hyiw:exe 'AgIn ~/Documents/Check24/ios-pod-mobile-sim ' . @h<CR>
    nnoremap <leader>P "hyiw:exe 'AgIn ~/Documents/Check24/ios-pod-mobile-sim ^.*(actor\|enum\|func\|var\|let\|class\|struct\|protocol\|case)(\s+)'.@h<CR>
elseif has('linux')
    nnoremap <leader>p "hyiw:exe 'AgIn ~/Documents ' . @h<CR>
    nnoremap <leader>P "hyiw:exe 'AgIn ~/Documents ^.*(fun\|fn\|void\|int\|struct\|enum)(\s+)'.@h<CR>
endif

set ic " case insensitive search
set gdefault
let g:searchindex_line_limit=2000000
nnoremap <C-h> :History<CR>
nnoremap <leader>n :cn<CR>
nnoremap <C-b> :make<CR>

if has('mac')
    nnoremap <leader>l :XcodebuildCloseLogs<CR> :ccl<CR>
    command! Worklog execute 'cd ' . expand('%:p:h') . ' | !git add . && git commit -m "-"'
else
    nnoremap <leader>l :ccl<CR>
    nnoremap <leader>e :copen<CR>
endif

" Vim LSP
nnoremap <leader>hh :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>k :lua vim.diagnostic.open_float()<CR>
nnoremap <leader>d :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>D :lua vim.lsp.buf.references()<CR>

" Completions
set complete-=t " don't include tags in searching for completions
set updatetime=150
set signcolumn=yes

if has('mac')
    " Xcodebuild
    lua require("xcodebuild").setup {}
    nnoremap <leader>e :Telescope quickfix<CR><Esc>
    nnoremap <leader>r :Simo<CR> :XcodebuildBuildRun<CR>
    command! Simo execute 'cd ~/Documents/Check24/ios-pod-mobile-sim/Example/' 
    command! Set :XcodebuildPicker
    command! Lg :XcodebuildOpenLog
    nnoremap Q :XcodebuildCodeActions
    
    " [Ticket] Take branch name as ticket number and put at the start of commit
    command! Tick execute 'keeppatterns normal /branch <CR>f/<Right>veeeyggpI[<Esc>A] '
else
    nnoremap Q :lua vim.lsp.buf.code_action()<CR>
endif
