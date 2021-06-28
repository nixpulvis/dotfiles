{ config, pkgs, lib, ... }: {
  # TODO: Make renoise and other DAW configs optional.

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "renoise" ];

  home.packages = with pkgs; [ pavucontrol renoise ];
}
