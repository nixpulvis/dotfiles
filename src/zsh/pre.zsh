title() { print -Pn "\e]2; %~/ \a" }

precmd() {
  # we'll use VCS in our prompt (configs in thier own files)
  vcs_info

  # set the title of the window, for mac tab's in pwd
  title
}