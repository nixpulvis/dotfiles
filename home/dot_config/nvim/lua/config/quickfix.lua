-- In quickfix and location list windows, like fzf-lua's pickers: open the
-- entry under the cursor in a split (Ctrl-S), vertical split (Ctrl-V) or new
-- tab (Ctrl-T), or browse the list in an fzf-lua picker (Ctrl-F).

-- Leaves the list for the window its entries open in: a location list's own
-- window (a split copies the list from it) or the last window used. Returns
-- whether it's a location list.
local function to_file_window()
    if vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].loclist == 1 then
        vim.api.nvim_set_current_win(vim.fn.getloclist(0, { filewinid = 0 }).filewinid)
        return true
    end
    vim.cmd.wincmd('p')
    return false
end

-- Opens the entry under the cursor after running `split`, a command that
-- makes the window for it.
local function open(split)
    return function()
        local idx = vim.fn.line('.')
        local loclist = to_file_window()
        vim.cmd(split)
        vim.cmd((loclist and 'll ' or 'cc ') .. idx)
    end
end

-- From the file window, so a pick doesn't replace the list's window.
local function pick()
    local fzf = require('fzf-lua')
    if to_file_window() then fzf.loclist() else fzf.quickfix() end
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    group = vim.api.nvim_create_augroup('my.qf', {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', '<C-s>', open('split'), opts)
        vim.keymap.set('n', '<C-v>', open('vsplit'), opts)
        vim.keymap.set('n', '<C-t>', open('tab split'), opts)
        vim.keymap.set('n', '<C-f>', pick, opts)
    end,
})
