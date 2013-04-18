# .:. nixpulvis/dotfiles

Dotfiles should be simple and painless to maintain between computers. Doing a git pull should be enough to update the whole system instantly. Symlinks and shell functions should be grouped by task.

This should be all it takes to install these dotfiles on any computer.

``` bash
git clone git://github.com/nixpulvis/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

After that changes can be applied as easily as `git pull`. This is possible due to a `post-merge` hook in git that runs `install.sh`.
