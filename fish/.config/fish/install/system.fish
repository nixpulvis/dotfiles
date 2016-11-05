function dotfiles.install.system -d "TODO"
  # TODO: Update computer name

  if not grep fish /etc/shells >/dev/null
    echo 'Adding `/usr/local/bin/fish` to /etc/shells.'
    sudo sh -c 'echo "/usr/local/bin/fish" >> /etc/shells'
  end

  if [ $SHELL != '/usr/local/bin/fish' ]
    echo 'Changing the user shell to /usr/local/bin/fish.'
    chsh -s /usr/local/bin/fish
  end

  # TODO: copy SSH identity from flashdrive.
  # ```bash
  # cp -r /Volumes/BLACKSNOW/.ssh ~/.ssh
  # ```
  # TODO: https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#adding-your-ssh-key-to-the-ssh-agent
end
