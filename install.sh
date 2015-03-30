#! /usr/bin/env bash
#======= SETTINGS =======#
DOTFILES_REPO=https://github.com/tillmd/dotfiles.git
DOTFILES=$HOME/.dotfiles
SSH_KEY=$HOME/.ssh/id_rsa

#==== END OF SETTINGS ===#
set -e

#======== HELPERS =======#
fancy_echo() {
printf "%b" "$1"
}
test_command() {
type $1 1>/dev/null 2>&1 || { echo >&2 "No such file [ $1 ]"; exit 1; }
}

#=======================#
# 1. sytem update
# TODO Remove amazon
#      Add repository
#      for i in application.txt
# fancy_echo "Updating system software...\n"
# sudo apt-get update -y

# 2. clone and link dotfiles
# fancy_echo "Checking dotfiles directory [ $DOTFILES ]..."
# [ -d $DOTFILES ] && echo "OK" || git clone $DOTFILES_REPO $DOTFILES
fancy_echo "Linking dotfiles... "
[ -x $DOTFILES/link.sh ] && $DOTFILES/link.sh && echo "OK"

