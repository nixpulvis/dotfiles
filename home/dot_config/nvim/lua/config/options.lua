-- Editor options and the color scheme.

-- Syntax color scheme, shared with Vim from ~/.vim. It uses the terminal's
-- own colors, so it needs termguicolors off.
vim.opt.runtimepath:append({ vim.fn.expand('~/.vim'), vim.fn.expand('~/.vim/after') })
-- 'background' is left unset so Nvim takes it from the terminal's background
-- color, which it asks for at startup and applies from any later answer. Ask
-- again on focus to catch a light/dark switch made while away; changing
-- 'background' reloads the scheme.
vim.api.nvim_create_autocmd('FocusGained', {
    callback = function() vim.api.nvim_ui_send('\027]11;?\007') end,
})
vim.opt.termguicolors = false
vim.opt.syntax = "enable"
vim.cmd.colorscheme('nixpulvis')

-- -- Tabs as spaces.
-- vim.opt.expandtab = true
-- vim.opt.tabstop = 4
-- vim.opt.shiftwidth = 4

-- Enable line numbers.
vim.opt.number = true
-- Highlight the line the cursor is on.
vim.opt.cursorline = true

vim.opt.linebreak = true
vim.opt.textwidth = 80
vim.opt.colorcolumn = "+0"

-- Show tabs.
vim.opt.listchars = { tab = ">=" }
vim.opt.list = true

-- Sync with system clipboard.
vim.opt.clipboard = "unnamed"

vim.opt.wildmode = "longest,list:longest"
vim.opt.wildmenu = true
vim.opt.complete = ".,kspell,t"
-- Don't show scratch docs when completing.
vim.opt.completeopt = "menuone"

-- Highlight search matches.
vim.opt.hlsearch = true

-- Persist undos.
vim.opt.undofile = true

-- How long the cursor rests before CursorHold, which highlights the uses of
-- the symbol under it (config.lsp.navigation). The default is 4000 ms. It also
-- sets how soon the swap file is written.
vim.opt.updatetime = 250

-- Not yet ported from the old Vimscript config:
--
-- " Allow some languages a bit more space.
-- augroup rust,cc
--     au!
--     autocmd FileType c,cpp,rust set textwidth=99
-- augroup END
--
-- augroup ott
--   autocmd BufEnter,BufRead,BufNewFile *.ott setlocal filetype=ott
--   autocmd FileType ott setlocal commentstring=%\ %s
-- augroup END
--
-- " Don't play with my JSON.
-- let g:vim_json_syntax_conceal = 0
--
-- " Markdown.
-- let g:vim_markdown_conceal = 0
-- let g:vim_markdown_conceal_code_blocks = 0
-- let g:tex_conceal = 0
-- let g:vim_markdown_math = 1
-- let g:vim_markdown_frontmatter = 1
--
-- " Distraction free.
-- " autocmd! User GoyoEnter Limelight
-- autocmd! User GoyoLeave colorscheme nixpulvis
--
-- " Strip whitespace on save.
-- fun! EnableStripWhitespaceOnSaveExceptMarkdown()
--   if &ft =~ 'markdown'
--     return
--   endif
--   EnableStripWhitespaceOnSave
-- endfun
-- autocmd BufEnter * call EnableStripWhitespaceOnSaveExceptMarkdown()
