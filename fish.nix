{ config, pkgs, ... }: {
  home.packages = with pkgs; [ fortune ];
  programs.fish = {
    enable = true;
    promptInit = ''
      set __fish_git_prompt_showdirtystate 'yes'
      set __fish_git_prompt_showstashstate 'yes'
      set __fish_git_prompt_showcolorhints

      function fish_prompt
        printf '%s%s%s@%s%s%s:%s%s%s%s $ ' \
        (set_color red) (whoami) (set_color normal) \
        (set_color blue) (hostname) (set_color normal) \
        (set_color green) (prompt_pwd) (set_color normal) \
        (__fish_git_prompt)
      end

      function fish_right_prompt
        set last_status $status
        if test $last_status -ne 0
          echo -n '('(set_color red)$last_status(set_color normal)') '
        end
        printf '%s%s%s' (set_color -d white) (date '+%D %T %Z') (set_color normal)
      end
    '';

    interactiveShellInit = ''
      set -x EDITOR vim
      alias l "ls -l"

      # Print a nice startup message.
      function fish_greeting
        fortune
        echo "><_> tick... tock..."
      end
    '';
  };
}
