" Notes
" - To see search count above 100 - :%s///gn

" TODO
" - Disable FUCKING STUPID word wrapping (repro: when typing a long comment, it will auto break at 100th)
" - vim-bufferline - show number of buffer in the visible list (not id of buffer)

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
    autocmd FileType swift abbrev infii .frame(maxWidth: .infinity, alignment: .leading)
  augroup END
endif
 
call plug#begin('~/.local/share/nvim/plugged')

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } 
Plug 'junegunn/fzf.vim'

if has('mac') " Xcode stuff 
" Plug 'mfussenegger/nvim-dap' " Debug adapter protocol
" Plug 'nvim-neotest/nvim-nio' " dependency of DAP
" Plug 'rcarriga/nvim-dap-ui' " Dap UI
Plug 'wojciech-kulik/xcodebuild.nvim' " Xcode tools
Plug 'MunifTanjim/nui.nvim' " needed for xcodebuild
Plug 'nvim-telescope/telescope.nvim' " needed for xcodebuild
Plug 'nvim-lua/plenary.nvim' " Needed for telescope
Plug 'mfussenegger/nvim-lint'
endif

" Syntax highlighting
Plug 'keith/swift.vim' " Swift support
Plug 'jansedivy/jai.vim' " Jai support

Plug 'preservim/nerdtree' | " File browser
    \ Plug 'Xuyuanp/nerdtree-git-plugin' " Plugin with git status

" Plug 'neovim/nvim-lspconfig' " Lsp
Plug 'tpope/vim-fugitive' " Git
Plug 'airblade/vim-gitgutter' " More Git
Plug 'bling/vim-bufferline' " Show all open buffers
Plug 'kshenoy/vim-signature' " Show marks
Plug 'itchyny/lightline.vim' " Status line
Plug 'mhinz/vim-startify' " Startup screen
Plug 'tpope/vim-commentary' " Comment lines of code
call plug#end()

" Setup fzf
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'
let g:fzf_history_dir = '~/.local/share/fzf-history'
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction
let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:bufferline_echo = 1
let g:bufferline_inactive_highlight = 'StatusLineNC'
let g:bufferline_solo_highlight = 0

" Status line setup
set noshowmode
let g:lightline = { 'colorscheme': 'one', 
      \   'active': {
      \     'left': [[ 'mode', 'paste' ],
      \              [ 'gitbranch', 'readonly', 'filename', 'modified' ]],
      \     'right': [[ 'lineinfo' ],
      \              [ 'fileencoding', 'filetype', 'charvaluehex' ]]
      \   },
      \   'component_function': {
      \     'gitbranch': 'FugitiveHead'
      \   },
      \ }

" LSP
lua require("lspconfig").rust_analyzer.setup {}
lua require("lspconfig").ols.setup {}
lua require("lspconfig").clangd.setup {}
lua require("lspconfig").sourcekit.setup {}

if has('mac')
    " lua require("xcodebuild.integrations.dap").setup("/Users/iaroslav.erokhin/Documents/Other/codelldb-x86_64-darwin/extension/adapter")
    " lua require("dapui").setup()
    lua require("xcodebuild").setup({ auto_save= false })
    lua require('lint').linters_by_ft = { swift = {'swiftlint'} }
    au BufWritePost * lua require('lint').try_lint()
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

" weird auto-text wrapping to new line, this is horrible

if has('mac')
    set colorcolumn=120
    if system('defaults read -g AppleInterfaceStyle') == "Dark\n"
        set background=dark
    else
        set background=light
    endif
else
    set background=dark
endif

noremap <C-S-Right> :set background=light<CR><C-l>
noremap <C-S-Left> :set background=dark<CR><C-l>
autocmd OptionSet background call yaroscheme#apply()

" Copy paste with system buffer
noremap p "+p
noremap P "+P
noremap y "+y
noremap Y "+Y

" Visuals
" On linux I use terminal, so font is set by that
" Ligatures are also not supported, so whatever
if has('mac')
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

function! SwitchToBuffer(n)
  let buffers = getbufinfo({'buflisted': 1})
  if a:n <= len(buffers)
    execute 'buffer' buffers[a:n - 1].bufnr
  endif
endfunction

