# Get back
alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias ..... "cd ../../../.."

# Places I like to travel
alias dl "cd ~/Downloads"
alias dt "cd ~/Desktop"
alias unix "cd ~/unix"

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1 # GNU `ls`
  set colorflag "--color"
else # OS X `ls`
  set colorflag "-G"
end

alias ls "ls $colorflag"
# List all files colorized in long format
alias l "ls -l $colorflag"
# List all files colorized in long format, including dot files
alias la "ls -la $colorflag"
# List only directories
alias lsd "ls -l $colorflag | grep '^d'"

# SSH into school quickly
alias ccs 'ssh nathanl@kingofdragons.ccs.neu.edu'
alias acm 'ssh nixpulvis@acm.ccs.neu.edu'

# SSH into my cloud quickly
alias snowcloud 'ssh nixpulvis@162.243.33.86'
