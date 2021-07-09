{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    pass-otp
    gnupg
  ];
}
