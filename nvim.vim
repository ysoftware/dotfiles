" TODO
" - Disable FUCKING STUPID word wrapping (repro: when typing a long comment, it will auto break at 100th)
" - Make :Files respect .ignore

" TODO: add .gitconfig to dotfiles

" PLUGINS
call plug#begin('~/.local/share/nvim/plugged')
Plug 'mg979/vim-visual-multi'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'tpope/vim-fugitive' " Git
Plug 'bkad/CamelCaseMotion' " Jump to camel case words
Plug 'airblade/vim-gitgutter' " More Git
Plug 'ysoftware/vim-bufferline' " Show all open buffers
Plug 'kshenoy/vim-signature' " Show marks
Plug 'mhinz/vim-startify' " Startup screen
Plug 'tpope/vim-commentary' " Comment lines of code

Plug 'rluba/jai.vim'
Plug 'neovim/nvim-lspconfig' " Lsp
Plug 'norcalli/nvim-colorizer.lua' " Hex Colors
Plug 'preservim/nerdtree' | " File browser
    \ Plug 'Xuyuanp/nerdtree-git-plugin' " Plugin with git status

Plug 'nvim-lua/plenary.nvim' " Needed for telescope
Plug 'nvim-telescope/telescope.nvim' " needed for search
Plug 'nvim-telescope/telescope-live-grep-args.nvim' " additional tool for search
" telescope with better sorting
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

if has('mac') " Xcode stuff
    Plug 'wojciech-kulik/xcodebuild.nvim' " Xcode tools
    Plug 'MunifTanjim/nui.nvim' " needed for xcodebuild
    Plug 'mfussenegger/nvim-lint'
    Plug 'angular/vscode-ng-language-service' " Angular support
    Plug 'keith/swift.vim' " Swift support
endif
call plug#end()

let mapleader = " "
:set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

" Multiline
let g:VM_mouse_mappings = 1

" Buffers
command! Bufo silent! execute "%bd|e#|bd#"
nnoremap <C-W>. :vertical res +10<CR>
nnoremap <C-W>, :vertical res -10<CR>
nnoremap <C-W>> :res +20<CR>
nnoremap <C-W>< :res -20<CR>
command! CountMatches execute "%s///gn"
command! W :w

" Auto fold imports
command! FoldPhpImport silent! normal! zEG$/^use <CR>VGNzf/fake-search-query<CR>gg<C-l>
command! FoldTsImport silent! normal! zEG$/^import <CR>VGNzf/fake-search-query<CR>gg<C-l>

" Code formatting
autocmd FileType c,cpp,h setlocal commentstring=//\ %s
autocmd FileType typescript,html,scss,css,javascript setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab

augroup twig_ft
  au!
  autocmd BufNewFile,BufRead *.html.twig   set syntax=html
augroup END

" Snippets
augroup SwiftSnippets
    autocmd!
    autocmd FileType swift abbrev wink .sink { [weak self] in<CR><CR>}<CR>.store(in: &subscribers)<Up><Up><Up><Left><Left><Left>
    autocmd FileType swift abbrev ws [weak self] in<Left><Left><Left>
    autocmd FileType swift abbrev gl guard let self else { return }
    autocmd FileType swift abbrev si .store(in: &subscribers)
    autocmd FileType swift abbrev infii .frame(maxWidth: .infinity, alignment: .leading)
augroup END

augroup PhpSnippets
    autocmd!
    autocmd FileType php abbrev fwr fwrite(STDOUT, var_export(, true));<Left><Left><Left><Left><Left><Left><Left><Left><Left>
    autocmd FileType php abbrev stackTrace catch (Throwable $e) { fwrite(STDOUT, " \n \n".$e->getMessage()."\n \n".$e->getTraceAsString()); }
augroup END

augroup AllSnippets
    autocmd!
    autocmd FileType typescript,javascript abbrev cons console.info(); // nocheckin<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
augroup END

" Status line setup
let g:bufferline_echo = 1
let g:bufferline_modified = ''
let g:bufferline_show_bufnr = 0
let g:bufferline_show_bufpos = 1
let g:bufferline_inactive_highlight = 'StatusLineNC'
let g:bufferline_active_highlight = 'Search'
let g:bufferline_active_buffer_left = ''
let g:bufferline_active_buffer_right = ''
let g:bufferline_solo_highlight = 0
let g:bufferline_rotate = 2
let g:bufferline_custom_pattern_indicator = [
  \ ['*/angular/*/mobile/*',  'BufferLineType1'],
  \ ['*/angular/*/desktop/*', 'BufferLineType2'],
  \ ['*/frontend-client/*/mobile/*',  'BufferLineType3'],
  \ ['*/frontend-client/*/desktop/*', 'BufferLineType4'],
  \ ]

" Start page
let g:startify_custom_header = ['   neovim']

if has('mac')
    au BufWritePost * lua require('lint').try_lint()
endif

function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
endfunction

" Setup Plugin Manager
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Nerd tree
let NERDTreeShowHidden=1
let NERDTreeCustomOpenArgs={'file':{'keepopen': '0'}}
let g:NERDTreeWinSize=60

set wildignore+=*.pyc,*.svn,*.swp,*.hg,*.DS_Store
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

augroup NerdTreeTabWidth
  autocmd!
  autocmd FileType nerdtree setlocal tabstop=1 shiftwidth=1 softtabstop=1 noexpandtab
  autocmd VimEnter * if &filetype ==# 'nerdtree' | setlocal tabstop=1 shiftwidth=1 softtabstop=1 noexpandtab | endif
augroup END

nnoremap <C-t> :NERDTreeFind<CR>
nnoremap <leader><C-f> :NERDTreeVCS<CR>
nnoremap <C-f> :NERDTreeToggle<CR>
autocmd FileType nerdtree nnoremap <buffer> <leader>q <C-w>c

" Prettify json (depends on installed jq)
augroup PrettifyJson
  autocmd!
  autocmd FileType json command! -buffer Prettify %!jq --indent 2 -f %
augroup END

