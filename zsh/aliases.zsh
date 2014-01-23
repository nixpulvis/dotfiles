# Get back
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Places I like to travel
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias code="cd ~/Code"
alias eui="cd /Applications/World\ of\ Warcraft/Interface/AddOns/EUI"
alias sublp="cd ~/Library/Application\ Support/Sublime\ Text\ 3/Packages"

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
  colorflag="--color"
else # OS X `ls`
  colorflag="-G"
fi
alias ls="ls ${colorflag}"
# List all files colorized in long format
alias l="ls -l ${colorflag}"
# List all files colorized in long format, including dot files
alias la="ls -la ${colorflag}"
# List only directories
alias lsd='ls -l ${colorflag} | grep "^d"'

# SSH into school quickly
alias ccs='ssh nathanl@kingofdragons.ccs.neu.edu'
alias acm='ssh nixpulvis@acm.ccs.neu.edu'
alias acm-staging='ssh nuacm@acm-staging.ccs.neu.edu'

alias snowcloud='ssh nixpulvis@162.243.33.86'

# Empty all trashes and Apple system logs
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"
# STFU
alias stfu="osascript -e 'set volume output muted true'"
