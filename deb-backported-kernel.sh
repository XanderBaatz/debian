#!/bin/bash
# wget -qO- https://git.io/JPDf5 | sudo sh

set -e

#variables
_arch=$(dpkg --print-architecture)
i_pkg="linux-image-${_arch} firmware-linux firmware-linux-nonfree"
nm_conf="/etc/NetworkManager/NetworkManager.conf"

#install network-manager
sudo apt install --no-install-recommends --no-install-suggests -y ${i_pkg}

#exit if network-manager isn't installed
if [ $(dpkg-query -W -f='${Status}' ${i_pkg} | grep -q -P '^install ok installed$'; echo $?) != "0" ]; then
  echo "Unable to install ${i_pkg} , aborting."
  exit $1
fi


