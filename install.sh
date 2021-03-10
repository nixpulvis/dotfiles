#!/bin/bash
set -e

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

USER=$1

# TODO: Ensure root dotfiles have been installed before any other users.

install_nixpulvis() {
    useradd -m -G sudo -s /usr/bin/fish $USER
}

install_us() {
    useradd -m -s /usr/bin/oursh $USER
}

# Call the aproprite install script.
if ! "install/$USER"; then
    echo "${red}failed${reset}."
    exit 1
fi

