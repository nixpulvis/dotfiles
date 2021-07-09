{ config, pkgs, ... }: {
  imports = [
    ./audio.nix
    ./crypto.nix
    ./fish.nix
    ./git.nix
    ./vim.nix
    ./rust.nix
    ./ruby.nix

    # (if wayland then ./sway.nix else ./i3.nix)
    ./sway.nix
    ./i3.nix
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
