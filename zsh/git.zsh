autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes true

zstyle ':vcs_info:git*' formats "on ${PURPLE}%b%u%c${RESET}"
zstyle ':vcs_info:git*' stagedstr "^"
zstyle ':vcs_info:git*' unstagedstr "*"