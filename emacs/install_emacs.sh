#!/bin/bash

# Get OS name
SYSTEM=`uname -s`

FSHOME="/cephfs/xunsong.li"
DOTFILES=$HOME/dotfiles

# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if command -v tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
fi

printf "${BLUE} ➜  Installing Emacs...${NORMAL}\n"

if ! command -v add-apt-repository >/dev/null 2>&1; then
   sudo apt install update
   sudo apt install software-properties-common
fi

sudo add-apt-repository -y ppa:kelleyk/emacs
sudo apt-get update
sudo apt-get install -y emacs27

# Prepare chenbin's config
# Now this script is used for company servers, so
# we have manually put the config files on file system.
rm -r $HOME/.emacs.d

cd $HOME
cp $FSHOME/emacs.d-stable.zip ./
unzip emacs.d-stable.zip
mv emacs.d-stable $HOME/.emacs.d

# Prepare myelpa (local mirror of packages)
cp $FSHOME/myelpa-stable.zip ./
unzip myelpa-stable.zip
mv myelpa-stable $HOME/myelpa
## Uncomment the line containing “myelpa” in lisp/init-elpa.el.
sed -i 's/^;;\(.*myelpa.*\)/\1/' .emacs.d/lisp/init-elpa.el

# add my custom tweaks for chenbin's config
mv $HOME/.custom.el $HOME/.custom.el.bak
cp $DOTFILE/emacs/.custom.el $HOME/.custom.el

printf "${GREEN} ➜  Install Emacs Successfully...${NORMAL}\n"