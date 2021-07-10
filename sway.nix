{ config, pkgs, lib, ... }:
let
  style = import ./style.nix;
  # TODO: Relocate in src.
  backdrop = .X/backdrop2.png;
  start-sway = pkgs.writeShellScriptBin "start-sway" ''
    systemctl --user import-environment
    exec systemctl --user start sway.service
  '';
  exit-sway = pkgs.writeShellScriptBin "exit-sway" ''
    BACKGROUND='${style.colors.background}'
    FOREGROUND='${style.colors.foreground}'
    YELLOW='${style.colors.yellow}'

    while [ "$select" != "NO" -a "$select" != "YES" ]; do
      select=$(echo -e 'NO\nYES' | dmenu -i -nb $BACKGROUND -nf $FOREGROUND -sb $YELLOW -sf $BACKGROUND -fn 'Fira Mono:bold:pixelsize=20' -p "Do you really want to exit sway, thus ending the session?")
      [ -z "$select" ] && exit 0
    done
    [ "$select" = "NO" ] && exit 0
    swaymsg exit
  '';
in {
  imports = [
    ./dbus.nix
    ./i3blocks.nix
    ./rofi.nix
    ./alacritty.nix
  ];

  home.packages = with pkgs; [
    start-sway
    exit-sway
    font-awesome
    swaylock
    swayidle
    wl-clipboard
    mako
  ];

  wayland.windowManager.sway = rec {
    enable = true;
    wrapperFeatures.gtk = true;
    config = import ./i3+sway.nix { wm = "sway"; } // {
      output = { "*" = { bg = "${backdrop} fill"; }; };
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
        ${pkgs.swayidle}/bin/swayidle -w timeout 150 'swaylock -elfF -s fill -i ${backdrop}' timeout 300 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' before-sleep 'swaylock -elfF -s fill -i ${backdrop}' lock 'swaylock -elfF -s fill -i ${backdrop}'
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
