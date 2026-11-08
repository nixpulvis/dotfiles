-- Getting around code with the language server.
--
-- Pickers: fzf-lua lists with a preview. `gd` (definition) and `grt` (type
-- definition) jump straight there when there's a single result. `grr` lists
-- definitions tagged `def`, implementations tagged `impl` and references
-- tagged `ref` (type `^def`, `^impl` or `^ref` to show only those); the server
-- leaves the declaration out of the references, so it's listed once. `gO`
-- lists the symbols in this file. Jumps go on the tag stack, so Ctrl-T comes
-- back, and `:FzfLua resume` reopens the last list where it left off.
--
-- Symbol uses: when the cursor rests on a symbol ('updatetime', in
-- config.options), its other uses in the file are highlighted (by meaning, not
-- text) until it moves. `]r`/`[r` jump to the next/previous use, wrapping
-- around the file, and take a count.

local function definitions_and_references()
    local ansi = require('fzf-lua.utils').ansi_codes
    require('fzf-lua').lsp_finder({
        providers = {
            { 'definitions', prefix = ansi.green('def ') },
            { 'implementations', prefix = ansi.yellow('impl') },
            { 'references', prefix = ansi.blue('ref ') },
        },
        includeDeclaration = false,
        -- Async, the list sometimes came up missing the definitions; sync
        -- requests fill it reliably once the server has loaded.
        async = false,
    })
end

-- Kinds as words ("[Function] run"): the default icons need a Nerd Font, and
-- Alacritty uses Fira Mono.
local function document_symbols()
    require('fzf-lua').lsp_document_symbols({ symbol_style = 3 })
end

-- Server positions to 0-based rows and byte columns.
local function to_byte_pos(bufnr, encoding, p)
    local line = vim.api.nvim_buf_get_lines(bufnr, p.line, p.line + 1, false)[1] or ''
    return { p.line, vim.str_byteindex(line, encoding, p.character, false) }
end

local function before(a, b)
    return a[1] < b[1] or (a[1] == b[1] and a[2] < b[2])
end

-- Jumps `count` uses forward (dir 1) or back (dir -1) from the use under the
-- cursor. Asks the server for the uses on each press rather than reading the
-- highlights, which any cursor move clears.
local function jump_to_use(dir)
    local count = vim.v.count1
    local win = vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_get_current_buf()
    local client = vim.lsp.get_clients({ bufnr = bufnr, method = 'textDocument/documentHighlight' })[1]
    if not client then return end
    local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
    client:request('textDocument/documentHighlight', params, function(err, result)
        if err or not result or #result == 0 then return end
        if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= bufnr then return end
        local uses = {}
        for _, h in ipairs(result) do
            uses[#uses + 1] = {
                start = to_byte_pos(bufnr, client.offset_encoding, h.range.start),
                finish = to_byte_pos(bufnr, client.offset_encoding, h.range['end']),
            }
        end
        table.sort(uses, function(a, b) return before(a.start, b.start) end)
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

local group = vim.api.nvim_create_augroup('my.lsp.navigation', {})
-- The per-buffer highlight autocmds, cleared and set again on each attach.
local uses_group = vim.api.nvim_create_augroup('my.lsp.navigation.uses', {})

local function set_up_symbol_uses(bufnr)
    -- Once per buffer, even with several servers attached.
    vim.api.nvim_clear_autocmds({ group = uses_group, buffer = bufnr })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = uses_group,
        buffer = bufnr,
        callback = function() vim.lsp.buf.document_highlight() end,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = uses_group,
        buffer = bufnr,
        callback = function() vim.lsp.buf.clear_references() end,
    })
    vim.keymap.set('n', ']r', function() jump_to_use(1) end,
        { buffer = bufnr, desc = 'Next use of the symbol' })
    vim.keymap.set('n', '[r', function() jump_to_use(-1) end,
        { buffer = bufnr, desc = 'Previous use of the symbol' })
end

vim.api.nvim_create_autocmd('LspAttach', {
    group = group,
    callback = function(ev)
        local fzf = require('fzf-lua')
        local function map(lhs, rhs, desc)
            vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, desc = desc })
        end
        map('gd', fzf.lsp_definitions, 'Goto definition')
        map('grt', fzf.lsp_typedefs, 'Goto type definition')
        map('gO', document_symbols, 'Document symbols')
        map('grr', definitions_and_references, 'Definitions, implementations and references')

        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method('textDocument/documentHighlight', ev.buf) then
            set_up_symbol_uses(ev.buf)
        end
    end,
})

vim.api.nvim_create_autocmd('LspDetach', {
    group = group,
    callback = function(ev)
        vim.lsp.util.buf_clear_references(ev.buf)
        vim.api.nvim_clear_autocmds({ group = uses_group, buffer = ev.buf })
    end,
})
