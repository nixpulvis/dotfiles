# Dotfiles .:.

## Install

Clone the dotfiles into place.

```sh
git clone https://github.com/nixpulvis/dotfiles ~
```

And install dependencies from `brew`/`apt`, `fisherman` and more.

```sh
~/.install dependencies
```

Finally we should install/set the system shell.

```sh
# TODO: nice way to append as root.
echo /usr/local/bin/fish >> /etc/shells
chsh -s /usr/local/bin/fish
```

Next we need to move secrets into place. Secrets are things like `.ssh/id_rsa` and
GPG private keys.

```sh
~/.install secrets /Volumes/DISKNAME
```

## Usage

```sh

```