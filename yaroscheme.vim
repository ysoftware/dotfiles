hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name="yaro"

function! s:setfg(group, color) 
    exe "highlight " . a:group . " guibg=NONE guifg=" . a:color
endfunction

function! s:setbgfg(group, color_bg, color_fg) 
    exe "highlight " . a:group . " guibg= " . a:color_bg . " guifg=" . a:color_fg
endfunction

function! yaroscheme#apply()
if &background == "dark"
    let s:bg_default = "#181818"
    let s:bg_highlight = "#302f2b"
    let s:bg_select = "#424f59"
    let s:bg_green = "#263f23"
    let s:bg_red = "#3f0909"

    let s:text_normal = "#fffff"
    let s:text_on_bg = "#e5e5e5"
    let s:text_green = "#b0e5ac"
    let s:text_blue = "#accde5"
    let s:text_brown = "#ccb484"
    let s:text_red = "#a51818"
    let s:text_yellow = "#e5e5ac"
    let s:text_gray = "#7f7f7f"
else
    let s:bg_default = "#f2f2f2"
    let s:bg_highlight = "#8fa9bf"
    let s:bg_select = "#6b8ba5"
    let s:bg_green = "#46a53a"
    let s:bg_red = "#a53a3a"

    let s:text_normal = "#262626"
    let s:text_on_bg = "#ffffff"
    let s:text_green = "#197211"
    let s:text_blue = "#23608c"
    let s:text_brown = "#725011"
    let s:text_red = "#bf1c1c"
    let s:text_yellow = "#727211"
    let s:text_gray = "#7f7f7f"
endif

call s:setbgfg("Normal", s:bg_default, s:text_normal)
call s:setbgfg("NormalNC", s:bg_default, s:text_normal)
call s:setfg("Comment", s:text_gray)
call s:setfg("Constant", s:text_normal)
call s:setfg("Identifier", s:text_normal)
call s:setfg("Special", s:text_normal)
call s:setfg("Ignore", s:text_normal)
call s:setfg("Underlined", s:text_normal)
call s:setfg("Todo", s:text_yellow)
call s:setfg("Statement", s:text_blue)
call s:setfg("Type", s:text_blue)
call s:setfg("PreProc", s:text_brown)
call s:setfg("Error", s:text_red)

call s:setfg("String", s:text_green)
call s:setfg("Character", s:text_green)
call s:setfg("Include", s:text_green)
call s:setfg("Operator", s:text_normal)
call s:setfg("SpecialChar", s:text_normal)
call s:setfg("Delimiter", s:text_normal)
call s:setfg("Structure", s:text_yellow)
call s:setfg("Function", s:text_yellow)
call s:setfg("Typedef", s:text_yellow)
call s:setfg("StorageClass", s:text_yellow)
call s:setfg("Number", s:text_blue)
call s:setfg("Boolean", s:text_blue)
call s:setfg("Float", s:text_blue)
call s:setfg("Conditional", s:text_blue)
call s:setfg("Repeat", s:text_blue)
call s:setfg("Keyword", s:text_blue)
call s:setfg("PreCondit", s:text_blue)
call s:setfg("Define", s:text_brown)
call s:setfg("Label", s:text_brown)
call s:setfg("Macro", s:text_brown)

call s:setfg("LineNr", s:text_yellow)
call s:setfg("Directory", s:text_blue)
call s:setfg("LineNrAbove", s:text_gray)
call s:setfg("LineNrBelow", s:text_gray)

call s:setbgfg("Search", s:bg_select, s:text_normal)
call s:setbgfg("IncSearch", s:bg_select, s:text_on_bg)
call s:setbgfg("EndOfBuffer", s:bg_default, s:text_normal)

call s:setfg("ErrorMsg", s:text_red)

call s:setbgfg("QuickFixLine", s:bg_highlight, s:text_normal)

call s:setbgfg("Visual", s:bg_select, s:text_normal)
call s:setbgfg("VisualNOS", s:bg_select, s:text_normal)

call s:setbgfg("Pmenu", s:bg_default, s:text_normal)
call s:setbgfg("PmenuExtra", s:bg_default, s:text_normal)
call s:setbgfg("PmenuSbar", s:bg_default, s:text_normal)
call s:setbgfg("PmenuKind", s:bg_default, s:text_normal)

call s:setbgfg("DiffAdd", s:bg_green, s:text_on_bg)
call s:setbgfg("DiffChange", s:bg_green, s:text_on_bg)
call s:setbgfg("DiffDelete", s:bg_red, s:text_on_bg)
call s:setbgfg("DiffText", s:bg_default, s:text_on_bg)

" Git fugitive colors
call s:setbgfg("diffAdded", s:bg_green, s:text_on_bg)
call s:setbgfg("diffRemoved", s:bg_red, s:text_on_bg)
endfunction

" hi link LspDiagnosticsDefaultError DiagnosticError
" hi link LspDiagnosticsDefaultWarning DiagnosticWarn
" hi link LspDiagnosticsDefaultInformation DiagnosticInfo
" hi link LspDiagnosticsDefaultHint DiagnosticHint
" hi link LspDiagnosticsUnderlineError DiagnosticUnderlineError
" hi link LspDiagnosticsUnderlineWarning DiagnosticUnderlineWarn
" hi link LspDiagnosticsUnderlineInformation DiagnosticUnderlineInfo
" hi link LspDiagnosticsUnderlineHint DiagnosticUnderlineHint
