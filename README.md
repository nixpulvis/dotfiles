# My Dotfiles

## Install
To install from a system without `fish`, first you need to get a
little fishy. Run the following command to get with the times:

```
./fishup
```

Once you have `fish`, installing for the first, second, third or even forth time can be done with the following command:

```
# Full install.
./install

# To skip the slow Atom package install phase.
# Caused by https://github.com/atom/apm/issues/170.
env SKIP_APM_STARS_INSTALL=1 ./install.fish
```

Make sure you read the output of these commands, there are still a
few manual steps, though I'd like to get rid of them.

## Under the Hood

The dotfiles are a set of "packages" which are managed with [GNU `stow`][stow].
Each package can be installed and *uninstalled* with `stow`. A package is simply
a directory tree that will be linked to the appropriate locations.

### GNU Stow

[stow]: https://www.gnu.org/software/stow/ "GNU stow"
