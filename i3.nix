{ config, pkgs, ... }:
let style = import ./style.nix;
in
{

  home.packages = with pkgs; [
    font-awesome
  ];

  xsession = {
    enable = true;
    windowManager.i3 = rec {
      enable = true;
      config = {
        fonts = [style.font];
        colors = {
          focused = {
            border = style.colors.yellow;
            background = style.colors.yellow;
            text = style.colors.background;
            indicator = style.colors.red;
            childBorder = style.colors.yellow;
          };
          focusedInactive = {
            border = style.colors.foreground;
            background = style.colors.foreground;
            text = style.colors.background;
            indicator = style.colors.foreground;
            childBorder = style.colors.foreground;
          };
          unfocused = {
            border = style.colors.foreground;
            background = style.colors.foreground;
            text = style.colors.background;
            indicator = style.colors.foreground;
            childBorder = style.colors.foreground;
          };
          urgent = {
            border = style.colors.red;
            background = style.colors.red;
            text = style.colors.background;
            indicator = style.colors.red;
            childBorder = style.colors.red;
          };
          background = style.colors.background;
        };
        bars = [{
          statusCommand = "${pkgs.i3blocks}/bin/i3blocks";
          position = "top";
          fonts = [style.font];
          colors = {
            background = style.colors.background;
            separator = style.colors.foreground;
            statusline = style.colors.foreground;
            focusedWorkspace = {
              background = style.colors.yellow;
              border = style.colors.yellow;
              text = style.colors.background;
            };
            activeWorkspace = {
              background = style.colors.background;
              border = style.colors.yellow;
              text = style.colors.foreground;
            };
            inactiveWorkspace = {
              background = style.colors.background;
              border = style.colors.background;
              text = style.colors.foreground;
            };
            urgentWorkspace = {
              background = style.colors.red;
              border = style.colors.red;
              text = style.colors.background;
            };
          };
        }];
        modifier = "Mod4";
        keybindings = {
          "${config.modifier}+Shift+r" = "reload; restart;";
          "${config.modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
          "${config.modifier}+Shift+q" = "kill";
          "${config.modifier}+grave" = "exec ${pkgs.alacritty}/bin/alacritty";

          # TODO: Refactor

          # Switch workspace.
          "${config.modifier}+1" = "workspace 1";
          "${config.modifier}+2" = "workspace 2";
          "${config.modifier}+3" = "workspace 3";
          "${config.modifier}+4" = "workspace 4";
          "${config.modifier}+5" = "workspace 5";
          "${config.modifier}+6" = "workspace 6";
          "${config.modifier}+7" = "workspace 7";
          "${config.modifier}+8" = "workspace 8";
          "${config.modifier}+9" = "workspace 9";
          "${config.modifier}+0" = "workspace 10";

          # Move focused container to workspace.
          "${config.modifier}+Shift+1" = "move container to workspace 1";
          "${config.modifier}+Shift+2" = "move container to workspace 2";
          "${config.modifier}+Shift+3" = "move container to workspace 3";
          "${config.modifier}+Shift+4" = "move container to workspace 4";
          "${config.modifier}+Shift+5" = "move container to workspace 5";
          "${config.modifier}+Shift+6" = "move container to workspace 6";
          "${config.modifier}+Shift+7" = "move container to workspace 7";
          "${config.modifier}+Shift+8" = "move container to workspace 8";
          "${config.modifier}+Shift+9" = "move container to workspace 9";
          "${config.modifier}+Shift+0" = "move container to workspace 10";
        };
      };
    };
  };

  # home.file.".config/i3" = {
  #   source = .config/i3;
  #   recursive = true;
  # };

  home.file.".config/i3blocks" = {
    source = .config/i3blocks;
    recursive = true;
  };

  programs.rofi = {
    enable = true;
  };
}
