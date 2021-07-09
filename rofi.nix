{ config, pkgs, ... }: {
  programs.rofi = {
    enable = true;
    location = "top";
    width = 100;
    lines = 5;
    # columns = 5;
    scrollbar = false;
    theme = .config/rofi/nixpulvis.rasi;
  };
}
