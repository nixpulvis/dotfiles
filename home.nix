{ config, pkgs, ... }:

# Both i3 (X11) and sway (Wayland) are supported.
let wayland = true;

in {
  imports = [
    ./audio.nix
    ./crypto.nix
    ./fish.nix
    ./git.nix
    ./vim.nix

    (if wayland then ./sway.nix else ./i3.nix)
    ./i3blocks.nix
    ./alacritty.nix
  ];

  home.packages = with pkgs; [
    borgbackup
    firefox
    htop
    zathura
  ];

  home.file.".config/user-dirs.dirs".source = .config/user-dirs.dirs;
}
