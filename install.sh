#!/bin/bash
set -e

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

USER=$1

# TODO: Ensure root dotfiles have been installed before any other users.

install_nixpulvis() {
    # TODO: sudo group?
    useradd -m -G wheel -s /usr/bin/fish $USER
}

install_us() {
    # TODO: sudo group?
    useradd -m -s /usr/bin/oursh $USER
}

# Call the aproprite install script.
if ! "install/$USER"; then
    echo "${red}failed${reset}."
    exit 1
fi

