{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Nathan Lilienthal";
    userEmail = "nathan@nixpulvis.com";
    signing.key = "Nathan Lilienthal";
    ignores = ["*.swp"];
    aliases = {
      up = "!git remote update -p";
      a = "add";
      b = "branch";
      c = "clone";
      d = "diff";
      f = "fetch";
      sh = "show";
      i = "commit";
      l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      m = "merge";
      o = "remote";
      p0 = "rev-list --max-parents=0 HEAD";
      p = "push";
      r = "rebase";
      s = "status -s";
      t = "tag";
      u = "reset";
      pl = "pull";
      w = "whatchanged";
      x = "checkout";
      z = "stash";
      cp = "cherry-pick";
    };
    extraConfig = {
      init.defaultBranch = "master";
      branch.autosetuprebase = "always";
      apply.whitespace = "warn";
      credential.helper = "store";
      diff.tool = "vimdiff";
      merge.tool = "vimdiff";
    };
  };
}
