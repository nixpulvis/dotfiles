" nixpulvis: a base16 color scheme taken from the terminal's own palette.
"
" Colors are terminal color numbers only, never names or hex, so the terminal
" decides what each one looks like (~/.config/alacritty/nixpulvis-dark.toml and
" nixpulvis-light.toml):
"
"   0-7    black, red, green, yellow, blue, magenta, cyan, white
"   8-15   bright versions of the above (8 is the muted gray)
"
" plus a few grays from the 256-color ramp, picked by 'background':
"
"            dark  light
"   shade    234   255    just off the background (cursor line, color column)
"   raise    236   252    further off it (borders, selection, menus)
"   deep     0     250    furthest off it (selected menu item)
"
" Color names are avoided on purpose: Vim maps them to different numbers
" depending on 't_Co' (DarkRed is 4 under some values), and names like Grey
" land on 248-255, which Alacritty paints red (nixpulvis-indexed.toml) where
" the light grays don't need them, to catch that.
"
" Neovim needs 'notermguicolors' for this scheme to show.
"
" Zed's nixpulvis themes (dark and light) are generated from this file and the
" Alacritty colors by ~/.config/zed/build-nixpulvis-theme; rerun it after
" changing either.

hi clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name = 'nixpulvis'

" Start from nothing: drop the colors of every group that isn't a link. Links
" (Conditional -> Statement, Neovim's @keyword -> Keyword, ...) stay, so
" everything resolves to the groups below, and anything not set below is
" plain text.
for s:line in split(substitute(execute('highlight'), '\n\s\+', ' ', 'g'), '\n')
    let s:fields = split(s:line, '\s\+xxx\s\+')
    if len(s:fields) == 2 && s:fields[1] !~# '^links to ' && s:fields[1] !=# 'cleared'
        execute 'highlight' s:fields[0] 'NONE'
    endif
endfor
unlet! s:line s:fields

if &background ==# 'light'
    let s:shade = 255
    let s:raise = 252
    let s:deep = 250
    let s:pop_fg = 15
    let s:pop_bg = 0
else
    let s:shade = 234
    let s:raise = 236
    let s:deep = 0
    let s:pop_fg = 0
    let s:pop_bg = 15
endif

" TODO: Not working.
let g:limelight_conceal_ctermfg = 'gray'

let g:indentLine_bgcolor_term = 'NONE'
let g:indentLine_color_term = s:raise

" Syntax. Identifier, Special and Delimiter stay plain.
hi Comment ctermfg=8
hi link SpecialComment Comment
hi Constant ctermfg=2
hi link String Constant
hi link Character Constant
hi link Number Constant
hi link Boolean Constant
hi link Float Constant
hi Function ctermfg=4
hi Statement ctermfg=1
hi link Conditional Statement
hi link Repeat Statement
hi link Label Statement
hi link Operator Statement
hi link Keyword Statement
hi link Exception Statement
hi link StorageClass Statement
hi link Structure Statement
hi link Typedef Statement
hi PreProc ctermfg=5
hi link Include PreProc
hi link Define PreProc
hi link Macro PreProc
hi link PreCondit PreProc
hi Type ctermfg=11
hi Underlined ctermfg=4 cterm=underline
hi Title cterm=bold
hi htmlBold cterm=bold
hi htmlItalic cterm=italic
hi htmlBoldItalic cterm=bold,italic
hi Error ctermfg=9
" TODO: Match a colon after the todo?
" TODO: Match only at the start of the comment.
syn match Todo "NOTE" containedin=.*Comment
hi Todo ctermfg=1 cterm=reverse
hi Added ctermfg=2
hi Changed ctermfg=3
hi Removed ctermfg=1

" Rust. Syntax files only add default links, so these win.
hi link rustSigil Statement
hi link rustSelf Statement
hi link rustModPath Identifier
hi link rustAssert rustMacro
hi link rustPanic rustMacro
hi link rustAttribute rustMacro
" Enum variants (Some, Ok, ...) are part of their type, not constants.
hi link rustEnumVariant Type
if has('nvim')
    hi link @lsp.type.enumMember Type
    " rust-analyzer's macro tokens otherwise fall back to @constant.
    hi link @constant.macro Macro
    hi link @function.macro Macro
