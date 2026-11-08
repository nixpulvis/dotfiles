-- Inlay hints (inferred types, parameter names) where the server has them,
-- off by default; <Leader>th toggles them.

vim.keymap.set('n', '<Leader>th', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle inlay hints' })

-- A buffer opened while its server is still loading gets no hints until it's
-- edited, so whenever a piece of the server's work ends, ask again for its
-- buffers that have none.
vim.api.nvim_create_autocmd('LspProgress', {
    pattern = 'end',
    group = vim.api.nvim_create_augroup('my.lsp.inlay_hints', {}),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        for bufnr in pairs(client and client.attached_buffers or {}) do
            if vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
                and #vim.lsp.inlay_hint.get({ bufnr = bufnr }) == 0 then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
        end
    end,
})
