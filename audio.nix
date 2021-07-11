{ config, pkgs, lib, ... }: {
  # TODO: Make renoise, JACK and other DAW configs optional.
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "renoise"
    "spotify"
    "spotify-unwrapped"
  ];

  home.packages = with pkgs; [
    pavucontrol
    renoise
    spotify
    mpc_cli
    ncmpcpp
  ];

  services.mpd = {
    enable = true;
    musicDirectory = ~/media/music;
    playlistDirectory = ~/media/music;
    extraConfig = ''
      audio_output {
          type        "pulse"
          name        "My Pulse Output"
          #   server      "remote_server"     # optional
          #   sink        "remote_server_sink"    # optional
      }
    '';
  };
}
