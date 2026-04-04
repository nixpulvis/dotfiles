#!/bin/sh
# Claude Code status line — mirrors Fish prompt style

input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')

# Git info (branch + dirty/stash markers), skipping optional locks
git_info=""
if git_branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null); then
    git_dirty=""
    if ! GIT_OPTIONAL_LOCKS=0 git -C "$cwd" diff --quiet 2>/dev/null; then
        git_dirty="*"
    fi
    git_stash=""
    if [ -n "$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" stash list 2>/dev/null)" ]; then
        git_stash="$"
    fi
    git_info=" (${git_branch}${git_dirty}${git_stash})"
fi

# Shorten cwd like Fish's prompt_pwd: replace $HOME with ~, then abbreviate
# each parent directory component to its first letter, keeping the last full.
fish_abbrev_path() {
    local path="$1"
    # Replace home prefix with ~
    path=$(echo "$path" | sed "s|^$HOME|~|")
    # Split into components, abbreviate all but the last
    local IFS=/
    set -- $path
    local num=$#
    local result=""
    local i=1
    for component; do
        if [ $i -eq $num ]; then
            # Last component: keep full name
            result="${result}/${component}"
        elif [ -z "$component" ]; then
            # Leading slash / empty first token
            result=""
        elif [ "$component" = "~" ]; then
            result="~"
        else
            result="${result}/$(printf '%s' "$component" | cut -c1)"
        fi
        i=$((i+1))
    done
    echo "$result"
}

short_cwd=$(fish_abbrev_path "$cwd")

# Build left portion: user@hostname:dir[git]
left=$(printf '\033[31m%s\033[0m@\033[34m%s\033[0m:\033[32m%s\033[0m%s' \
    "$(whoami)" "$(hostname -s)" "$short_cwd" "$git_info")

# Build middle portion: model name + optional agent
model=$(echo "$input" | jq -r '.model.display_name // empty')
agent=$(echo "$input" | jq -r '.agent.name // empty')

middle=""
if [ -n "$model" ]; then
    if [ -n "$agent" ]; then
        middle=$(printf '\033[35m%s\033[0m \033[2m(agent: %s)\033[0m' "$model" "$agent")
    else
        middle=$(printf '\033[35m%s\033[0m' "$model")
    fi
fi

# Build right portion: date/time (dimmed)
right=$(printf '\033[2m%s\033[0m' "$(date '+%m/%d/%y %T %Z')")

if [ -n "$middle" ]; then
    printf '%s  %s  %s' "$left" "$middle" "$right"
else
    printf '%s  %s' "$left" "$right"
fi