nnoremap <leader>1 :call SwitchToBuffer(1)<CR>
nnoremap <leader>2 :call SwitchToBuffer(2)<CR>
nnoremap <leader>3 :call SwitchToBuffer(3)<CR>
nnoremap <leader>4 :call SwitchToBuffer(4)<CR>
nnoremap <leader>5 :call SwitchToBuffer(5)<CR>
nnoremap <leader>6 :call SwitchToBuffer(6)<CR>
nnoremap <leader>7 :call SwitchToBuffer(7)<CR>

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

set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,*.min.*
let NERDTreeRespectWildIgnore=1

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

nnoremap <C-t> :NERDTreeFind<CR>
nnoremap <leader><C-f> :NERDTreeVCS<CR>
nnoremap <C-f> :NERDTreeToggle<CR>

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
    nnoremap <C-S-down> :e ~/Documents/Text/os-todos.txt<CR>
    nnoremap <C-S-up> :e ~/Documents/GitHub/vimrc/.vimrc<CR>
    nnoremap <C-]> :Files ~/Documents/<CR>
    nnoremap <leader><C-]> :Files ~/<CR>
    nnoremap <C-p> :AgIn ~/Documents/<CR>
endif

" TODO: use current git repo root for <leader>p

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
nnoremap <silent> <leader>/ /fake-search-query<CR>
nnoremap <C-l> :noh<CR><C-l>
nnoremap <C-h> :History<CR>
nnoremap <leader>n :cn<CR>
nnoremap <C-b> :make<CR>

if has('mac')
    nnoremap <leader>l :XcodebuildCloseLogs<CR> :ccl<CR>
    command! Setup :XcodebuildSetup
    command! Worklog execute 'cd ' . expand('%:p:h') . ' | !git add . && git commit -m "-"'
else
endif

" Vim LSP
nnoremap <leader>l :ccl<CR>
nnoremap <leader>e :copen<CR>
nnoremap <leader>hh :lua vim.lsp.buf.hover()<CR>
nnoremap [g :lua goto_error_then_hint(vim.diagnostic.goto_prev)<CR>
nnoremap ]g :lua goto_error_then_hint(vim.diagnostic.goto_next)<CR>
nnoremap <leader>o :lua vim.diagnostic.open_float()<CR>
nnoremap <leader>d :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>D :lua vim.lsp.buf.references()<CR>

command! Here execute 'cd %:p:h'
command! Mess execute "put =execute('messages')"

lua << EOF
function goto_error_then_hint(goto_func)
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.diagnostic.goto_next( {severity=vim.diagnostic.severity.ERROR, wrap = true} )
  local pos2 = vim.api.nvim_win_get_cursor(0)
  local r1, c1 = unpack(pos)
  local r2, c2 = unpack(pos2)
  local condition = r1 == r2 and c1 == c2
  if (condition) then
    goto_func( {wrap = true} )
  end
end
EOF

lua << EOF
function BreakArguments()
  local line = vim.api.nvim_get_current_line()
  local new_lines = {}
  local current_line = ""
  local inside_parens = false

  for i = 1, #line do
    local char = line:sub(i, i)

    if char == "(" and not inside_parens then
      current_line = current_line .. char
      table.insert(new_lines, current_line)
      current_line = ""
      inside_parens = true
    elseif char == "," and inside_parens then
      current_line = current_line .. char
      table.insert(new_lines, current_line)
      current_line = ""
    elseif char == ")" and inside_parens then
      table.insert(new_lines, current_line)
      current_line = char
      inside_parens = false
    else
      current_line = current_line .. char
    end
  end

  table.insert(new_lines, current_line) -- add the last part
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, new_lines) -- replace current line with new lines
  vim.cmd("normal! V%=") -- auto-format
end
EOF
nnoremap <leader>M :lua BreakArguments()<CR>


if has('mac')
    nnoremap <leader>r :w<CR> :Simo<CR> :XcodebuildBuildRun<CR>
    nnoremap Q :XcodebuildCodeActions<CR>

    command! Simo execute 'cd ~/Documents/Check24/ios-pod-mobile-sim/Example/' 
    command! Set :XcodebuildPicker
    command! Lg :XcodebuildOpenLog
    
    " [Ticket] Take branch name as ticket number and put at the start of commit
    command! Tick execute 'keeppatterns normal /branch <CR>f/<Right>veeeyggpI[<Esc>A] '
else
    nnoremap Q :lua vim.lsp.buf.code_action()<CR>
endif

colorscheme yaroscheme
call yaroscheme#apply()
