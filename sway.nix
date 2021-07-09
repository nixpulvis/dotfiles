{ config, pkgs, lib, ... }:

let
  style = import ./style.nix;
  start-sway = pkgs.writeShellScriptBin "start-sway" ''
    systemctl --user import-environment
    exec systemctl --user start sway.service
  '';
in {

  home.packages = with pkgs; [
    start-sway
    font-awesome
    i3blocks
    swaylock
    swayidle
    wl-clipboard
    rofi
    sysstat
    acpi
  ];

  wayland.windowManager.sway = rec {
    enable = true;
    config = {
      fonts = [ "${style.font.family} ${toString style.font.size}" ];
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
      modifier = "Mod4";
      keybindings = {
        "${config.modifier}+Shift+r" = "reload; restart;";
        "${config.modifier}+Shift+e" = "exit";

        "${config.modifier}+grave" = "exec ${pkgs.alacritty}/bin/alacritty";
        "${config.modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
        "${config.modifier}+Shift+q" = "kill";

        "${config.modifier}+f" = "fullscreen";
        "${config.modifier}+r" = "mode resize";

        # TODO: Refactor

        # Directional container focus.
        "${config.modifier}+h" = "focus left";
        "${config.modifier}+j" = "focus down";
        "${config.modifier}+k" = "focus up";
        "${config.modifier}+l" = "focus right";

        # Directional container move.
        "${config.modifier}+Shift+h" = "move left";
        "${config.modifier}+Shift+j" = "move down";
        "${config.modifier}+Shift+k" = "move up";
        "${config.modifier}+Shift+l" = "move right";

        # Workspace focus.
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

  systemd.user.sockets.dbus = {
    Unit = {
      Description = "D-Bus User Message Bus Socket";
    };
    Socket = {
      ListenStream = "%t/bus";
      ExecStartPost = "${pkgs.systemd}/bin/systemctl --user set-environment DBUS_SESSION_BUS_ADDRESS=unix:path=%t/bus";
    };
    Install = {
      WantedBy = [ "sockets.target" ];
      Also = [ "dbus.service" ];
    };
  };

  systemd.user.services.dbus = {
    Unit = {
      Description = "D-Bus User Message Bus";
      Requires = [ "dbus.socket" ];
    };
    Service = {
      ExecStart = "${pkgs.dbus}/bin/dbus-daemon --session --address=systemd: --nofork --nopidfile --systemd-activation";
      ExecReload = "${pkgs.dbus}/bin/dbus-send --print-reply --session --type=method_call --dest=org.freedesktop.DBus / org.freedesktop.DBus.ReloadConfig";
    };
    Install = {
      Also = [ "dbus.socket" ];
    };
  };

  systemd.user.services.sway = {
    Unit = {
      Description = "Sway - Wayland window manager";
      Documentation = [ "man:sway(5)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.sway}/bin/sway";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

    # path = with pkgs; [ bash strace swayidle swaylock sway ];
  systemd.user.services.swayidle = {
    Unit = {
      Description = "swayidle locking";
      PartOf = [ "graphical-session.target" ];
      ConditionGroup = "users";
    };
    Service = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.swayidle}/bin/swayidle -w timeout 150 'swaylock -elfF -s fill -i ${.X/backdrop1.png}' timeout 300 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' before-sleep 'swaylock -elfF -s fill -i ${.X/backdrop1.png}' lock 'swaylock -elfF -s fill -i ${.X/backdrop1.png}'
      '';
    };

    # TODO: What is this?
    # script = ''
    #   swayidle -w \
    #   timeout 120 '${pkgs.backlight-locker} down' resume '${pkgs.backlight-locker} up' \
    #   timeout 150 'swaylock -elfF -s fill -i ${../../nixos-nineish.png}' \
    #   timeout 300 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
    #   before-sleep 'swaylock -elfF -s fill -i ${../../nixos-nineish.png}'
    #   lock 'swaylock -elfF -s fill -i ${../../nixos-nineish.png}'
    # '';
  };
}
