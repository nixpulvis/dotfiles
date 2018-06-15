#!/bin/bash
set -e

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

USER=$1

# Ensure root dotfiles have been installed before any other users.
if [[ ! -f /root/.dotfiles ]] && [[ "$USER" != "root" ]]; then
    echo "You must first run \`./install root\`."
    exit 1
fi

# Create the user (if needed).
if ! id -u $USER &> /dev/null; then
    # TODO: flag for sudo group.
    useradd -m -G wheel -s /usr/bin/fish $USER
fi

# Call the aproprite install script.
if ! "install/$USER"; then
	echo "${red}failed${reset}."
	exit 1
fi

# Indicate we've install the dotfiles for $USER.
if [[ "$USER" == "root" ]]; then
    touch /root/.dotfiles
else
    touch /home/$USER/.dotfiles
fi

