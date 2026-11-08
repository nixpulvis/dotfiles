-- Language servers. Each server's config is in lsp/<name>.lua, or comes from
-- nvim-lspconfig with additions in after/lsp/<name>.lua.

-- Every server gets nvim-cmp's completion capabilities.
vim.lsp.config('*', { capabilities = require('cmp_nvim_lsp').default_capabilities() })
vim.lsp.enable({ 'luals', 'rust_analyzer', 'clangd' })

-- Menus that ask to pick one item (vim.ui.select), such as code actions
-- (gra), open in an fzf-lua picker.
require('fzf-lua').register_ui_select()

require('config.lsp.navigation')
require('config.lsp.inlay_hints')
require('config.lsp.progress')
