# Fix rake arguments in ZSH, needed due to syntax overlap with globbing.
alias rake="noglob bundle exec rake"
alias rspec="bundle exec rspec"
