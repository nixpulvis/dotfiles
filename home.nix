{ config, pkgs, ... }:
{
  home.file.".bin" = {
    source = ./bin;
    recursive = true;
    executable = true;
  };

  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        bars = [{
          statusCommand = "${pkgs.i3blocks}/bin/i3blocks";
          position = "top";
        }];
      };
    };
  };

  # home.file.".config/i3" = {
  #   source = .config/i3;
  #   recursive = true;
  # };

  home.file.".config/i3blocks" = {
    source = .config/i3blocks;
    recursive = true;
  };

  home.packages = with pkgs; [
    alacritty
    rofi
    firefox
    pass-otp
    gnupg
  ];

  # TODO: setup default shell.
  programs.zsh.enable = true;

  home.file.".config/alacritty" = {
    source = .config/alacritty;
    recursive = true;
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

  programs.git = {
    enable = true;
    userName = "Nathan Lilienthal";
    userEmail = "nathan@nixpulvis.com";
    signing.key = "Nathan Lilienthal";
    aliases = {
      up = "!git remote update -p";
      a = "add";
      b = "branch";
      c = "clone";
      d = "diff";
      f = "fetch";
      sh = "show";
      i = "commit";
      l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      m = "merge";
      o = "remote";
      p0 = "rev-list --max-parents=0 HEAD";
      p = "push";
      r = "rebase";
      s = "status -s";
      t = "tag";
      u = "reset";
      pl = "pull";
      w = "whatchanged";
      x = "checkout";
      z = "stash";
      cp = "cherry-pick";
    };
    extraConfig = {
      init.defaultBranch = "master";
      branch.autosetuprebase = "always";
      apply.whitespace = "warn";
      credential.helper = "store";
      diff.tool = "vimdiff";
      merge.tool = "vimdiff";
    };
  };
}
