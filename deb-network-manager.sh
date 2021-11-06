#!/usr/bin/env bash
# wget -qO- https://git.io/JPDf5 | sudo sh

set -e

#variables
i_pkg="network-manager"
nm_conf="/etc/NetworkManager/NetworkManager.conf"

#install network-manager
sudo apt install --no-install-recommends --no-install-suggests -y ${i_pkg}

#exit if network-manager isn't installed
if [ $(dpkg-query -W -f='${Status}' ${i_pkg} | grep -q -P '^install ok installed$'; echo $?) != "0" ]; then
  echo "Unable to install ${i_pkg} , aborting."
  exit $1
fi

#let ifupdown manage network-manager
sudo mv ${nm_conf} ${nm_conf}.bak
sudo sed '/managed/s/false/true/' ${nm_conf}.bak > ${nm_conf}

#enable and restart networkmanager service
sudo systemctl enable NetworkManager.service
sudo systemctl restart NetworkManager.service

#reconnect networkmanager
sudo nmcli networking off && nmcli networking on

#enable networkmanager devices to make use of ifupdown, and fix "connected (externally)"
for d in $(nmcli -t dev | awk '/unmanaged/ && !/loopback/' | cut -f1 -d':'); do
  sudo nmcli dev set $d managed no;
  sudo nmcli dev set $d managed yes
done

#if network-manager is connected and working, remove dhcp
#if [ $(nmcli -t dev | grep -v "loopback" | grep -q -P "connected"; echo $?) = "0" ]; then
#  sudo apt autoremove --purge -y isc-dhcp-client isc-dhcp-common
#fi

#if network-manager is connected and working, disable /etc/network/interfaces
if [ $(nmcli -t dev | grep -v "loopback" | grep -q -P "connected"; echo $?) = "0" ]; then
  sudo mv /etc/network/interfaces /etc/network/interfaces.bak
  sudo systemctl daemon-reload
fi
