# Allow expansion inside PROMPT
setopt prompt_subst

# Our prompt, because we like colors.
PROMPT='${MAGENTA}%n${RESET} at ${ORANGE}%m${RESET} in ${GREEN}%c${RESET} ${vcs_info_msg_0_}
$ '
