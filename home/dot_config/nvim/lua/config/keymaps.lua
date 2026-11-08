-- General keys. Keys for quickfix lists and language servers are with those.

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
