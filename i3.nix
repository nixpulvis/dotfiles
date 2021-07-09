{ config, pkgs, ... }:
let
  style = import ./style.nix;
  exit-i3 = pkgs.writeShellScriptBin "exit-i3" ''
    while [ "$select" != "NO" -a "$select" != "YES" ]; do
      select=$(echo -e 'NO\nYES' | dmenu -i -p "Do you really want to exit i3, thus ending the session?")
      [ -z "$select" ] && exit 0
    done
    [ "$select" = "NO" ] && exit 0
    i3-msg exit
  '';
in {
  imports = [
    ./i3blocks.nix
    ./rofi.nix
    ./alacritty.nix
  ];

  home.packages = with pkgs; [
    exit-i3
    font-awesome
    feh
  ];

  xsession = {
    enable = true;
    windowManager.i3 = rec {
      enable = true;
      config = import ./i3+sway.nix { wm = "i3"; };
      extraConfig = ''
        exec --no-startup-id ${pkgs.feh}/bin/feh --bg-scale ${.X/backdrop1.png}
      '';
    };
  };

  # home.file.".config/i3" = {
  #   source = .config/i3;
  #   recursive = true;
  # };

  # home.file.".config/i3blocks" = {
  #   source = .config/i3blocks;
  #   recursive = true;
  # };
}
