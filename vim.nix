{ config, pkgs, ... }:
{
  home.file.".bashrc".text = "EDITOR=vim";

  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "vim";
    };
  };

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      ctrlp
      lightline-vim
      nerdtree
      vim-commentary
      vim-json
      vim-markdown
      vim-nix
      vim-startify
    ];
    extraConfig = ''
      noremap <C-Bslash> :NERDTreeToggle<CR>
    '';
  };
}
