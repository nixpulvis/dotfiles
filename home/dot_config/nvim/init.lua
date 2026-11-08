-- stdpath('data') is ~/.local/share/nvim on Linux/macOS and
-- %LOCALAPPDATA%\nvim-data on Windows; its site/ dir is on 'runtimepath'.
local plug_path = vim.fn.stdpath('data') .. '/site/autoload/plug.vim'
if vim.fn.empty(vim.fn.glob(plug_path)) ~= 0 then
    print("Install Plug...")
    -- List form runs curl directly (no shell), so it works under cmd.exe too.
    vim.fn.system({ 'curl', '-fLo', plug_path, '--create-dirs',
        'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' })
    if vim.v.shell_error ~= 0 then
        error("Failed to download vim-plug to " .. plug_path)
    end

    vim.cmd.source(vim.fn.fnameescape(plug_path))
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

Plug('Yggdroot/indentLine')
Plug('airblade/vim-gitgutter')
Plug('cespare/vim-toml')
Plug('dag/vim-fish')
Plug('elixir-lang/vim-elixir')
Plug('elzr/vim-json')
Plug('ervandew/supertab')
Plug('ibhagwan/fzf-lua')
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
Plug('psosera/ott-vim')
Plug('rust-lang/rust.vim')
Plug('scrooloose/nerdtree')
Plug('timonv/vim-cargo')
Plug('tpope/vim-commentary')
Plug('tpope/vim-sleuth')
Plug('tpope/vim-surround')
Plug('wlangstroth/vim-racket')

vim.call('plug#end')

-- Install missing plugins now, before the config below requires them (e.g.
-- cmp), so a first launch doesn't error. Closes vim-plug's window.
for _, plug in pairs(vim.g.plugs) do
    if vim.fn.isdirectory(plug.dir) == 0 then
        vim.cmd('PlugInstall --sync | close')
        break
    end
end

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

-- Bind vim style movement keys for command mode.
vim.keymap.set('c', '<C-h>', '<Left>')
vim.keymap.set('c', '<C-l>', '<Right>')
vim.keymap.set('c', '<C-k>', '<Up>')
vim.keymap.set('c', '<C-j>', '<Down>')

-- Toggle the tree viewer.
vim.keymap.set('n', '<C-\\>', ':NERDTreeToggle<CR>')

-- Find files by name in an fzf-lua picker, from the current file's Git root
-- (else the working directory), as CtrlP did.
vim.keymap.set('n', '<C-p>', function()
    require('fzf-lua').files({ cwd = vim.fs.root(0, '.git') })
end, { desc = 'Find files' })

-- Spell checking.
vim.keymap.set('n', '<F5>', ':setlocal spell! spelllang=en_us<CR>')

-- Map Ctrl-/ to clear highlighting.
vim.keymap.set('n', '<C-_>', ':nohl<CR>', { silent = true })

-- In quickfix and location list windows, like fzf-lua's pickers: open the
-- entry under the cursor in a split (Ctrl-S), vertical split (Ctrl-V) or new
-- tab (Ctrl-T), or browse the list in an fzf-lua picker (Ctrl-F).
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    group = vim.api.nvim_create_augroup('my.qf', {}),
    callback = function(ev)
        -- Leave the list for the window its entries open in: a location
        -- list's own window (a split copies the list from it) or the last
        -- window used. Returns whether it's a location list.
        local function to_file_window()
            if vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].loclist == 1 then
                vim.api.nvim_set_current_win(vim.fn.getloclist(0, { filewinid = 0 }).filewinid)
                return true
            end
            vim.cmd.wincmd('p')
            return false
        end
        local function open(split)
            return function()
                local idx = vim.fn.line('.')
                local loclist = to_file_window()
                vim.cmd(split)
                vim.cmd((loclist and 'll ' or 'cc ') .. idx)
            end
        end
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', '<C-s>', open('split'), opts)
        vim.keymap.set('n', '<C-v>', open('vsplit'), opts)
        vim.keymap.set('n', '<C-t>', open('tab split'), opts)
        -- From the file window, so a pick doesn't replace the list's window.
        vim.keymap.set('n', '<C-f>', function()
            local fzf = require('fzf-lua')
            if to_file_window() then fzf.loclist() else fzf.quickfix() end
        end, opts)
    end,
})

vim.opt.wildmode = "longest,list:longest"
vim.opt.wildmenu = true
vim.opt.complete = ".,kspell,t"
vim.opt.completeopt = "menuone,preview"
vim.g.SuperTabDefaultCompletionType = "context"

