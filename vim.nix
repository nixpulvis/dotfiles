{ config, pkgs, ... }: {
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [

      ctrlp
      indentLine
      lightline-vim
      nerdtree
      supertab
      auto-pairs
      vim-commentary
      vim-sleuth
      vim-surround
      vim-gitgutter
      vim-startify

      rust-vim
      vim-json
      vim-markdown
      vim-nix
      vim-toml
      vim-racket

    ];
    extraConfig = ''
      noremap <C-Bslash> :NERDTreeToggle<CR>

      " Syntax color scheme
      set background=light
      syntax enable
      colorscheme nixpulvis

      " Configure lightline to always show.
      " TODO: Git information in lightline.
      set noshowmode
      set laststatus=2
      let g:lightline = {
        \ 'colorscheme': 'nixpulvis'
      \}

      " Highlight search matches.
      set hlsearch
      let g:rg_highlight = 1

      let g:ctrlp_custom_ignore = '**/target/*\|**/dumps/*\|**/backup/*'

      " Use C-style comments.
      autocmd FileType c,cpp,cs,java,rust setlocal commentstring=//\ %s

      " Use Rust syntax for *.lalrpop.
      autocmd BufRead,BufNewFile *.lalrpop setfiletype rust

      " Ignore everything in the .gitignore file from ctrl-p.
      let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

      let g:startify_change_to_dir = 0
      let g:startify_custom_header = 'startify#fortune#quote()'


      " Allow clicking with the mouse.
      set ttymouse=sgr
      set mouse=a

      " Add a numberline gutter.
      set number

      " Highlight the line the cursor is on.
      " NOTE: Also works with cursorcolumn.
      " TODO: Fix my theme for this
      " set cursorcolumn
      " set cursorline

      set formatoptions-=t
      set linebreak
      set textwidth=79
      set colorcolumn=+1,+2

      " Allow some languages a bit more space.
      augroup rust,cc
          au!
          autocmd FileType c,cpp,rust set textwidth=99
      augroup END

      augroup ott
        autocmd BufEnter,BufRead,BufNewFile *.ott setlocal filetype=ott
        autocmd FileType ott setlocal commentstring=%\ %s
      augroup END


      " Clipboard support.
      set clipboard=unnamedplus

      " Folding.
      set foldlevel=99

      " Show tabs.
      set list
      set listchars=tab:>-

      " Default indentation values.
      set expandtab
      set shiftwidth=4
      set tabstop=4

      " Don't play with my JSON.
      let g:vim_json_syntax_conceal = 0

      " Markdown.
      let g:vim_markdown_conceal = 0
      let g:vim_markdown_conceal_code_blocks = 0
      let g:tex_conceal = 0
      let g:vim_markdown_math = 1
      let g:vim_markdown_frontmatter = 1

      " Persist undos.
      " TODO: Encrypt?
      :silent call system('mkdir -p $HOME/.vim/undo')
      set undodir=$HOME/.vim/undo
      set undofile

      " Distraction free.
      " autocmd! User GoyoEnter Limelight
      autocmd! User GoyoLeave colorscheme nixpulvis

      set wildmode=longest,list:longest
      set wildmenu
      set complete=.,kspell,t
      set completeopt=menuone,preview
      let g:SuperTabDefaultCompletionType = "context"

      " Bind vim style movement keys for command mode.
      cnoremap <C-h> <left>
      cnoremap <C-j> <down>
      cnoremap <C-k> <up>
      cnoremap <C-l> <right>

      " Bind standard movement C-a for moving to the start of the line.
      " C-e is already bound.
      cnoremap <C-a> <C-b>

      " Spell checking.
      map <F5> :setlocal spell! spelllang=en_us<CR>

      " Lookup word in dictionary.
      fun LookupDefinition(word)
        exe '!dict -d gcide ' . a:word
      endfun
      map <F6> :call LookupDefinition(expand("<cword>"))<CR>

      " Map Ctrl-/ to clear highlighting.
      nnoremap <silent> <C-_> :nohl<CR>

      " Open the NERDTree directory viewer.
      noremap <C-Bslash> :NERDTreeToggle<CR>

      " Strip whitespace on save.
      autocmd BufWritePre * :%s/\s\+$//e
    '';
  };


  home.file.".vim" = {
    source = ./.vim;
    recursive = true;
  };
}
