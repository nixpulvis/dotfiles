# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# XXX: Don't commit me, I wont work elsewhere.
# TODO: Avoid this process.
source $HOME/Code/development_secrets/secrets.sh

# We actually use fish, and only need bash to source system files.
exec fish

