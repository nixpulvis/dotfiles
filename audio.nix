{ config, pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "renoise"
  ];

  home.packages = with pkgs; [
    renoise
  ];
}
