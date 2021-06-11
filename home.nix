{ config, pkgs, ... }:
{
  imports = [
    ./alacritty.nix
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
  ];

  home.file.".bin" = {
    source = ./bin;
    recursive = true;
    executable = true;
  };
}
