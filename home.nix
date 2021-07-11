{ config, pkgs, ... }: {
  imports = [
    ./audio.nix
    ./borg.nix
    ./crypto.nix
    ./fish.nix
    ./git.nix
    ./network.nix
    ./ruby.nix
    ./rust.nix
    ./vim.nix

    # (if wayland then ./sway.nix else ./i3.nix)
    ./sway.nix
    ./i3.nix
    ./alacritty.nix
  ];

  home.packages = with pkgs; [
    xdg-utils
    firefox
    htop
    zathura
    vlc
    transmission
  ];

  home.file.".config/user-dirs.dirs".source = .config/user-dirs.dirs;
}