" Prettify html (depends on installed pup)
augroup PrettifyHtml
  autocmd!
  autocmd FileType html,htmljinja,html.twig command! -buffer Prettify %!pup -i 2 -f % html
augroup END

" - SEARCH

" Don't search in folded code
set fdo-=search
set fdo-=jump

" File Search
nnoremap <C-S-up> :e ~/Documents/GitHub/dotfiles/nvim.vim<CR>
nnoremap <leader><Down> :e ~/Documents/GitHub/Notes/Notes.txt<CR>

if has('mac')
    nnoremap <C-S-down> :e ~/Documents/Check24/check24-worklog/worklog.txt<CR>
elseif has('linux')
    nnoremap <C-S-down> :e ~/Documents/Text/os-todos.txt<CR>
endif

noremap <C-S-Right> :set background=light<CR><CR><C-l>
noremap <C-S-Left> :set background=dark<CR><C-l>
autocmd OptionSet background call yaroscheme#apply()

set ic " case insensitive search
set gdefault
let g:searchindex_line_limit=2000000
nnoremap <silent> <C-l> :noh<CR><C-l>
nnoremap <leader>n :cn<CR>
nnoremap <C-b> :make<CR>

" Reset search
nnoremap <silent> <leader>/ /fake-search-query<CR><C-l>
autocmd FileType vim nnoremap <buffer> <silent> <leader>/ :noh<CR><C-l>

if has('mac')
    nnoremap <leader>l :XcodebuildCloseLogs<CR> :ccl<CR>
    command! Cancel :XcodebuildCancel
else
endif

if has('mac')
    nnoremap <leader>r :w<CR> :Simo<CR> :XcodebuildBuildRun<CR>
    nnoremap <leader>Q :XcodebuildCodeActions<CR>

    command! Simo execute 'cd ~/Documents/Check24/ios-pod-mobile-sim/' 
    command! Set :XcodebuildPicker
    command! Lg :XcodebuildOpenLog
else
endif

set termguicolors
colorscheme yaroscheme
call yaroscheme#apply()
set title

lua << EOF
vim.deprecate = function() end

vim.pack.add({
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/nvim-lualine/lualine.nvim'
})

do -- colorizer plugin
  require'colorizer'.setup()
  vim.api.nvim_create_autocmd('FileType', { pattern = 'diff', callback = function() require'colorizer'.detach_from_buffer(0) end, })
end

do -- status line plugin
  require('lualine').setup {
    options = {
      theme = 'auto',
      disabled_filetypes = { statusline = { 'TelescopePrompt' }}, icons_enabled = false,
      section_separators = { left = '', right = '' }, component_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'FugitiveHead', 'readonly', 'modified' },
      lualine_c = {},
      lualine_x = { 'fileencoding', 'filetype', '%B' },
      lualine_y = { 'location' },
      lualine_z = {},
    },
  }
end

do -- basic settings ------------------------------------------------

  -- show invisible characters
  vim.opt.listchars = { tab = '»-', trail = '·', nbsp = '␣', extends = '>', precedes = '<' }
  vim.opt.list = true

end -- basic settings -----------------------------------------------

do -- basic mapping

  -- Search&Replace in the file
  vim.keymap.set('v', 'ts', '"hy:%s/\\V<C-R>=escape(@h, \'\\/\')<CR>//cI<Left><Left><Left><Left>')

end -- basic mapping

