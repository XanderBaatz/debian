#!/bin/bash
# wget -qO- https://git.io/JPDf5 | sudo sh

set -e

#variables
_arch=$(dpkg --print-architecture)
ver_name=$(cat /etc/*-release | grep VERSION_CODENAME | cut -f2 -d'=')
i_pkg="linux-image-${_arch} firmware-linux firmware-linux-nonfree"
nm_conf="/etc/NetworkManager/NetworkManager.conf"

#update sources and check if backports are enabled
if [ $(sudo apt update | grep "${ver_name}-backports"; echo $?) != "0" ]; then
  echo "Unable to install ${i_pkg} , aborting."
  exit $1
fi

#install network-manager
sudo apt install --no-install-recommends --no-install-suggests -y ${i_pkg}

#exit if network-manager isn't installed
