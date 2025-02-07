" Notes
" - To see search count above 100 - :%s///gn

" TODO
" - Disable FUCKING STUPID word wrapping (repro: when typing a long comment, it will auto break at 100th)
" - vim-bufferline - show number of buffer in the visible list (not id of buffer)
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
    Plug 'mfussenegger/nvim-dap' " Debug adapter protocol
    " Plug 'nvim-neotest/nvim-nio' " dependency of DAP
    " Plug 'rcarriga/nvim-dap-ui' " Dap UI
    Plug 'wojciech-kulik/xcodebuild.nvim' " Xcode tools
    Plug 'MunifTanjim/nui.nvim' " needed for xcodebuild
    Plug 'nvim-telescope/telescope.nvim' " needed for xcodebuild
    Plug 'nvim-lua/plenary.nvim' " Needed for telescope
    Plug 'mfussenegger/nvim-lint'
else 
    Plug 'neovim/nvim-lspconfig' " Lsp
endif

" Syntax highlighting
Plug 'keith/swift.vim' " Swift support
Plug 'jansedivy/jai.vim' " Jai support

Plug 'preservim/nerdtree' | " File browser
    \ Plug 'Xuyuanp/nerdtree-git-plugin' " Plugin with git status

Plug 'tpope/vim-fugitive' " Git
Plug 'bkad/CamelCaseMotion' " Jump to camel case words
Plug 'airblade/vim-gitgutter' " More Git
Plug 'bling/vim-bufferline' " Show all open buffers
Plug 'kshenoy/vim-signature' " Show marks
Plug 'itchyny/lightline.vim' " Status line
Plug 'mhinz/vim-startify' " Startup screen
Plug 'tpope/vim-commentary' " Comment lines of code
" Plug 'MysticalDevil/inlay-hints.nvim' " Inlay hints (function argument names)
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

if has('mac')
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

" Search and replace in git root
function! s:Replace(...) abort
  if a:0 < 2
    echoerr "Usage: :Replace <pattern> <replacement>"
    return
  endif
  let l:pattern = a:1
  let l:replacement = a:2
  let l:gitroot = trim(system('git rev-parse --show-toplevel'))
  let l:cmd = 'grep -rl ' . shellescape(l:pattern) . ' ' . shellescape(l:gitroot)
        \ . ' | xargs sed -i "s/' . l:pattern . '/' . l:replacement . '/g"'
  call system(l:cmd)
endfunction
command! -nargs=+ Replace call s:Replace(<f-args>)

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

syntax on
set ruler
set rnu
set number 
set autowrite
set wildignorecase
set scroll=15

" Comment style
autocmd FileType c,cpp,h setlocal commentstring=//\ %s

" Search&Replace in the file
vnoremap ts "hy:%s/\V<C-R>=escape(@h, '\/')<CR>//gcI<Left><Left><Left><Left>

" Navigation
let mapleader = " "
nnoremap n nzzzv
nnoremap N Nzzzv
set switchbuf+=useopen

" camel case navigation
map <silent> ,w <Plug>CamelCaseMotion_w
map <silent> ,b <Plug>CamelCaseMotion_b
map <silent> ,e <Plug>CamelCaseMotion_e
map <silent> ,ge <Plug>CamelCaseMotion_ge
" sunmap w
" sunmap b
" sunmap e
" sunmap ge

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
nnoremap <leader>q :bp<CR>:bd #<CR>
nnoremap <leader>w <C-w>c

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

" Show list of branches / remote branches (if inside git file, then close it first)
autocmd FileType git nnoremap <buffer> gb :bd<CR> :Git branch<CR>
nnoremap gb :Git branch<CR>
autocmd FileType git nnoremap <buffer> grb :bd<CR> :Git branch -r<CR>
nnoremap grb :Git branch -r<CR>

" Pull and merge
autocmd FileType git nnoremap <buffer> gm 0w"hy$:exe 'Git merge ' . @h<CR>
autocmd FileType git nnoremap <buffer> gp :Git pull<CR>
autocmd FileType fugitive nnoremap <buffer> gl :Git log<CR>
autocmd FileType fugitive nnoremap <buffer> gp :Git pull<CR>
autocmd FileType fugitive nnoremap <buffer> gP :Git push<CR>

" Checkout commit
autocmd FileType git nnoremap <buffer> gc :call GitCheckoutFromBranchesView()<CR>
autocmd FileType git nnoremap <buffer> grc :call GitCheckoutNewRemoteFromBranchesView()<CR>

function! GitCheckoutFromBranchesView()
  normal! 0w"hy$
  let l:branch = @h
  execute 'Git checkout ' . l:branch
  execute 'bd'
  execute 'Git branch'
  redraw!
