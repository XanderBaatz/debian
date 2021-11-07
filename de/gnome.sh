#!/usr/bin/env bash
# wget -qO- https://git.io/????? | sudo sh

set -e

#variables
_arch=$(dpkg --print-architecture)
ver_name=$(cat /etc/*-release | grep VERSION_CODENAME | cut -f2 -d'=')
repo_url=$(cat /etc/apt/sources.list | grep -o "deb http[^']\+${dist_name}" | head -1 | cut -f2 -d' ')
component="main contrib non-free"




sudo apt update -y && sudo apt upgrade -y

#install the packages required for "add-apt-repository"
sudo apt install  -y \
software-properties-common

#add popos repositories
#sudo add-apt-repository ppa:system76/pop -y && sudo apt-get update -y && sudo apt upgrade -y

#xorg and libinput
sudo apt install --no-install-recommends --no-install-suggests -y \
xinit \
xserver-xorg-input-libinput

#gnome de
sudo apt install --no-install-recommends --no-install-suggests -y \
gnome-session \
gnome-control-center \
gnome-terminal \
gnome-tweak-tool \
xdg-user-dirs \
gdm3 \
gnome-keyring \
nautilus \
breeze-cursor-theme

#pop shell tiling and other extensions
sudo apt install --no-install-recommends --no-install-suggests -y \
pop-shell \
gnome-shell-extension-appindicator

#reload system daemon (services etc.)
sudo systemctl daemon-reload

#enable installed gnome extensions
for e in $(gnome-extensions list); do
  gnome-extensions enable $e
done


#extensions
popshell="gnome-shell-extension-pop-shell"
wget -qO- https://rpmfind.net/linux/rpm2html/search.php?query=${popshell}&system=opensuse&arch=noarch \
| grep -Po "(?<=href=')[^']*.rpm" | head -1




echo ""
echo "Please reboot to finish the installation."
echo ""
