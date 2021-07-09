{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    i3blocks
    sysstat
    acpi
    lm_sensors
    brightnessctl
    perl
    bc
  ];

  home.file.".config/i3blocks/config".source = ./.config/i3blocks/config;
  home.file.".config/i3blocks/_date".source = ./.config/i3blocks/_date;
  home.file.".config/i3blocks/bandwidth".source = ./.config/i3blocks/bandwidth;
  home.file.".config/i3blocks/battery".source = ./.config/i3blocks/battery;
  home.file.".config/i3blocks/brightness".source = ./.config/i3blocks/brightness;
  home.file.".config/i3blocks/cpu_usage".source = ./.config/i3blocks/cpu_usage;
  home.file.".config/i3blocks/disk".source = ./.config/i3blocks/disk;
  home.file.".config/i3blocks/iface".source = ./.config/i3blocks/iface;
  home.file.".config/i3blocks/load_average".source = ./.config/i3blocks/load_average;
  home.file.".config/i3blocks/memory".source = ./.config/i3blocks/memory;
  home.file.".config/i3blocks/mic".source = ./.config/i3blocks/mic;
  home.file.".config/i3blocks/temperature".source = ./.config/i3blocks/temperature;
  home.file.".config/i3blocks/time".source = ./.config/i3blocks/time;
  home.file.".config/i3blocks/volume".source = ./.config/i3blocks/volume;
  home.file.".config/i3blocks/wifi".source = ./.config/i3blocks/wifi;
}