do -- search for files / in files -----------------------------------
  local telescope = require('telescope')
  local telescope_config = require('telescope.config')
  local actions = require('telescope.actions')
  local action_set = require('telescope.actions.set')
  local action_state = require('telescope.actions.state')

  local function scroll_results(direction)
    return function(prompt_bufnr)
      local status = require('telescope.state').get_status(prompt_bufnr)
      local height = vim.api.nvim_win_get_height(status.results_win)
      action_set.shift_selection(prompt_bufnr, direction * math.floor(height / 2))
    end
  end

  -- Smart directory search: git root -> current dir -> ~/Documents fallback with special buffer handling
  local function get_search_directory()
    local current_file = vim.fn.expand('%:p:h')
    local buftype = vim.bo.buftype
    local filetype = vim.bo.filetype
  
    if buftype ~= '' or filetype == 'fugitive' or filetype == 'git' or current_file:match('^fugitive://') then
      current_file = vim.fn.getcwd()
    elseif current_file == '' or not vim.fn.isdirectory(current_file) then
      current_file = vim.fn.getcwd()
    end

    local git_root = vim.fn.system('git -C ' .. vim.fn.shellescape(current_file) .. ' rev-parse --show-toplevel 2>/dev/null')

    if vim.v.shell_error == 0 and git_root ~= '' then
      local clean_root = vim.fn.substitute(git_root, '\n', '', '')
      if vim.fn.isdirectory(clean_root) == 1 then
        return clean_root
      end
    end
  
    if vim.fn.isdirectory(current_file) == 1 then
      return current_file
    else
      return vim.fn.expand('~/Documents')
    end
  end

  -- highlight mobile/desktop
  local function highlight_entry(entry_maker, patterns)
    return function(entry)
      local made = entry_maker(entry)
      if not made then return nil end
      local original_display = made.display
      made.display = function(e)
        local str, highlights = original_display(e)
        highlights = highlights or {}
        for _, p in ipairs(patterns) do
          if e.value and e.value:match(p.pattern) then
            table.insert(highlights, { { 0, #str }, p.hl_group })
            break
          end
        end
        return str, highlights
      end
      return made
    end
  end
  local entry_patterns = {
    { pattern = '/mobile/',  hl_group = 'BufferLineType1' },
    { pattern = '/desktop/', hl_group = 'BufferLineType2' },
  }

  local lga_actions = require("telescope-live-grep-args.actions")
  telescope.setup({
    defaults = {
      layout_strategy = 'vertical', layout_config = { vertical = { width = 0.99, height = 0.99, prompt_position = 'top', preview_height = 0.15, }},
      scroll_strategy = 'limit', sorting_strategy = 'ascending',
      mappings = {
          i = {
            ['<Esc>'] = actions.close, ['<C-j>'] = actions.move_selection_next, ['<C-k>'] = actions.move_selection_previous,
            ['<C-a>'] = actions.select_all, ['<C-o>'] = actions.send_selected_to_qflist + actions.open_qflist, ['<C-b>'] = actions.toggle_selection,
            ['<C-d>'] = scroll_results(1), ['<C-u>'] = scroll_results(-1),
            ['<C-e>'] = actions.preview_scrolling_down, ['<C-y>'] = actions.preview_scrolling_up,
            ['<C-]>'] = actions.cycle_history_next, ['<C-p>'] = actions.cycle_history_prev,
            ['<C-h>'] = actions.results_scrolling_left, ['<C-l>'] = actions.results_scrolling_right,
          },
      },
      preview = { hide_on_startup = false },
      vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' },
      history = { path = vim.fn.stdpath('data') .. '/telescope_history', limit = 100, },
      generic_sorter = require('telescope').extensions.fzf.native_fzf_sorter, file_sorter = require('telescope').extensions.fzf.native_fzf_sorter,
    },
    pickers = {
      find_files = {
        find_command = { 'rg', '--files', '--smart-case' },
        entry_maker = highlight_entry(require('telescope.make_entry').gen_from_file(), entry_patterns),
      },
    },
    extensions = {
      live_grep_args = {
        auto_quoting = true,
        mappings = {
          i = {
            ["<C-q>"] = lga_actions.quote_prompt(),
            ["<C-f>"] = actions.to_fuzzy_refine,
          },
        },
      },
    }
  })

  telescope.load_extension('fzf')
  telescope.load_extension('live_grep_args')

  -- vim.opt.laststatus = 3 TODO: this needs to be enabled only for some windows (telescope search)

  local builtin = require('telescope.builtin')

  vim.keymap.set('n', '<C-]>', function() builtin.find_files({ cwd = get_search_directory() }) end, { noremap = true, silent = true })
  vim.keymap.set('n', '<leader><C-]>', function() builtin.find_files({ cwd = '~/Documents' }) end, { noremap = true, silent = true })

  local lga = require('telescope').extensions.live_grep_args
  vim.keymap.set('n', '<C-p>', function()
    lga.live_grep_args({
      cwd = get_search_directory(),
      entry_maker = highlight_entry(
        require('telescope.make_entry').gen_from_vimgrep(),
        entry_patterns
      ),
    })
  end, { noremap = true, silent = true })

  vim.keymap.set('n', '<leader><C-p>', function()
    lga.live_grep_args({
      cwd = '~/Documents',
      entry_maker = highlight_entry(
        require('telescope.make_entry').gen_from_vimgrep(),
        entry_patterns
      ),
    })
  end, { noremap = true, silent = true })
end -- telescope file search

-- Navigation
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.opt.switchbuf:append('useopen')

-- camel case navigation
vim.keymap.set('', ',w', '<Plug>CamelCaseMotion_w', { silent = true, remap = true })
vim.keymap.set('', ',b', '<Plug>CamelCaseMotion_b', { silent = true, remap = true })
vim.keymap.set('', ',e', '<Plug>CamelCaseMotion_e', { silent = true, remap = true })
vim.keymap.set('', ',ge', '<Plug>CamelCaseMotion_ge', { silent = true, remap = true })

function SwitchToBuffer(n)
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  if n <= #buffers then
    vim.cmd('buffer ' .. buffers[n].bufnr)
  end
end

vim.keymap.set('n', '<leader>1', ':lua SwitchToBuffer(1)<CR>', { silent = true })
vim.keymap.set('n', '<leader>2', ':lua SwitchToBuffer(2)<CR>', { silent = true })
vim.keymap.set('n', '<leader>3', ':lua SwitchToBuffer(3)<CR>', { silent = true })
vim.keymap.set('n', '<leader>4', ':lua SwitchToBuffer(4)<CR>', { silent = true })
vim.keymap.set('n', '<leader>5', ':lua SwitchToBuffer(5)<CR>', { silent = true })
vim.keymap.set('n', '<leader>6', ':lua SwitchToBuffer(6)<CR>', { silent = true })
vim.keymap.set('n', '<leader>7', ':lua SwitchToBuffer(7)<CR>', { silent = true })
vim.keymap.set('n', '<leader>8', ':lua SwitchToBuffer(8)<CR>', { silent = true })
vim.keymap.set('n', '<leader>9', ':lua SwitchToBuffer(9)<CR>', { silent = true })
vim.keymap.set('n', '<leader>0', ':lua SwitchToBuffer(10)<CR>', { silent = true })
vim.keymap.set('n', '<leader>-', ':lua SwitchToBuffer(11)<CR>', { silent = true })

function GitCheckoutFromBranchesView()
  vim.cmd('normal! 0w"hy$')
  local branch = vim.fn.getreg('h')
  vim.cmd('Git checkout ' .. branch)
  vim.cmd('bd')
  vim.cmd('Git branch')
  vim.cmd('redraw!')
end

function GitCheckoutNewRemoteFromBranchesView()
  vim.cmd('normal! 0www"hy$')
  local branch = vim.fn.getreg('h')
  vim.cmd('Git checkout -b ' .. branch .. ' origin/' .. branch)
  vim.cmd('bd')
  vim.cmd('Git branch')
  vim.cmd('redraw!')
end

-- Highlight merge conflicted blocks
local merge_conflict_group = vim.api.nvim_create_augroup('MergeConflictHighlight', { clear = true })

local function setup_merge_conflict_highlight()
  vim.cmd([[syn region ConflictMarkerOurs start=/^<<<<<<< .*$/ end=/^\ze\(=======$\||||||||\)/]])
  vim.cmd([[syn region ConflictMarkerSeparator start=/^||||||| .*$/ end=/^\ze=======$/]])
  vim.cmd([[syn region ConflictMarkerTheirs start=/^\(=======$\||||||| |\)/ end=/^>>>>>>> .*$/]])
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  group = merge_conflict_group,
  pattern = '*',
  callback = setup_merge_conflict_highlight,
})

-- Funny command to quit insert mode without escape
vim.keymap.set('i', 'jk', '<Esc>:cd %:p:h<CR>', { remap = true })

-- Tab lines
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Tabs and shit
vim.cmd('filetype plugin indent on')
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.showmode = false

-- copy paste with system buffer
vim.keymap.set('', 'p', '"+p')
vim.keymap.set('', 'P', '"+P')
vim.keymap.set('', 'y', '"+y')
vim.keymap.set('', 'Y', '"+Y')
vim.opt.clipboard = ''

-- Move lines
vim.keymap.set('n', '<S-down>', ':m .+1<CR>==')
vim.keymap.set('n', '<S-up>', ':m .-2<CR>==')
vim.keymap.set('i', '<S-down>', '<Esc>:m .+1<CR>==gi')
vim.keymap.set('i', '<S-up>', '<Esc>:m .-2<CR>==gi')
vim.keymap.set('v', '<S-down>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<S-up>', ":m '<-2<CR>gv=gv")

-- Switch letters/words places (put cursor on the left one)
vim.keymap.set('n', '<leader>xl', '"qx"qph')
vim.keymap.set('n', '<leader>xw', 'viw"qdxea <Esc>"qpbb')
vim.keymap.set('n', '<leader>xe', 'viw"qywwPlve"qdbbbviwpb')

-- Tabs
vim.keymap.set('n', 'tg', 'gT')
vim.keymap.set('n', "<leader>'", ':tabnew<CR>')
vim.keymap.set('n', '<leader>q', ':bp<CR>:bd #<CR>')
vim.keymap.set('n', '<leader>w', '<C-w>c')

-- Brackets around selection
vim.keymap.set('x', '<leader>[', '<Esc>a]<Esc>gv`<<Esc>i[<Esc>')
vim.keymap.set('x', '<leader>(', '<Esc>a)<Esc>gv`<<Esc>i(<Esc>')
vim.keymap.set('x', '<leader>{', '<Esc>a}<Esc>gv`<<Esc>i{<Esc>')

-- Jump to next empty line
vim.keymap.set('', '}', function() vim.fn.search('^\\s*$\\|\\%$', 'W') end)
vim.keymap.set('', '{', function() vim.fn.search('^\\s*$\\|\\%^', 'Wb') end)

-- Jump to next git change
vim.keymap.set('n', ']h', '<Plug>(GitGutterNextHunk)zz')
vim.keymap.set('n', '[h', '<Plug>(GitGutterPrevHunk)zz')

-- Uppercase / lowercase one letter
vim.keymap.set('n', '<leader>u', 'vu')
vim.keymap.set('n', '<leader>U', 'vU')
vim.keymap.set('n', '<leader>g', ':vertical:G<CR>')

vim.api.nvim_create_user_command('Diff', 'GitGutterDiff', {})

-- Show list of branches / remote branches (if inside git file, then close it first)
vim.keymap.set('n', 'gb', ':Git branch<CR>')
vim.keymap.set('n', 'grb', ':Git branch -r<CR>')

vim.api.nvim_create_autocmd('FileType', { pattern = 'git', callback = function(a) vim.keymap.set('n', 'gb', ':bd<CR>:Git branch<CR>', { buffer = a.buf }) end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'git', callback = function(a) vim.keymap.set('n', 'grb', ':bd<CR>:Git branch -r<CR>', { buffer = a.buf }) end })

-- Checkout commit
vim.api.nvim_create_autocmd('FileType', { pattern = 'git', callback = function(a) vim.keymap.set('n', 'gc', ':lua GitCheckoutFromBranchesView()<CR>', { buffer = a.buf }) end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'git', callback = function(a) vim.keymap.set('n', 'grc', ':lua GitCheckoutNewRemoteFromBranchesView()<CR>', { buffer = a.buf }) end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'git', callback = function(a) vim.keymap.set('n', 'gd', ':GitDelete<CR>', { buffer = a.buf }) end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'git', callback = function(a) vim.keymap.set('n', 'gj', ':JiraOpen<CR>', { buffer = a.buf }) end })

-- Fetch, Pull, Merge, Log
vim.api.nvim_create_autocmd('FileType', { pattern = 'git', callback = function(a) vim.keymap.set('n', 'gm', '0w"hy$:exe \'Git merge \' . @h<CR>', { buffer = a.buf }) end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'git', callback = function(a) vim.keymap.set('n', 'gp', ':Git pull<CR>', { buffer = a.buf }) end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'fugitive', callback = function(a) vim.keymap.set('n', 'gp', ':Git pull<CR>', { buffer = a.buf }) end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'fugitive', callback = function(a) vim.keymap.set('n', 'gP', ':Git push<CR>', { buffer = a.buf }) end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'fugitive', callback = function(a) vim.keymap.set('n', 'gFP', ':Git push --force', { buffer = a.buf }) end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'fugitive', callback = function(a) vim.keymap.set('n', 'grp', ':Git fetch<CR>', { buffer = a.buf }) end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'fugitive', callback = function(a) vim.keymap.set('n', 'gl', ':Git log -500 --decorate<CR>', { buffer = a.buf }) end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'fugitive', callback = function(a) vim.keymap.set('n', 'cn', ':Git commit --no-verify<CR>', { buffer = a.buf }) end })

-- q to quit some buffers
vim.api.nvim_create_autocmd('FileType', { pattern = 'fugitive', callback = function(a) vim.keymap.set('n', 'q', '<C-w>c', { buffer = a.buf }) end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'fugitiveblame', callback = function(a) vim.keymap.set('n', 'q', '<C-w>c', { buffer = a.buf }) end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'git', callback = function(a) vim.keymap.set('n', 'q', '<C-w>c', { buffer = a.buf }) end })
vim.api.nvim_create_autocmd('FileType', { pattern = 'qf', callback = function(a) vim.keymap.set('n', 'q', '<C-w>c', { buffer = a.buf }) end })

-- basic settings
vim.cmd('syntax on')
vim.opt.path:append('**')
vim.opt.ruler = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.autowrite = true
vim.opt.wildignorecase = true
vim.opt.scroll = 15
vim.opt.scrolloff = 3

-- this might not be needed in nvim, but I added it for some reason
vim.cmd('set nocompatible')

-- LSP

vim.keymap.set('n', '<leader>l', '<cmd>ccl<CR>', { silent = true })

vim.keymap.set('n', '<leader>e', function()
  vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
  vim.cmd('copen')
end, { silent = true })

vim.keymap.set('n', '<leader>E', function()
  vim.diagnostic.setqflist()
  vim.cmd('copen')
end, { silent = true })

vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, { silent = true })
vim.keymap.set('n', '[g', function() goto_error_then_hint(vim.diagnostic.goto_prev) end, { silent = true })
vim.keymap.set('n', ']g', function() goto_error_then_hint(vim.diagnostic.goto_next) end, { silent = true })
vim.keymap.set('n', '<leader>o', vim.diagnostic.open_float, { silent = true })
vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, { silent = true })
vim.keymap.set('n', '<leader>D', vim.lsp.buf.references, { silent = true })
vim.keymap.set('n', '<leader>M', function() BreakArguments() end, { silent = true })
vim.keymap.set('n', '<leader><C-A>', '<cmd>InlayHintsToggle<CR>', { silent = true })

