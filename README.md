# Dotfiles .:.

<img src=".img/dots.jpg" height=150 /><img src=".img/more_dots.gif" height=150 /><img src=".img/circle_circle.png" height=150 />

My configuration files, managed with [chezmoi](https://www.chezmoi.io/) so a
single repo drives every machine I use: macOS, Linux, Windows, and WSL.

chezmoi does not symlink; it *generates* your real dotfiles from a source tree,
transforming them per-machine via Go templates. That lets one branch serve all
environments instead of a branch per host.

## Install

macOS / Linux / WSL:

```sh
sh -c "$(curl -fsLS https://raw.githubusercontent.com/nixpulvis/dotfiles/master/install.sh)"
```

Windows (PowerShell):

```powershell
irm https://raw.githubusercontent.com/nixpulvis/dotfiles/master/install.ps1 | iex
```

Either bootstrap installs chezmoi (if missing), clones this repo, prompts for
per-machine settings, and applies. On a machine that already has chezmoi:

```sh
chezmoi init --apply nixpulvis
```

To track a work-in-progress branch, pass it through: `./install.sh --branch <branch>`.

## Components

Every machine gets the **base** layer. The other groups reflect what a machine
actually is:

| Group       | Applies to                                  | Contents                                                |
| ----------- | ------------------------------------------- | ------------------------------------------------------- |
| `base`      | everywhere                                  | git, bash, fish, vim/nvim, weechat, claude, omp, ssh, `bin/` |
| `graphical` | macOS/Windows always; Linux by prompt       | alacritty + fonts                                       |
| `wm`        | Linux only, by prompt (implies `graphical`) | sway, i3, i3blocks, rofi, zathura, `.xinitrc`, `.X`     |

macOS and Windows are inherently graphical, so `graphical` is implicit there
with no prompt — `chezmoi init` only asks for git identity. On Linux you are
asked whether the machine is `graphical` (a server or WSL box may not be) and
whether to install the `wm` stack. Answers persist per machine; re-run
`chezmoi init` to change them.

Gating lives in [`home/.chezmoiignore`](home/.chezmoiignore); the prompts and
their OS-aware defaults live in
[`home/.chezmoi.toml.tmpl`](home/.chezmoi.toml.tmpl). WSL is detected
automatically and defaults to a headless (non-`graphical`) profile.

Package names are declared once in
[`home/.chezmoidata/packages.yaml`](home/.chezmoidata/packages.yaml), grouped
by component, with a column per package manager:

```yaml
- {name: ripgrep, brew: ripgrep, pacman: ripgrep, apt: ripgrep, winget: BurntSushi.ripgrep.MSVC}
```

The `run_once_after_10-install-packages.{sh,ps1}.tmpl` scripts iterate that
table and emit one install command per manager (Homebrew on macOS, `pacman`/`apt`
on Linux, `winget` on Windows). Omit a manager key when a package doesn't exist
there and it's skipped. To add a tool, add one line to the YAML — never edit the
scripts.

One exception: **omp** (the oh-my-pi coding agent) isn't in any distro package
manager or winget. macOS installs it via a Homebrew tap (the `omp` line in the
YAML), while Linux and Windows fetch the pinned release binary directly into
`~/.bin` via `run_once_after_15-install-omp.{sh,ps1}.tmpl`. Its version and
checksums live in
[`home/.chezmoidata/omp.yaml`](home/.chezmoidata/omp.yaml); bump them there to
upgrade.

## Layout

```
.chezmoiroot                 -> points chezmoi at home/
install.sh / install.ps1     bootstrap entrypoints
home/                        chezmoi source (generates ~/)
  .chezmoi.toml.tmpl         per-machine prompts (name/email, graphical/wm)
  .chezmoiignore             component gating
  .chezmoidata/packages.yaml package name table (single source of truth)
  dot_*                      files that become ~/.*
  run_once_*                 one-time setup scripts
  AppData/*                  Windows-only path symlinks (see below)
test/                        sandbox.sh + docker.sh (safe test harness)
```

## Daily use

```sh
chezmoi edit ~/.gitconfig    # edit the source for a file
chezmoi diff                 # preview changes to $HOME
chezmoi apply                # write changes to $HOME
chezmoi update               # git pull + apply
chezmoi cd                   # shell in the source dir, then git commit/push
```

## Windows

Neovim and Alacritty read from `%LOCALAPPDATA%` / `%APPDATA%` on Windows, not
`~/.config`. The config is authored once under `dot_config/`; on Windows chezmoi
creates symlinks (`home/AppData/Local/nvim`, `home/AppData/Roaming/alacritty`)
pointing back at it, so there is a single source of truth. Creating symlinks on
Windows requires **Developer Mode** (Settings -> Privacy & security -> For
developers) or an elevated shell.

The Unix shell files (`.bash_profile`, `.bashrc`, fish, `bin/`) are still
written on native Windows but are inert unless Git Bash is present (which does
read `.bash_profile`/`.bashrc`). WSL is detected as Linux and gets the full
Linux treatment.

## Notes

Per-machine identity (personal vs work email, signing key) is answered at
`init` and written into `~/.gitconfig` from a template — no secrets and no
host-specific branches. System-level provisioning (locale, `sudoers`,
`pacman.conf`) that used to live here is out of scope; these are user dotfiles.

No secret ever lands in this repo. WeeChat's Libera.Chat SASL password lives in
the **OS keychain** (macOS Keychain / Linux Secret Service), and chezmoi reads it
at apply time via the `keyring` template function, rendering it into
`~/.config/weechat/irc.conf` (mode 0600). `irc.conf.tmpl` only contains a
`{{ keyring "libera" .ircnick }}` call — never the password itself.

Setup is driven by `chezmoi init`: if you answer yes to the **Libera** prompt
(default on macOS and graphical Linux), the `run_once_before_05-weechat-libera-secret`
script asks for the password once and stores it in the keychain *before* any file
is written, so `irc.conf` resolves on the same run. Afterwards just launch
`weechat` — it autoconnects, identifies via SASL, and autojoins `#alacritty` and
`#rust`. Verify with `/msg NickServ status`.

To set or change the password by hand (then `chezmoi apply` to re-render):

**macOS** — Keychain:

```sh
security add-generic-password -U -s libera -a <nick> -w '<password>'
```

**Linux** — Secret Service (libsecret + a running keyring daemon required):

```sh
printf %s '<password>' | secret-tool store --label=WeeChat service libera username <nick>
```

On headless/WSL/Windows machines answer no to the Libera prompt; `irc.conf` is
then written without SASL/autoconnect and nothing reads the keychain.
