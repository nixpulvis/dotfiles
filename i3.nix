{ config, pkgs, ... }:
let style = import ./style.nix;
in {
  imports = [
    ./i3blocks.nix
    ./rofi.nix
    ./alacritty.nix
  ];

  home.packages = with pkgs; [ font-awesome ];

  xsession = {
    enable = true;
    windowManager.i3 = rec {
      enable = true;
      wrapperFeatures.gtk = true;
      config = import ./i3+sway.nix;
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
}
