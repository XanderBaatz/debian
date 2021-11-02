#!/bin/bash
# wget -qO- https://git.io/JPDf5 | sudo sh

set -e

#variables
_arch=$(dpkg --print-architecture)
ver_name=$(cat /etc/*-release | grep VERSION_CODENAME | cut -f2 -d'=')
i_pkg="linux-image-${_arch} firmware-linux firmware-linux-nonfree"

#update sources and check if backports are enabled
read -p "Do you want to continue? [Y/n] " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
		echo "You said no, aborting..."
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

echo "You said yes, continuing..."

if [ $(sudo apt update | grep "${ver_name}-backports"; echo $?) != "0" ]; then
  echo "Unable to install ${i_pkg} , aborting."
fi

#install network-manager
sudo apt install --no-install-recommends --no-install-suggests -y ${i_pkg}

#exit if network-manager isn't installed
