function is_git_repo
  git rev-parse >/dev/null ^/dev/null
  not test $status -eq 128
end

function section
  printf "%s$argv[1]:" (set_color cyan)
  printf "%s$argv[2] " (set_color green)
end

function error
  printf "%s$argv[1]:" (set_color cyan)
  printf "%s$argv[2] " (set_color red)
end

function fish_prompt --description 'Write out the prompt'
    # $status gets nuked as soon as something else is run, e.g. set_color
    # so it has to be saved asap.
    set -l last_status $status

    # Username
    printf "%s%s " (set_color red) (whoami)

    # Hostname
    printf "%son %s%s " (set_color white) (set_color magenta) (hostname)

    # PWD.
    printf "%sin %s%s " (set_color white) (set_color green) (basename $PWD)

    printf "%swith " (set_color white)

    # Last status.
    if [ $last_status -ne 0 ]
        error status $last_status
        set -ge status
    end

    # Show disk usage when low
    set -l du (df / | tail -n1 | sed "s/  */ /g" | cut -d' ' -f 5 | cut -d'%' -f1)
    if test $du -gt 80
        error du $du%%
    end

    # rbenv
    if type ruby > /dev/null 2>&1
      section ruby (ruby --version | cut -d' ' -f 2)
    end

    if is_git_repo
      section git (__fish_git_prompt | sed -e 's/^ (*//' -e 's/) *$//')
    end

    # Prompt on a new line
    printf "\n%s> " (set_color white)
end
