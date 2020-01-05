# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# We actually use fish, and only need bash to source system files.
exec fish
