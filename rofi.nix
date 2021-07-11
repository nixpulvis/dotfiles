{ config, pkgs, ... }: {
  programs.rofi = {
    enable = true;
    location = "top";
    width = 100;
    lines = 10;
    scrollbar = false;
    theme = .config/rofi/nixpulvis.rasi;
    extraConfig = {
      "columns" = 3;
    };
  };
}
