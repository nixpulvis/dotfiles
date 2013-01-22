# . : . dotfiles

I wanted to write my own dotfiles to allow myself some freedom of implementation
I like a lot of what I've seen out there, but none of them are quite the way
I'd do it. Due to the nature of dotfiles, these are a compilation of a lot of
other peoples work, with some of my own work as well. I'll do my best to source
the original authors as best as possible.

## Inspiration

I was using Mathias's dotfiles for a while, and his `.osx` file is perfection.

* [Zach Holman's dotfiles](https://github.com/holman/dotfiles)
* [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles)

## Organization

The structure of my dotfiles is what I feel distinguishes it from the rest.
It's simple and easy to follow.

    .
    |- bin
    |- symlinks
    |- brews
    |- gems
    |- zsh
    |- lib


#### bin

This directory will be added to `PATH` so all programs inside are available.
Simple and awesome.


#### symlinks

Every one of these files will be linked to `~/`. For example:

    ~/.gitconfig -> symlinks/gitconfig
    ~/.hushlogin -> symlinks/.hushlogin

Notice it doesn't matter if you put the dot in front of the filename.


#### brews

These files should be plain text files.

###### Example:

    ack
    libyaml
    zsh

All files in `brews` get concatenated and then `brew install #{line}`
Already installed errors are suppressed.


#### gems

Just like `brews`. Runs `gem install #{line}`


#### zsh

All files in this directory get sourced in every shell.

## Todo
These dotfiles currently work well on my mac, and work (not as well) on a fedora box I use at school.
I'd like to make them more portable, so on as many systems as possable I can install git,
`git clone https://github.com/nathan/dotfiles.git`, run the bootstrap and be off and running.

Currently I'm working on making this work with a raw debian (wheezy) install, with squeeze comming next.
