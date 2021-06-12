{ config, pkgs, ... }:
let style = import ./style.nix;
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        dynamic_padding = true;
        decorations = "full";
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      font = {
        normal.family = style.font.family;
        size = style.font.size;
      };

      hints = {
        enable = [
          {
            regex = "[0-9a-f]{7,40}";
            action = "Copy";
            binding = {
              key = "G";
              mods = "Control|Shift";
            };
          }
          {
            regex = ''[^\\s]+'';
            action = "Copy";
            binding = {
              key = "W";
              mods = "Control|Shift";
            };
          }
        ];
      };

      key_bindings = [
        { key = "N"; mods = "Control"; command = { program = "alacritty"; args = []; }; }
        { key = "PageUp"; mode = "Vi"; action = "ScrollPageUp"; }
        { key = "PageDown"; mode = "Vi"; action = "ScrollPageDown"; }
        { key = 5; mods = "Shift"; mode = "Vi"; action = "Last"; }
        { key = 6; mods = "Shift"; mode = "Vi"; action = "Bracket"; }
        { key = 7; mods = "Shift"; mode = "Vi"; action = "FirstOccupied"; }
      ];

      colors = {
        search = {
        };

        hints = {
        };

        line_indicator.background = style.colors.yellow;

        primary = {
          background = style.colors.background;
          foreground = style.colors.foreground;
        };

        primary = {
          black = "#0C0C0C";
          red = style.colors.red;
          green = style.colors.green;
          yellow = style.colors.yellow;
          blue = style.colors.blue ;
          magenta = style.colors.magenta;
          cyan = style.colors.cyan;
          white = "#FFFFFF";
        };

        # TODO: Derive these from primary?

        bright = {

        };

        dim = {

        };

        indexed_colors = [
          { index = 161; color = "#FF00FF"; }
        ];
      };
    };
  };
  # home.file.".config/alacritty" = {
  #   source = .config/alacritty;
  #   recursive = true;
  # };
}
