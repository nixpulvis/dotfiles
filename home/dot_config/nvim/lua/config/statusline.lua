-- The status line (lightline), always shown.
-- TODO: Git information in lightline.

vim.opt.showmode = false
vim.opt.laststatus = 2

-- lightline calls its components as Vimscript functions, so they're on a
-- global table: v:lua.Statusline.<name>.
Statusline = {}

-- The language server's latest running work, e.g. "Indexing 34/120 (serde)",
-- cut to 50 characters.
function Statusline.lsp_progress()
    local task = require('config.lsp.progress').latest()
    if not task then return '' end
    local text = task.title or ''
    if task.message then
        text = text .. ' ' .. task.message
    elseif task.percentage then
        text = text .. ' ' .. task.percentage .. '%'
    end
    if vim.fn.strchars(text) > 50 then
        text = vim.fn.strcharpart(text, 0, 49) .. '…'
    end
    return text
end

-- The current buffer's diagnostic counts, e.g. "E:2" and "W:3", empty when
-- there are none.
local function diagnostic_count(severity, label)
    local n = #vim.diagnostic.get(0, { severity = severity })
    return n > 0 and (label .. ':' .. n) or ''
end
function Statusline.errors()
    return diagnostic_count(vim.diagnostic.severity.ERROR, 'E')
end
function Statusline.warnings()
    return diagnostic_count(vim.diagnostic.severity.WARN, 'W')
end

-- lightline's default right side, with LSP progress leading the file info
-- group, and the diagnostic counts in the theme's error and warning colors
-- left of it.
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
    component_function = { lsp_progress = 'v:lua.Statusline.lsp_progress' },
    component_expand = {
        diagnostic_errors = 'v:lua.Statusline.errors',
        diagnostic_warnings = 'v:lua.Statusline.warnings',
    },
    component_type = {
        diagnostic_errors = 'error',
        diagnostic_warnings = 'warning',
    },
}

-- lightline only reads the expanded components (the diagnostic counts) when
-- it updates, so update it whenever diagnostics change.
vim.api.nvim_create_autocmd('DiagnosticChanged', {
    group = vim.api.nvim_create_augroup('my.statusline', {}),
    callback = function() vim.fn['lightline#update']() end,
})
