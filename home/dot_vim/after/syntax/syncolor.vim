let highlights  = execute('highlight')
let highlights  = substitute(highlights, '\n\s\+', ' ', 'g')
let highlights  = split(highlights, '\n')
call map(highlights, "split(v:val, '\\s\\+xxx\\s\\+')[0]")
for group in highlights
    execute 'highlight' group 'NONE'
endfor