endif

" Editor.
execute 'hi CursorLine ctermbg=' . s:shade
hi link CursorColumn CursorLine
execute 'hi ColorColumn ctermbg=' . s:shade
execute 'hi Visual ctermbg=' . s:raise
hi LineNr ctermfg=8
hi CursorLineNr ctermfg=11
execute 'hi NonText ctermfg=' . s:raise
hi link SpecialKey NonText
hi link Whitespace NonText
hi link EndOfBuffer NonText
execute 'hi Folded ctermfg=8 ctermbg=' . s:shade
hi FoldColumn ctermfg=8
execute 'hi MatchParen cterm=bold ctermbg=' . s:raise
hi Search ctermfg=0 ctermbg=11
execute 'hi IncSearch ctermfg=' . s:pop_fg . ' ctermbg=' . s:pop_bg
hi link CurSearch IncSearch
hi Directory ctermfg=4
hi SpellBad ctermfg=9 cterm=underline
hi SpellCap ctermfg=12 cterm=underline
hi SpellRare ctermfg=13 cterm=underline
hi SpellLocal ctermfg=14 cterm=underline
hi DiffAdd ctermfg=2
hi DiffChange ctermfg=3
hi DiffText ctermfg=3 cterm=bold
hi DiffDelete ctermfg=1
hi link GitGutterAdd Added
hi link GitGutterChange Changed
hi link GitGutterDelete Removed
hi link GitGutterChangeDelete Changed

" Windows, menus and messages. Lightline draws its own status and tab lines
" from the same numbers (autoload/lightline/colorscheme/nixpulvis.vim).
execute 'hi VertSplit ctermfg=' . s:raise . ' ctermbg=' . s:raise
hi link WinSeparator VertSplit
execute 'hi StatusLine ctermfg=0 ctermbg=' . s:raise
execute 'hi StatusLineNC ctermfg=8 ctermbg=' . s:raise
execute 'hi TabLineFill ctermbg=' . s:raise
execute 'hi TabLine ctermbg=' . s:raise
hi TabLineSel ctermfg=7 ctermbg=0
execute 'hi Pmenu ctermbg=' . s:raise
execute 'hi PmenuSel ctermbg=' . s:deep
execute 'hi PmenuSbar ctermbg=' . s:raise
hi PmenuThumb ctermbg=8
hi link WildMenu PmenuSel
hi link NormalFloat Pmenu
execute 'hi FloatBorder ctermfg=8 ctermbg=' . s:raise
hi QuickFixLine cterm=bold
hi ErrorMsg ctermfg=9
hi WarningMsg ctermfg=11
hi MoreMsg ctermfg=2
hi Question ctermfg=2
hi ModeMsg cterm=bold

" Neovim diagnostics and LSP.
hi DiagnosticError ctermfg=1
hi DiagnosticWarn ctermfg=3
hi DiagnosticInfo ctermfg=4
hi DiagnosticHint ctermfg=6
hi DiagnosticOk ctermfg=2
hi DiagnosticUnderlineError cterm=undercurl
hi DiagnosticUnderlineWarn cterm=undercurl
hi DiagnosticUnderlineInfo cterm=undercurl
hi DiagnosticUnderlineHint cterm=undercurl
hi DiagnosticUnderlineOk cterm=undercurl
hi link DiagnosticUnnecessary Comment
hi DiagnosticDeprecated cterm=strikethrough
hi LspInlayHint ctermfg=8
hi link LspReferenceText Visual
hi link LspReferenceRead Visual
hi link LspReferenceWrite Visual

unlet s:shade s:raise s:deep s:pop_fg s:pop_bg

" Lightline reads its palette once; rebuild it for the new 'background'.
if exists('g:lightline#colorscheme#nixpulvis#palette')
    runtime autoload/lightline/colorscheme/nixpulvis.vim
    call lightline#colorscheme()
endif