-- Configure lightline to always show.
-- TODO: Git information in lightline.
vim.opt.showmode = false
vim.opt.laststatus = 2
-- lightline's default right side, with LSP progress (LightlineLspProgress)
-- leading the file info group, and the current buffer's diagnostic error and
-- warning counts (LightlineErrors, LightlineWarnings) in the theme's error and
-- warning colors left of it. Those are defined with the LSP setup below.
vim.g.lightline = {
    colorscheme = 'nixpulvis',
    active = {
        right = {
            { 'lineinfo' },
            { 'percent' },
            { 'lsp_progress', 'fileformat', 'fileencoding', 'filetype' },
            -- Shows as "E:2 W:3": typed components on the right side are
            -- laid out in reverse.
            { 'diagnostic_warnings', 'diagnostic_errors' },
        },
    },
    component_function = { lsp_progress = 'v:lua.LightlineLspProgress' },
    component_expand = {
        diagnostic_errors = 'v:lua.LightlineErrors',
        diagnostic_warnings = 'v:lua.LightlineWarnings',
    },
    component_type = {
        diagnostic_errors = 'error',
        diagnostic_warnings = 'warning',
    },
}

-- Highlight search matches.
vim.opt.hlsearch = true
vim.g.rg_highlight = true

vim.g.startify_change_to_dir = 0
vim.g.startify_custom_header = 'startify#fortune#quote()'

-- Persist undos.
vim.opt.undofile = true

-- Don't show scratch docs when completing with LSP.
vim.opt.completeopt = "menuone"

require('cmp-config')

vim.lsp.enable('luals')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('clangd')

-- Inlay hints (inferred types, parameter names) where the server has them,
-- off by default; <Leader>th toggles them.
vim.keymap.set('n', '<Leader>th', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle inlay hints' })

-- Menus that ask to pick one item (vim.ui.select), such as code actions
-- (gra), open in an fzf-lua picker.
require('fzf-lua').register_ui_select()

-- LSP navigation in fzf-lua pickers with a preview. `gd` (definition) and
-- `grt` (type definition) jump straight there when there's a single result.
-- `grr` lists definitions tagged `def`, implementations tagged `impl` and
-- references tagged `ref` (type `^def`, `^impl` or `^ref` to show only those);
-- the server leaves the declaration out of the references, so it's listed
-- once. `gO` lists the symbols in this file. Jumps go on the tag stack, so
-- Ctrl-T comes back, and `:FzfLua resume` reopens the last list where it left
-- off.
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(ev)
        local fzf = require('fzf-lua')
        local ansi = require('fzf-lua.utils').ansi_codes
        local function map(lhs, rhs, desc)
            vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, desc = desc })
        end
        map('gd', fzf.lsp_definitions, 'Goto definition')
        map('grt', fzf.lsp_typedefs, 'Goto type definition')
        -- Kinds as words ("[Function] run"): the default icons need a Nerd
        -- Font, and Alacritty uses Fira Mono.
        map('gO', function() fzf.lsp_document_symbols({ symbol_style = 3 }) end, 'Document symbols')
        map('grr', function()
            fzf.lsp_finder({
                providers = {
                    { 'definitions', prefix = ansi.green('def ') },
                    { 'implementations', prefix = ansi.yellow('impl') },
                    { 'references', prefix = ansi.blue('ref ') },
                },
                includeDeclaration = false,
                -- Async, the list sometimes came up missing the definitions;
                -- sync requests fill it reliably once the server has loaded.
                async = false,
            })
        end, 'Definitions, implementations and references')
    end,
})

-- When the cursor rests on a symbol, highlight its other uses in the file (by
-- meaning, not text), and clear them when it moves. Resting is CursorHold,
-- which waits 'updatetime' (4000 ms by default; it also sets how soon the
-- swap file is written). `]r`/`[r` jump to the next/previous use, wrapping
-- around the file, and take a count.
vim.opt.updatetime = 250
local lsp_highlight = vim.api.nvim_create_augroup('my.lsp.highlight', {})