-- remap go to definition for markdown
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.keymap.set('n', '<leader>d', function()
      local line = vim.api.nvim_get_current_line()
      local col = vim.fn.col('.')

      for start_col, target, end_col in line:gmatch('()%[[^%]]+%]%(([^%)]+)%)()') do
        if col >= start_col and col <= end_col then
          vim.cmd('edit ' .. vim.fn.fnameescape(vim.fn.expand('%:p:h') .. '/' .. target))
          return
        end
      end
    end, { buffer = true, silent = true })
  end,
})

-- fix nerdtree copy path
vim.api.nvim_create_autocmd("FileType", {
    pattern = "nerdtree",
    once = true,
    callback = function()
        vim.cmd([[
function! NERDTreeCopyPath()
    let @+ = g:NERDTreeFileNode.GetSelected().path.str()
    call nerdtree#echo('Copied path to clipboard')
endfunction
]])
    end,
})

vim.api.nvim_create_user_command('Mess', "put =execute('messages')", {})
vim.keymap.set('n', 'Q', vim.lsp.buf.code_action, { silent = true })

-- neovide

if vim.g.neovide then -- ->
    vim.g.neovide_pixel_geometry = "RGBH"
    vim.g.neovide_text_gamma = 0.85

    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_trail_size = 0.2
    vim.g.neovide_cursor_animation_length = 0.02

    vim.g.neovide_position_animation_length = 0.15
    vim.g.neovide_scroll_animation_length = 0.1

    vim.g.neovide_progress_bar_enabled = true
    vim.g.neovide_progress_bar_height = 5.0
    vim.g.neovide_progress_bar_animation_speed = 200.0
    vim.g.neovide_progress_bar_hide_delay = 0.2

    -- remove bold highlights from yarosheme
    for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
      local hl = vim.api.nvim_get_hl(0, { name = group })
      if hl.bold then
        hl.bold = false
        vim.api.nvim_set_hl(0, group, hl)
      end
    end

    -- include path from bash
    local handle = io.popen('/bin/bash -lc \'printf "%s" "$PATH"\'')
    if handle then
      local path = handle:read("*a")
      handle:close()
      if path and path ~= "" then
        vim.env.PATH = path
      end
    end
