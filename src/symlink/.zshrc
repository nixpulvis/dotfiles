# This file is just here to source other files, that actually do work,
# it's super lazy and should move out of it's mother's basement.

export DOTFILES=$HOME/.dotfiles

# source priorities
for priority ($DOTFILES/src/zsh/*.zsh_priority) source $priority

# source all .zsh files
for source ($DOTFILES/src/zsh/*.zsh) source $source