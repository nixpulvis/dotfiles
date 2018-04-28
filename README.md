# Dotfiles .:.

<img src="img/dots.jpg" height=150 /><img src="img/more_dots.gif" height=150 /><img src="img/circle_circle.png" height=150 />

To a UNIX developer, dotfiles are synonymous with configuration files, and this
repository is a collection of mine, along with some scripts to install them.
You simply can't spend enough bytes on dotfiles. A well setup machine is your
best friend.

Some of these configurations are compatible with software that runs on various
operating systems, and will work even if the installer doesn't. I only support
the installer script for Arch Linux at the moment, but that may change. If you
are interested in getting an Arch Linux install up and running easily, check
out my [arch](https://github.com/nixpulvis/arch) installer project.

Read more about these dotfiles in the [Hardware](#hardware) and
[Software](#software) sections.

## Installation

TODO: Notes about where to clone the dotfiles.

```sh
# Run as root.
./install <user>
```

## Hardware

My setup is based on a few key pieces of hardware. I'm always changing small
things in my setup, but these devices are required to make full use of my
configuration.

One day I hope to run hardware I've built, but that day may never come. I mean
I'm not about to manufacture silicon or anything, so this point has more to do
with repairability and knowledge of the workings of the components.

I'll generally *avoid* systems that take control away from me, even at the cost
of simplicity. Computers, like any other tool, are only as powerful as the user
is able to control them. I'll *seek* hardware that I can trust both now, and
forever. I don't expect hardware to be without fault, but the way a system
faults matters. Hardware should provide strong abstractions, but remain as
transparent as possible.

Many of these points are my philosophy, but not the reality of my hardware.  As
I've said, my setup is always changing, and I'll try to make choices based on
these topics.

### Computers / Hosts

- Lenovo ThinkPad X1 Carbon
- TODO: Desktop (need new motherboard)
- Raspberry Pi v3

### Additional Storage

- Private drive
- Git drive
- Backup drive
- Media drive


## Software

I'll do my best to explain in detail all the software involved in my setup,
but the fact is, it's never going to be possible. Between the highly dynamic
nature of software, and fact that there exists software I'm unaware of
operating on my machines. It's best to try to forget about that fact, but still
it haunts me.

Generally I'll *avoid* proprietary and closed software, as well as bloated and
ugly interfaces. I'll *seek* software that works, and maintains sane defaults.
I'll also *seek* software with good documentation.

### Bootloader

- [systemd-boot](https://www.freedesktop.org/wiki/Software/systemd/systemd-boot/)
is used primarily because it's much simpler than GRUB, and is part of the
systemd software group, which the rest of my installation uses.

### Operating System

- [Arch Linux](https://www.archlinux.org/) comes with a pretty small `base`
install group, and has a great package manager `pacman`. Being relativly popular
is also an advantage, as finding packages is pretty reliable.

### Window Manager

- [i3](https://i3wm.org/) is simple and keyboard-centric. Being a tiling WM
means I don't waste space or thought with overlapping windows normally.


### Terminal

- [Alacritty](https://github.com/jwilm/alacritty) is my primary terminal
emulator. It's fast, GPU accelerated, and written in Rust. However it's not
feature complete yet, and requires compiling from sources. For that reason I
also use,
- [Termite](https://github.com/thestinger/termite) a lightweight and functional
terminal.

### Internet

- [Lynx](https://lynx.invisible-island.net/) for when a graphical environment
isn't avalible.
- [Firefox](https://www.mozilla.org/en-US/firefox/) as my standard browser.
- [Chromium](https://www.chromium.org/Home) to test things in Google's browser.

### PDF

- [Zathura](https://pwmt.org/projects/zathura/) nuff said.