end

-- stop insert mode of terminal
vim.keymap.set('t', '<C-q>', [[<C-\><C-n>]])

vim.keymap.set('n', '<leader><C-d>', function() vim.cmd('tab split | lua vim.lsp.buf.definition()') end, { noremap = true, silent = true })

local ok, xcodebuild = pcall(require, 'xcodebuild')
if ok and xcodebuild then
    xcodebuild.setup({ auto_save = false })
end

-- linter + downgrade errors to warnings
local ok, lint = pcall(require, 'lint')
if ok and lint then
    lint.linters_by_ft = {
      javascript = { "eslint" },
      typescript = { "eslint" },
      -- swift      = { "swiftlint" },
    }
    lint.linters.eslint = require("lint.util").wrap(lint.linters.eslint, function(diagnostic)
      if diagnostic.source and diagnostic.source:lower() == "eslint" then
        diagnostic.severity = vim.diagnostic.severity.WARN
      end
      return diagnostic
    end)
    lint.linters.swiftlint = require("lint.util").wrap(lint.linters.swiftlint, function(diagnostic)
      if diagnostic.source and diagnostic.source:lower() == "swiftlint" then
        diagnostic.severity = vim.diagnostic.severity.WARN
      end
      return diagnostic
    end)
end

-- php lsp (phpactor - free alternative with code actions)
local phpactor_lsp = require'lspconfig'.phpactor
if phpactor_lsp then
    phpactor_lsp.setup {
        autostart = true,
        capabilities = capabilities,
        cmd = { "phpactor", "language-server" },
        root_dir = function()
            return "/Users/iaroslav.erokhin/Documents/Check24/core-api/"
        end,
        init_options = {
            ["language_server_phpstan.enabled"] = false,
            ["language_server_psalm.enabled"] = false,
        },
        handlers = {
            ["window/showMessage"] = function() end,
        },
    }
end

-- angular lsp
local project_library_path = "~/Documents/Check24/angular/"
local cmd = {"ngserver", "--stdio", "--tsProbeLocations", project_library_path , "--ngProbeLocations", project_library_path}
local tsserver_lsp = require'lspconfig'.tsserver
if tsserver_lsp and tsserver_lsp.setup then
    tsserver_lsp.setup {
        capabilities = capabilities,
        filetypes = { "typescript", "html", "scss", "css", "javascript", "htmlangular" },
        init_options = {
            preferences = {
                importModuleSpecifier = "non-relative",
                importModuleSpecifierPreference = "non-relative",
            },
        },
    }
end

local angularls_lsp = require'lspconfig'.angularls
if angularls_lsp then
    angularls_lsp.setup {
        cmd = cmd,
        capabilities = capabilities,
        filetypes = { "typescript", "html", "scss", "css", "javascript", "htmlangular" },
        on_new_config = function(new_config,new_root_dir)
          new_config.cmd = cmd
        end,
    }
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local lspconfig = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require'lspconfig'.rust_analyzer.setup {
    capabilities = capabilities,
    filetypes = { "rust" }
}

