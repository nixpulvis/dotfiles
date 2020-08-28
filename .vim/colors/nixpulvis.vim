" TODO: Verify index colors with Alacritty.
" TODO: Set variables somehow.
" NOTE: 256 currently just needed for LightGrey.
" set t_Co=16
set t_Co=265

" TODO: Not working.
let g:limelight_conceal_ctermfg = 'gray'


" DarkGrey is Bright Black
" Grey is Foreground
" LightGrey is SGR White?

hi Normal ctermbg=NONE
if &background == "light"
    hi CursorLine ctermbg=Grey
    hi Visual ctermbg=LightGrey
else
    " hi ColorColumn ctermbg=Red

    " FIXME: Alacritty implement?
    " TODO: Make visual cursor always show up.
    " " if &term =~ "xterm\\|rxvt"
    " " use an orange cursor in insert mode
    " let &t_SI = "\<Esc>]12;orange\x7"
    " " use a red cursor otherwise
    " let &t_EI = "\<Esc>]12;red\x7"
    " silent !echo -ne "\033]12;red\007"
    " " reset cursor when vim exits
    " autocmd VimLeave * silent !echo -ne "\033]112\007"
    " " use \003]12;gray\007 for gnome-terminal
    " " endif

    " " TODO: Investigate this.
    " highlight Cursor guifg=NONE guibg=Green
    " highlight CursorIM guifg=NONE guibg=Purple

    let g:indentLine_bgcolor_term = "NONE"
    let g:indentLine_fgcolor_term = "Grey"

    hi CursorLine cterm=reverse ctermbg=234
    hi Visual     cterm=reverse ctermbg=234
endif

hi Comment ctermfg=DarkGrey
hi SpecialComment ctermfg=DarkGrey
hi Constant ctermfg=DarkGreen
hi Type ctermfg=Yellow
hi Function ctermfg=DarkBlue
hi Statement ctermfg=DarkRed
hi StorageClass ctermfg=DarkRed
hi Structure ctermfg=DarkRed
hi Typedef ctermfg=DarkRed
hi Keyword ctermfg=DarkRed
hi PreProc ctermfg=DarkMagenta
" TODO: Match a colon after the todo?
" TODO: Match only at the start of the comment.
syn match Todo "NOTE" containedin=.*Comment
hi Todo cterm=reverse ctermfg=DarkRed
hi ColorColumn ctermbg=234
hi SpecialKey ctermfg=236
" TODO: hi Conceal ctermfg=236
hi SpellBad cterm=underline ctermfg=Red
hi VertSplit ctermbg=236 ctermfg=236
hi MatchParen cterm=none,bold ctermbg=Grey ctermfg=none
hi Search cterm=reverse ctermbg=Red
hi IncSearch ctermfg=Red

" hi Title       ctermfg=Grey ctermbg=Blue
" hi TabLine     ctermfg=Grey ctermbg=Blue
" hi TabLineFill ctermfg=Grey ctermbg=Green
" hi TabLineSel  ctermfg=Grey ctermbg=Blue

" TODO Audit complete list.
" ColorColumn
" Conceal
" Cursor
" lCursor
" CursorIM
" CursorColumn
" CursorLine
" Directory
" DiffAdd
" DiffChange
" DiffDelete
" DiffText
" EndOfBuffer
" ErrorMsg
" VertSplit
" Folded
" FoldColumn
" SignColumn
" IncSearch
" LineNr
" LineNrAbove
" LineNrBelow
" CursorLineNr
" MatchParen
" ModeMsg
" MoreMsg
" NonText
" Normal
" Pmenu
" PmenuSel
" PmenuSbar
" PmenuThumb
" Question
" QuickFixLine
" Search
" SpecialKey
" SpellBad
" SpellCap
" SpellLocal
" SpellRare
" StatusLine
" StatusLineNC
" StatusLineTe
" StatusLineTe
" TabLine
" TabLineFill
" TabLineSel
" Terminal
" Title
" Visual
" VisualNOS
" WarningMsg
" WildMenu
" Menu
" Scrollbar
" Tooltip
