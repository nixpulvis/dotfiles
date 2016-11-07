function dotfiles.install.post.racket
  # FIXME: This is currently throwing an error, but still works.
  raco pkg install --batch --deps search-auto xrepl
end