require'lspconfig'.ols.setup {
    capabilities = capabilities,
    filetypes = { "odin" }
}

require'lspconfig'.clangd.setup {
    capabilities = capabilities,
    filetypes = { "c", "h", "cpp", "m" },
    cmd = { "clangd", "--clang-tidy=false" }
}

require'lspconfig'.lua_ls.setup {
    capabilities = capabilities,
    filetypes = { "lua" }
}

local util = require'lspconfig.util'
require'lspconfig'.sourcekit.setup { 
    capabilities = capabilities,
    filetypes = { "swift" },
    root_dir = function(idk)
        return "/Users/iaroslav.erokhin/Documents/Check24/ios-pod-mobile-sim"
    end
}

-- Setup float diagnostic windows behaviour
local function close_lsp_floats_if_not_in_float()
  local curwin = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(curwin).relative ~= '' then
    return
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local ok, win = pcall(vim.api.nvim_buf_get_var, buf, 'lsp_floating_preview')
    if ok and type(win) == 'number' and vim.api.nvim_win_is_valid(win) and win ~= curwin then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
end
vim.api.nvim_create_augroup('CloseLspFloats', { clear = true })
vim.api.nvim_create_autocmd({ 'WinEnter', 'WinScrolled' }, {
  group = 'CloseLspFloats',
  callback = close_lsp_floats_if_not_in_float,
})

-- Code completion
local ELLIPSIS_CHAR = '…'
local MAX_LABEL_WIDTH = 80
local MIN_LABEL_WIDTH = 30

local cmp = require'cmp'
cmp.setup({
  completion = {
    autocomplete = false,
  },
  experimental = {
    ghost_text = false,
  },
  window = {
    completion = {
      winhighlight = "Normal:ColorColumn,CursorLine:Search,Search:None",
      scrollbar = false,
    },
    documentation = {
      col_offset = 1,
      side_padding = 0,
      winhighlight = "Normal:ColorColumn,FloatBorder:ColorColumn",
      max_width = 50,
      max_height = 80,
    },
  },
  formatting = {
    format = function(entry, vim_item)
      local label = vim_item.abbr
      local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
      if truncated_label ~= label then
        vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
      elseif string.len(label) < MIN_LABEL_WIDTH then
        local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
        vim_item.abbr = label .. padding
      end
      return vim_item
    end,
  },
  mapping = {
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'cmdline' },
  },
})

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

-- Function to create and setup a new git branch with different local and remote names
vim.api.nvim_create_user_command('Branch', function()
  local current_branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("%s+", "")
  if current_branch ~= "master" then
    local choice = vim.fn.confirm("You are on '" .. current_branch .. "', not master. Continue?", "&Yes\n&No", 2)
    if choice ~= 1 then
      print("Branch creation cancelled")
      return
    end
  end
  vim.ui.input({ prompt = "Enter ticket number (e.g., TEMOSO-22524): " }, function(ticket)
    if not ticket or ticket == "" then
      print("Branch creation cancelled - no ticket number provided")
      return
    end
    vim.ui.input({ prompt = "Enter extra info for local branch: " }, function(extra_info)
      if not extra_info or extra_info == "" then
        print("Branch creation cancelled - no extra info provided")
        return
      end
      local local_branch = ticket .. "-" .. extra_info
      local remote_branch = ticket
      local commands = {
        "git checkout -b " .. local_branch,
        "git push origin HEAD:" .. remote_branch,
        "git branch --set-upstream-to=origin/" .. remote_branch
      }

      print("\n")
      for i, cmd in ipairs(commands) do
        print("Executing: " .. cmd)
        local result = vim.fn.system(cmd)

        if vim.v.shell_error ~= 0 then
          print("Error executing command: " .. cmd)
          print("Error output: " .. result)
          return
        end
        if i == 1 then
          print("Local branch created: " .. local_branch)
        elseif i == 2 then
          print("Pushed to remote: " .. remote_branch)
        elseif i == 3 then
          print("Upstream tracking set")
        end
      end
      print("Branch setup complete!")
    end)
  end)
end, { })

-- Function to pull a remote branch while specifying a custom name for the local branch
vim.api.nvim_create_user_command('BranchRemote', function()
  local function git(args)
    local result = vim.fn.system(vim.list_extend({ "git" }, args))
    return result, vim.v.shell_error
  end

  local status, status_error = git({ "status", "--porcelain" })
  if status_error ~= 0 then
    print("Error checking git status")
    print("Error output: " .. status)
    return
  end

  if status ~= "" then
    print("Branch checkout cancelled - working tree is not clean")
    print(status)
    return
  end

  vim.ui.input({ prompt = "Enter remote branch name (e.g., TEMOSO-22524): " }, function(remote_branch)
    if not remote_branch or remote_branch == "" then
      print("Branch checkout cancelled - no remote branch provided")
      return
    end

    vim.ui.input({ prompt = "Enter local branch name: ", default = remote_branch }, function(local_branch)
      if not local_branch or local_branch == "" then
        print("Branch checkout cancelled - no local branch provided")
        return
      end

      local _, branch_exists = git({ "show-ref", "--verify", "--quiet", "refs/heads/" .. local_branch })
      if branch_exists == 0 then
        print("Branch checkout cancelled - local branch already exists: " .. local_branch)
        return
      end

      local commands = {
        {
          label = "Fetched remote branch",
          args = { "fetch", "origin", "+refs/heads/" .. remote_branch .. ":refs/remotes/origin/" .. remote_branch }
        },
        {
          label = "Checked out local branch: " .. local_branch,
          args = { "checkout", "-b", local_branch, "origin/" .. remote_branch }
        },
        {
          label = "Upstream tracking set to origin/" .. remote_branch,
          args = { "branch", "--set-upstream-to=origin/" .. remote_branch, local_branch }
        }
      }

      print("\n")
      for _, command in ipairs(commands) do
        print("Executing: git " .. table.concat(command.args, " "))
        local result, error = git(command.args)

        if error ~= 0 then
          print("Error executing command: git " .. table.concat(command.args, " "))
          print("Error output: " .. result)
          return
        end

        print(command.label)
      end

      print("Remote branch checkout complete!")
    end)
  end)
end, { })

