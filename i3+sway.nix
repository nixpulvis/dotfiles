{ wm }:
let 
  pkgs = import <nixpkgs> {};
  style = import ./style.nix;
in rec {
  modifier = "Mod4";

  fonts = [
    "${style.font.family} ${toString style.font.size}"
  ];

  colors = {
    background = style.colors.background;

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
  };

  bars = [{
    statusCommand = "${pkgs.i3blocks}/bin/i3blocks";

    position = "top";
    fonts = [ "${style.font.family} ${toString style.font.size}" ];
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

  keybindings = {
    "${modifier}+Shift+r" = "reload; restart;";
    "${modifier}+Shift+e" = "exec ${if wm == "i3" then "exit-i3" else "exit-sway"}";

    "${modifier}+grave" = "exec ${pkgs.alacritty}/bin/alacritty";
    "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
    "${modifier}+Shift+q" = "kill";
    "button2 --release" = "kill";


    "${modifier}+f" = "fullscreen";
    "${modifier}+r" = "mode resize";

    # TODO: Refactor

    # Directional container focus.
    "${modifier}+h" = "focus left";
    "${modifier}+j" = "focus down";
    "${modifier}+k" = "focus up";
    "${modifier}+l" = "focus right";

    # Directional container move.
    "${modifier}+Shift+h" = "move left";
    "${modifier}+Shift+j" = "move down";
    "${modifier}+Shift+k" = "move up";
    "${modifier}+Shift+l" = "move right";

    # Workspace focus.
    "${modifier}+1" = "workspace 1";
    "${modifier}+2" = "workspace 2";
    "${modifier}+3" = "workspace 3";
    "${modifier}+4" = "workspace 4";
    "${modifier}+5" = "workspace 5";
    "${modifier}+6" = "workspace 6";
    "${modifier}+7" = "workspace 7";
    "${modifier}+8" = "workspace 8";
    "${modifier}+9" = "workspace 9";
    "${modifier}+0" = "workspace 10";

    # Move focused container to workspace.
    "${modifier}+Shift+1" = "move container to workspace 1";
    "${modifier}+Shift+2" = "move container to workspace 2";
    "${modifier}+Shift+3" = "move container to workspace 3";
    "${modifier}+Shift+4" = "move container to workspace 4";
    "${modifier}+Shift+5" = "move container to workspace 5";
    "${modifier}+Shift+6" = "move container to workspace 6";
    "${modifier}+Shift+7" = "move container to workspace 7";
    "${modifier}+Shift+8" = "move container to workspace 8";
    "${modifier}+Shift+9" = "move container to workspace 9";
    "${modifier}+Shift+0" = "move container to workspace 10";
  };
}
