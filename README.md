# .:. nixpulvis/dotfiles

Dotfiles should be simple and painless to maintain between computers. Doing a git pull should be enough to update the whole system instantly. Symlinks and shell functions should be grouped by task.

This should be all it takes to install these dotfiles on any computer, with `git`, `zsh` and an internet connection.

``` bash
git clone git://github.com/nixpulvis/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

If this is a new setup, make sure `zsh` is the default login shell with `chsh`.

After that changes can be applied as easily as running `dots`.
