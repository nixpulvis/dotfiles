# Allow expansion inside PROMPT
setopt prompt_subst

# Our prompt, because we like colors.
PROMPT='${MAGENTA}%n${RESET} at ${ORANGE}%m${RESET} in ${GREEN}%c${RESET} ${vcs_info_msg_0_}
$ '

# Only show battery if we have ioreg, used to get battery info.
if which ioreg &> /dev/null; then
  RPROMPT='%10{$(echo `battery`)%}'
fi