-- Plugins, managed by vim-plug, and their settings.

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

-- Install missing plugins now, before the rest of the config requires them
-- (e.g. cmp), so a first launch doesn't error. Closes vim-plug's window.
for _, plug in pairs(vim.g.plugs) do
    if vim.fn.isdirectory(plug.dir) == 0 then
        vim.cmd('PlugInstall --sync | close')
        break
    end
end

-- Settings for plugins with no module of their own here.
vim.g.SuperTabDefaultCompletionType = "context"
vim.g.rg_highlight = true
vim.g.startify_change_to_dir = 0
vim.g.startify_custom_header = 'startify#fortune#quote()'
