local plug_path = "~/.local/share/nvim/site/autoload/plug.vim"
if vim.fn.empty(vim.fn.glob(plug_path)) ~= 0 then
    print("Install Plug...")
    vim.fn.system("sh -c 'curl -fLo " .. plug_path .. " --create-dirs " ..
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'")

    vim.cmd("source " .. plug_path)
    vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        callback = function()
            vim.cmd("PlugInstall --sync")
        end,
    })
end

local Plug = vim.fn['plug#']
vim.call('plug#begin')

Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-vsnip')
Plug('hrsh7th/vim-vsnip')

Plug('navarasu/onedark.nvim')
Plug('Yggdroot/indentLine')
Plug('airblade/vim-gitgutter')
Plug('cespare/vim-toml')
Plug('ctrlpvim/ctrlp.vim')
Plug('dag/vim-fish')
Plug('elixir-lang/vim-elixir')
Plug('elzr/vim-json')
Plug('ervandew/supertab')
Plug('itchyny/lightline.vim')
Plug('jiangmiao/auto-pairs')
Plug('jremmen/vim-ripgrep')
Plug('junegunn/goyo.vim')
-- TODO: Need to figure out a way to dim without 256 colors.
-- Plug 'junegunn/limelight.vim'
Plug('jvoorhis/coq.vim')
Plug('kmyk/brainfuck-highlight.vim')
Plug('mbbill/undotree')
Plug('mhinz/vim-startify')
Plug('ntpeters/vim-better-whitespace')
Plug('plasticboy/vim-markdown')
Plug('psosera/ott-vim')
Plug('rust-lang/rust.vim')
Plug('scrooloose/nerdtree')
Plug('timonv/vim-cargo')
Plug('tpope/vim-commentary')
Plug('tpope/vim-sleuth')
Plug('tpope/vim-surround')
Plug('wlangstroth/vim-racket')

vim.call('plug#end')

-- Syntax color scheme
-- TODO: Switch based on system mode.
-- vim.opt.background = "light"
vim.opt.background = "dark"
vim.opt.syntax = "enable"
require('onedark').load()

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

-- Bind vim style movement keys for command mode.
vim.keymap.set('c', '<C-h>', '<Left>')
vim.keymap.set('c', '<C-l>', '<Right>')
vim.keymap.set('c', '<C-k>', '<Up>')
vim.keymap.set('c', '<C-j>', '<Down>')

-- Toggle the tree viewer.
vim.keymap.set('n', '<C-\\>', ':NERDTreeToggle<CR>')

-- Spell checking.
vim.keymap.set('n', '<F5>', ':setlocal spell! spelllang=en_us<CR>')

-- Map Ctrl-/ to clear highlighting.
vim.keymap.set('n', '<C-_>', ':nohl<CR>', { silent = true })

vim.opt.wildmode = "longest,list:longest"
vim.opt.wildmenu = true
vim.opt.complete = ".,kspell,t"
vim.opt.completeopt = "menuone,preview"
vim.g.SuperTabDefaultCompletionType = "context"

-- Configure lightline to always show.
-- TODO: Git information in lightline.
vim.opt.showmode = false
vim.opt.laststatus = 2
-- TODO
-- let g:lightline = {
--   \ 'colorscheme': 'nixpulvis'
-- \}

-- Highlight search matches.
vim.opt.hlsearch = true
vim.g.rg_highlight = true

-- let g:ctrlp_custom_ignore = '**/target/*\|**/dumps/*\|**/backup/*'
-- " Ignore everything in the .gitignore file from ctrl-p.
-- let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

vim.g.startify_change_to_dir = 0
vim.g.startify_custom_header = 'startify#fortune#quote()'

-- Persist undos.
vim.opt.undofile = true

-- Don't show scratch docs when completing with LSP.
vim.opt.completeopt = "menuone"

require('cmp-config')

vim.lsp.enable('luals')
vim.lsp.enable('rust-analyzer')

-- " Allow some languages a bit more space.
-- augroup rust,cc
--     au!
--     autocmd FileType c,cpp,rust set textwidth=99
-- augroup END

-- augroup ott
--   autocmd BufEnter,BufRead,BufNewFile *.ott setlocal filetype=ott
--   autocmd FileType ott setlocal commentstring=%\ %s
-- augroup END

-- " Don't play with my JSON.
-- let g:vim_json_syntax_conceal = 0

-- " Markdown.
-- let g:vim_markdown_conceal = 0
-- let g:vim_markdown_conceal_code_blocks = 0
-- let g:tex_conceal = 0
-- let g:vim_markdown_math = 1
-- let g:vim_markdown_frontmatter = 1

-- " Distraction free.
-- " autocmd! User GoyoEnter Limelight
-- autocmd! User GoyoLeave colorscheme nixpulvis

-- " Strip whitespace on save.
-- fun! EnableStripWhitespaceOnSaveExceptMarkdown()
--   if &ft =~ 'markdown'
--     return
--   endif
--   EnableStripWhitespaceOnSave
-- endfun
-- autocmd BufEnter * call EnableStripWhitespaceOnSaveExceptMarkdown()