-- Jump between mobile and desktop files of the same name
vim.api.nvim_create_user_command('WebJump', function()
  local current_file = vim.fn.expand('%:p')
  if current_file == '' then
    return
  end
  local filename = vim.fn.expand('%:t')
  local base_path = nil
  local target_platform = nil
  if current_file:find('/mobile/') then
    base_path = current_file:match('(.*)/mobile/')
    target_platform = 'desktop'
  elseif current_file:find('/desktop/') then
    base_path = current_file:match('(.*)/desktop/')
    target_platform = 'mobile'
  else
    return
  end
  local search_pattern = base_path .. '/' .. target_platform .. '/**/' .. filename
  local matches = vim.fn.glob(search_pattern, 0, 1)
  if #matches > 0 then
    vim.cmd('edit ' .. vim.fn.fnameescape(matches[1]))
  else
    print("Target file does not exist: " .. search_pattern)
  end
end, {})

-- Show git history of one file
vim.api.nvim_create_user_command('GitFileHistory', function(command_opts)
  local target_file = (command_opts.args and command_opts.args ~= '' and vim.fn.expand(command_opts.args)) or vim.fn.expand('%:p')
  if not target_file or target_file == '' then
    print("No file selected")
    return
  end

  local file_dir = vim.fn.fnamemodify(target_file, ':p:h')
  local git_root_lines = vim.fn.systemlist({ 'git', '-C', file_dir, 'rev-parse', '--show-toplevel' })
  if vim.v.shell_error ~= 0 or #git_root_lines == 0 then
    print("File not in a git repository")
    return
  end
  local git_root = vim.fn.fnamemodify(git_root_lines[1], ':p')
  target_file = vim.fn.fnamemodify(target_file, ':p')

  local relpath
  if string.sub(target_file, 1, #git_root + 1) == git_root .. '/' then
    relpath = string.sub(target_file, #git_root + 2)
  elseif target_file == git_root then
    relpath = vim.fn.fnamemodify(target_file, ':t')
  else
    relpath = target_file
  end

  local git_cmd = { 'git', '-C', git_root, 'log', '--follow', '-p', '-n', '100', '--', relpath }

  local output_lines = vim.fn.systemlist(git_cmd)
  local buf_handle = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf_handle, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf_handle, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf_handle, 'filetype', 'git')
  vim.api.nvim_buf_set_lines(buf_handle, 0, -1, false, output_lines)
  vim.api.nvim_set_current_buf(buf_handle)
end, { nargs = '?', complete = 'file' })

-- Open jira ticket from nvim
vim.api.nvim_create_user_command('JiraOpen', function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  if line == '' then
    return
  end

  local idx = col + 1
  local len = #line
  if idx > len then
    idx = len
  end

  local ticket = nil

  while idx >= 1 do
    if line:sub(idx, idx) == 'T' then
      local m = line:match("TEMOSO%-%d+", idx)
      if m then
        ticket = m
        break
      end
    end
    idx = idx - 1
  end

  if not ticket then
    print("No TEMOSO ticket found on this line.")
    return
  end

  local url = "https://c24-mobilfunk.atlassian.net/browse/" .. ticket

  local sysname = vim.loop.os_uname().sysname
  if sysname == "Darwin" then
    vim.fn.jobstart({ "open", url }, { detach = true })
  elseif sysname == "Windows_NT" then
    vim.fn.jobstart({ "cmd", "/c", "start", "", url }, { detach = true })
  else
    vim.fn.jobstart({ "xdg-open", url }, { detach = true })
  end
end, {})

-- Delete local branch
vim.api.nvim_create_user_command('GitDelete', function()
  if vim.bo.filetype ~= 'git' then
    return
  end

  local line = vim.api.nvim_get_current_line()
  if not line or line == '' then
    return
  end

  -- currently checked out branch
  if line:match("^%s*%*") then
    print("Can not delete currently checked out branch.")
    return
  end

  -- strip leading whitespace
  line = line:gsub("^%s*", "")
  local branch = line

  if branch:match("^origin/") then
    print("This command can only delete local branches")
    return
  end

  local answer = vim.fn.input("Delete branch '" .. branch .. "' in '" .. vim.fn["FugitiveWorkTree"]() .. "'? [y/N]: ")
  vim.api.nvim_echo({{""}}, false, {})
  vim.cmd("redraw")

  if answer ~= 'y' then
    vim.api.nvim_echo({{"Cancelled."}}, false, {})
    vim.cmd("redraw")
    return
  end

  vim.cmd("Git branch -D " .. vim.fn.fnameescape(branch))
end, {})

-- Align selected lines by inserted query
vim.api.nvim_create_user_command('AlignByQuery', function(opts)
  local start_line = opts.line1
  local end_line = opts.line2

  if start_line == 0 or end_line == 0 or start_line > end_line then
    print("Error: Invalid visual selection")
    return
  end

  vim.ui.input({ prompt = "Query to align by: " }, function(query)
    if not query or query == "" then
      return
    end

    if #query > 200 then
      print(" -> Error: Query too long (max 200 chars)")
      return
    end

    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    local positions = {}
    local max_length = 0
    local non_empty_count = 0

    for i, line in ipairs(lines) do
      if not line:match("^%s*$") then
        non_empty_count = non_empty_count + 1
        local pos = string.find(line, query, 1, true)

        if not pos then
          print(" -> Error: Query not found in line " .. (start_line + i - 1))
          return
        end

        local before = string.sub(line, 1, pos - 1):gsub("(%S)%s+$", "%1")
        local after = string.sub(line, pos)
        local length = vim.fn.strwidth(before)
        positions[i] = { before = before, after = after, length = length }

        if length > max_length then
          max_length = length
        end
      end
    end

    if non_empty_count < 2 then
      print(" -> Error: Must select at least 2 non-empty lines")
      return
    end

    for i, _ in ipairs(lines) do
      local info = positions[i]
      if info then
        local extra_space = query == " " and 0 or 1
        local spaces = string.rep(" ", max_length - info.length + extra_space)
        lines[i] = info.before .. spaces .. info.after
      end
    end

    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
  end)
end, { range = true })

-- Populate quickfix
local function quickfix_from_command(command)
    local output = vim.trim(vim.fn.system(command))
    vim.fn.setqflist({}, 'r', { lines = vim.split(output, '\n', { plain = true }), efm = "%f:%l:%c %m" })
    vim.cmd('copen')
end

vim.keymap.set('n', '<leader>f', function()
    local ok, command = pcall(vim.fn.input, "Command for quickfix: ")
    if ok and command ~= "" then
        quickfix_from_command(command)
    end
end, { noremap = true, silent = true })

-- Jump to task when cursor is over huid
local function open_task_under_cursor()
  local task_dir, pat = "tasks", "%d%d%d%d%d%d%d%d%-%d%d%d%d%d%d"
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 1-based

  local huid, s = nil, 1
  while true do
    local a, b = line:find(pat, s)
    if not a then break end
    if a <= col and col <= b then huid = line:sub(a, b); break end
    s = b + 1
  end
  if not huid then return vim.notify("No HUID under cursor", vim.log.levels.WARN) end

  local path = string.format("%s/%s/%s/task.md", vim.fn.getcwd(), task_dir, huid)
  if vim.fn.filereadable(path) == 0 then
    return vim.notify("Task file not found: " .. path, vim.log.levels.ERROR)
  end

  local old = vim.o.splitright
  vim.o.splitright = true
  vim.cmd("vsplit " .. vim.fn.fnameescape(path))
  vim.o.splitright = old
end

-- convert todo into a task
local function todo_to_task()
  local line = vim.api.nvim_get_current_line()
  local huid = os.date("%Y%m%d-%H%M%S")

  local title, tags, new_line = "", "", nil
  do
    local a, b, tag, desc = line:find("//%s*TODO%s*%(([^)]+)%)%s*:%s*(.+)")
    if not a then a, b, desc = line:find("//%s*TODO%s*:%s*(.+)") end
    if a then
      title = desc:gsub("^%s+", ""):gsub("%s+$", "")
      tags = tag and (" " .. tag:lower()) or ""
      new_line = line:sub(1, a - 1) .. ("// TASK(" .. huid .. ")") .. line:sub(b + 1)
    end
  end

  local dir = ("%s/tasks/%s"):format(vim.fn.getcwd(), huid)
  local path = dir .. "/task.md"
  if vim.fn.filereadable(path) == 1 then
    return vim.notify("Refusing to overwrite: " .. path, vim.log.levels.ERROR)
  end

  vim.fn.mkdir(dir, "p")
  local f, err = io.open(path, "w")
  if not f then return vim.notify("Failed to write: " .. (err or path), vim.log.levels.ERROR) end
  f:write(("# %s\n\n- STATUS: OPEN\n- PRIORITY: 20\n- TAGS:%s\n\n"):format(title, tags))
  f:close()

  if new_line then
    vim.api.nvim_set_current_line(new_line)
  end

  local old = vim.o.splitright
  vim.o.splitright = true
  vim.cmd("vsplit " .. vim.fn.fnameescape(path))
  vim.o.splitright = old
end

-- Find references to task and populate qf
local function task_find_from_current_buffer()
  local path = vim.api.nvim_buf_get_name(0)
  local huid = path:match("/tasks/(%d%d%d%d%d%d%d%d%-%d%d%d%d%d%d)/")
  if not huid then return vim.notify("Not a /tasks/<huid>/ buffer", vim.log.levels.WARN) end
  quickfix_from_command("replace " .. huid .. " -n -s")
end

-- Task commands
local function task_title_print_limit() return math.min(100, vim.api.nvim_win_get_width(0)-80) end
vim.keymap.set("n", "<leader>tg", open_task_under_cursor)
vim.keymap.set("n", "<leader>tp", task_find_from_current_buffer)
vim.keymap.set("n", "<leader>tn", todo_to_task)

vim.keymap.set('n', '<leader>tl', function()
  local path = vim.api.nvim_buf_get_name(0)
  local huid = path:match("/tasks/(%d%d%d%d%d%d%d%d%-%d%d%d%d%d%d)/")
  vim.cmd("Git log --all --grep='" .. huid .."'")
end, { noremap = true, silent = true})

vim.keymap.set('n', '<leader>tf', function()
  vim.cmd('copen ' .. math.floor(vim.api.nvim_list_uis()[1].height * 0.4))
  quickfix_from_command('task ls -t ' .. vim.fn.input("Tag for searching tasks: ") .. ' -f ' .. task_title_print_limit())
  vim.api.nvim_feedkeys('f|;ll', 'n', false)
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>tr', function()
  vim.cmd('copen ' .. math.floor(vim.api.nvim_list_uis()[1].height * 0.6))
  quickfix_from_command('task ls' .. ' -f ' .. task_title_print_limit())
  vim.api.nvim_feedkeys('f|;ll', 'n', false)
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>te', function()
  vim.cmd('copen ' .. math.floor(vim.api.nvim_list_uis()[1].height * 0.6))
  quickfix_from_command('task ls -c' .. ' -f ' .. task_title_print_limit())
  vim.api.nvim_feedkeys('f|;ll', 'n', false)
end, { noremap = true, silent = true })

-- Check if work repo
local function is_work_repo()
    return vim.fn.expand("%:p"):find("/Documents/Check24/", 1, true) ~= nil
end

-- Ticket number insert in the git commit
vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit",
    callback = function()
        if is_work_repo() then
            vim.cmd([[command! Ticket execute 'keeppatterns normal! /TEMOSO<CR>veee"qygg"qpI[<Esc>A] ']])
        else
            vim.cmd([[command! Ticket execute 'keeppatterns normal! gg0"+Pa] <Esc>I[<Esc>A']])
        end
        vim.keymap.set("n", "T", "<Cmd>Ticket<CR>A", { buffer = true })
    end,
})

EOF
