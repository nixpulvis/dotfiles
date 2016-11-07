function dotfiles.install.pre.atom
  rm -rf ~/.atom
end

function dotfiles.install.post.atom
  if [ "$SKIP_APM_STARS_INSTALL" != "1" ]
    pip install jupyter
    apm stars --install
  end
end