endfunction

function! GitCheckoutNewRemoteFromBranchesView()
    normal! 0www"hy$
    let l:branch = @h
    execute 'Git checkout -b ' . l:branch . ' origin/' . l:branch
    execute 'bd'
    execute 'Git branch'
    redraw!
endfunction


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

" Switch letters/words places (put cursor on the left one)
nnoremap <leader>xl "qx"qph
nnoremap <leader>xw viw"qdxea <Esc>"qpbb
nnoremap <leader>xe viw"qywwPlve"qdbbbviwpb

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
nnoremap <C-S-up> :e ~/Documents/GitHub/vimrc/.vimrc<CR>
nnoremap <leader><Down> :e ~/Documents/GitHub/Notes/Notes.txt<CR>

if has('mac')
    nnoremap <C-S-down> :e ~/Documents/Check24/check24-worklog/worklog.txt<CR>

    nnoremap <C-]> :Files ~/Documents/Check24/ios-pod-mobile-sim<CR>
    nnoremap <C-p> :AgIn ~/Documents/Check24/ios-pod-mobile-sim<CR>
    nnoremap <leader><C-]> :Files ~/Documents<CR>
    nnoremap <leader><C-p> :AgIn ~/Documents<CR>
elseif has('linux')
    nnoremap <C-S-down> :e ~/Documents/Text/os-todos.txt<CR>
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
nnoremap <C-l> :noh<CR><C-l>
nnoremap <leader>n :cn<CR>
nnoremap <C-b> :Gcd<CR> :make<CR>

" Reset search
nnoremap <silent> <leader>/ /fake-search-query<CR><C-l>
autocmd FileType vim nnoremap <buffer> <silent> <leader>/ :noh<CR><C-l>

if has('mac')
    nnoremap <leader>l :XcodebuildCloseLogs<CR> :ccl<CR>
    command! Cancel :XcodebuildCancel
else
endif

" Vim LSP
nnoremap <leader>l :ccl<CR>
nnoremap <leader>e :copen<CR>
nnoremap <leader>h :lua vim.lsp.buf.hover()<CR>
nnoremap [g :lua goto_error_then_hint(vim.diagnostic.goto_prev)<CR>
nnoremap ]g :lua goto_error_then_hint(vim.diagnostic.goto_next)<CR>
nnoremap <leader>o :lua vim.diagnostic.open_float()<CR>
nnoremap <leader>d :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>D :lua vim.lsp.buf.references()<CR>
nnoremap <leader>M :lua BreakArguments()<CR>
nnoremap <leader><C-A> :InlayHintsToggle<CR>

command! Mess execute "put =execute('messages')"

if has('mac')
    nnoremap <leader>r :w<CR> :Simo<CR> :XcodebuildBuildRun<CR>
    nnoremap Q :XcodebuildCodeActions<CR>

    command! Simo execute 'cd ~/Documents/Check24/ios-pod-mobile-sim/Example/' 
    command! Set :XcodebuildPicker
    command! Lg :XcodebuildOpenLog
    
    autocmd FileType gitcommit command! Ticket execute 'keeppatterns normal! /branch <CR>f/<Right>veee"qygg"qpI[<Esc>A] '
    autocmd FileType gitcommit nnoremap T :Ticket<CR>A
else
    nnoremap Q :lua vim.lsp.buf.code_action()<CR>
endif

colorscheme yaroscheme
call yaroscheme#apply()
set title 

lua << EOF

-- LSP
require("lspconfig").rust_analyzer.setup {}
require("lspconfig").ols.setup {}

require("lspconfig").sourcekit.setup { 
    filetypes = { "swift" }    
}

require("lspconfig").clangd.setup({
--   settings = {
--     clangd = {
--       InlayHints = {
--         Designators = true,
--         Enabled = true,
--         ParameterNames = true,
--         DeducedTypes = true,
--       },
--       fallbackFlags = { "-std=c++20" },
--     },
--   }
})

-- require("inlay-hints").setup({
--     commands = { enable = true },
--     autocmd = { enable = false } -- disabled by default
-- })

function goto_error_then_hint(goto_func)
  local pos = vim.api.nvim_win_get_cursor(0)
  goto_func( {severity=vim.diagnostic.severity.ERROR, wrap = true} )
  local pos2 = vim.api.nvim_win_get_cursor(0)
  local r1, c1 = unpack(pos)
  local r2, c2 = unpack(pos2)
  local condition = r1 == r2 and c1 == c2
  if (condition) then
    goto_func( {wrap = true} )
  end
end

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
