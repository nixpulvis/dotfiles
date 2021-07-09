{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    pass-otp
    gnupg
  ];

  home.file.".ssh" = {
    source = ./.ssh;
    recursive = true;
  };
}
