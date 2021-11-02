#!/bin/bash
# wget -qO- https://git.io/Jily6 | sudo sh

set -e

#check package: network-manager
i_pkg="network-manager"

#install network-manager
sudo apt install --no-install-recommends --no-install-suggests -y ${i_pkg}

#exit if network-manager isn't installed
if [ $(dpkg-query -W -f='${Status}' ${i_pkg} | grep -q -P '^install ok installed$'; echo $?) != "0" ]; then
  echo "Unable to install ${i_pkg} , aborting."
  exit $1
fi

#let ifupdown manage network-manager
sudo mv /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf.bak
sudo sed '/managed/s/false/true/' /etc/NetworkManager/NetworkManager.conf.bak > /etc/NetworkManager/NetworkManager.conf

#enable and restart networkmanager service
sudo systemctl enable NetworkManager.service
sudo systemctl restart NetworkManager.service

#enable networkmanager devices to make use of ifupdown, and fix "connected (externally)"
for d in $(nmcli -t dev | awk '/unmanaged/ && !/loopback/' | cut -f1 -d':'); do
  sudo nmcli dev set $d managed yes
done

#disable networkd
#for s in $(systemctl | grep "systemd-networkd." | awk '{print $1}'); do
#  sudo systemctl disable $s;
#  sudo systemctl mask $s;
#  sudo systemctl stop $s
#done

#reload system daemon (services etc.)
sudo systemctl daemon-reload
