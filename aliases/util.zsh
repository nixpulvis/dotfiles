# Empty all trashes and Apple system logs
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# STFU
alias stfu="osascript -e 'set volume output muted true'"