-- Asks the server for the uses on each press rather than reading the
-- highlights, which any cursor move clears.
local function jump_reference(dir)
    local count = vim.v.count1
    local win = vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_get_current_buf()
    local client = vim.lsp.get_clients({ bufnr = bufnr, method = 'textDocument/documentHighlight' })[1]
    if not client then return end
    local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
    client:request('textDocument/documentHighlight', params, function(err, result)
        if err or not result or #result == 0 then return end
        if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= bufnr then return end
        -- Server positions to 0-based rows and byte columns, in file order.
        local uses = {}
        for _, h in ipairs(result) do
            local function pos(p)
                local line = vim.api.nvim_buf_get_lines(bufnr, p.line, p.line + 1, false)[1] or ''
                return { p.line, vim.str_byteindex(line, client.offset_encoding, p.character, false) }
            end
            uses[#uses + 1] = { start = pos(h.range.start), finish = pos(h.range['end']) }
        end
        local function before(a, b) return a[1] < b[1] or (a[1] == b[1] and a[2] < b[2]) end
        table.sort(uses, function(a, b) return before(a.start, b.start) end)
        -- Step from the use under the cursor.
        local row, col = unpack(vim.api.nvim_win_get_cursor(win))
        local cursor = { row - 1, col }
        local current = 1
        for i, u in ipairs(uses) do
            if not before(cursor, u.start) and before(cursor, u.finish) then
                current = i
                break
            end
        end
        local target = uses[(current - 1 + dir * count) % #uses + 1].start
        vim.api.nvim_win_set_cursor(win, { target[1] + 1, target[2] })
    end, bufnr)
end

vim.api.nvim_create_autocmd('LspAttach', {
    group = lsp_highlight,
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not (client and client:supports_method('textDocument/documentHighlight', ev.buf)) then
            return
        end
        -- Once per buffer, even with several servers attached.
        vim.api.nvim_clear_autocmds({ group = lsp_highlight, buffer = ev.buf })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = lsp_highlight,
            buffer = ev.buf,
            callback = function() vim.lsp.buf.document_highlight() end,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            group = lsp_highlight,
            buffer = ev.buf,
            callback = function() vim.lsp.buf.clear_references() end,
        })
        vim.keymap.set('n', ']r', function() jump_reference(1) end,
            { buffer = ev.buf, desc = 'Next use of the symbol' })
        vim.keymap.set('n', '[r', function() jump_reference(-1) end,
            { buffer = ev.buf, desc = 'Previous use of the symbol' })
    end,
})
vim.api.nvim_create_autocmd('LspDetach', {
    group = lsp_highlight,
    callback = function(ev)
        vim.lsp.util.buf_clear_references(ev.buf)
        vim.api.nvim_clear_autocmds({ group = lsp_highlight, buffer = ev.buf })
    end,
})

-- Running LSP work (rust-analyzer's indexing, cargo check, ...) for the
-- status line, by client and progress token. A task is dropped at its `end`,
-- and a stopped client's tasks are skipped. A task ending also re-requests
-- inlay hints for the client's buffers that have none: a buffer opened while
-- the server was still loading otherwise gets none until it's edited.
local lsp_progress = {}
vim.api.nvim_create_autocmd('LspProgress', {
    group = vim.api.nvim_create_augroup('my.lsp.progress', {}),
    callback = function(ev)
        local params = ev.data.params
        local value = params.value
        if type(value) ~= 'table' then return end
        local tasks = lsp_progress[ev.data.client_id] or {}
        lsp_progress[ev.data.client_id] = tasks
        if value.kind == 'end' then
            tasks[params.token] = nil
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            for bufnr in pairs(client and client.attached_buffers or {}) do
                if vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
                    and #vim.lsp.inlay_hint.get({ bufnr = bufnr }) == 0 then
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end
            end
        else
            -- A report without a message or percentage keeps the last one.
            local task = tasks[params.token] or {}
            tasks[params.token] = {
                title = value.title,
                message = value.message or task.message,
                percentage = value.percentage or task.percentage,
                updated = vim.uv.hrtime(),
            }
        end
        vim.cmd.redrawstatus()
    end,
})

-- The most recently updated task, e.g. "Indexing 34/120 (serde)", cut to 50
-- characters.
function LightlineLspProgress()
    local latest
    for client_id, tasks in pairs(lsp_progress) do
        if vim.lsp.get_client_by_id(client_id) then
            for _, task in pairs(tasks) do
                if not latest or task.updated > latest.updated then
                    latest = task
                end
            end
        end
    end
    if not latest then return '' end
    local text = latest.title or ''
    if latest.message then
        text = text .. ' ' .. latest.message
    elseif latest.percentage then
        text = text .. ' ' .. latest.percentage .. '%'
    end
    if vim.fn.strchars(text) > 50 then
        text = vim.fn.strcharpart(text, 0, 49) .. '…'
    end
    return text
end

-- The current buffer's diagnostic counts for lightline, e.g. "E:2" and "W:3",
-- empty when there are none. lightline only reads these when it updates, so
-- update it whenever diagnostics change.
local function diagnostic_count(severity, label)
    local n = #vim.diagnostic.get(0, { severity = severity })
    return n > 0 and (label .. ':' .. n) or ''
end
function LightlineErrors()
    return diagnostic_count(vim.diagnostic.severity.ERROR, 'E')
end
function LightlineWarnings()
    return diagnostic_count(vim.diagnostic.severity.WARN, 'W')
end
vim.api.nvim_create_autocmd('DiagnosticChanged', {
    group = vim.api.nvim_create_augroup('my.lightline.diagnostics', {}),
    callback = function() vim.fn['lightline#update']() end,
})

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
