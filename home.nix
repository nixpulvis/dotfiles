{ config, pkgs, ... }: {
  imports =
    [ ./alacritty.nix ./audio.nix ./fish.nix ./git.nix ./sway.nix ./i3blocks.nix ./vim.nix ];

  home.packages = with pkgs; [
    firefox
    zathura
    pass-otp
    gnupg
    pavucontrol
    htop
    borgbackup
  ];
}
