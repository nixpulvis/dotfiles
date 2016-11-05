function _postinstall.package.racket -e postinstall.package:racket
  # FIXME: This is currently throwing an error, but still works.
  raco pkg install --batch --deps search-auto xrepl
end
