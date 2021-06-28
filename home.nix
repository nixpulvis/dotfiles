{ config, pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./audio.nix
    ./fish.nix
    ./git.nix
    ./i3.nix
    ./vim.nix
  ];

  home.packages = with pkgs; [
    alacritty
    firefox
    pass-otp
    gnupg
    pavucontrol
    htop
    borgbackup
  ];
}