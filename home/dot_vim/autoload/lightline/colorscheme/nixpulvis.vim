let unused = '#deadbe'

" Black
let s:black = [ unused, 0 ]
" actually DarkGrey
let s:grey    = [ unused, 236 ]
let s:red     = [ unused, 1 ]
let s:green   = [ unused, 2 ]
let s:gold    = [ unused, 3 ]
let s:yellow  = [ unused, 11 ]
let s:blue    = [ unused, 4 ]
let s:magenta = [ unused, 5 ]
let s:cyan    = [ unused, 14 ]
let s:white   = [ unused, 7 ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left     = [ [ s:black, s:blue ], [ s:black, s:green] ]
let s:p.normal.middle   = [ [ s:black, s:grey] ]
let s:p.normal.right    = [ [ s:black, s:red],  [ s:black, s:gold] ]
let s:p.normal.error    = [ [ s:black, s:red ] ]
let s:p.normal.warning  = [ [ s:black, s:yellow] ]

let s:p.insert.left     = [ [ s:black, s:cyan ], [ s:black, s:green] ]
let s:p.visual.left     = [ [ s:black, s:magenta], [ s:black, s:green] ]
let s:p.replace.left    = [ [ s:black, s:red ],  [ s:black, s:green] ]

let s:p.inactive.left   = [ [ s:black, s:grey] ]
let s:p.inactive.middle = [ [ s:grey, s:grey ] ]
let s:p.inactive.right  = [ [ s:black, s:grey ], [ s:black, s:grey ] ]

let s:p.tabline.tabsel  = [ [ s:white, s:black ] ]
let s:p.tabline.left    = [ [ s:white, s:grey ] ]
let s:p.tabline.middle  = [ [ s:grey, s:grey ] ]
let s:p.tabline.right   = copy(s:p.normal.right)

let g:lightline#colorscheme#nixpulvis#palette = lightline#colorscheme#flatten(s:p)
