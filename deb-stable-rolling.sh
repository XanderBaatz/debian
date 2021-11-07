#!/usr/bin/env bash
# wget -qO- https://git.io/JPjey | sudo sh
# https://www.linuxcapable.com/how-to-install-or-upgrade-to-linux-kernel-5-14-on-debian-11-bullseye/

set -e

#variables
_arch=$(dpkg --print-architecture)
dist_name=$(uname -n)
ver_name=$(cat /etc/*-release | grep VERSION_CODENAME | cut -f2 -d'=')
#repo_url=$(cat /etc/apt/sources.list | grep -o "deb http[^']\+${dist_name}" | head -1 | cut -f2 -d' ')
component="main contrib non-free"

#repository URLs
repo_url="http://deb.debian.org/"
security_url="http://security.debian.org/"

#kernel and firmware to install from newer repositories
i_pkg="linux-image-${_arch} firmware-linux firmware-linux-nonfree"

# backup
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
#if exists, copy:
#sudo cp /etc/apt/preferences /etc/apt/preferences.bak

# sources.list generation
sudo sh -c "cat << EOF > /etc/apt/sources.list
deb ${repo_url} ./stable ${component}
deb-src ${repo_url} ./stable ${component}

deb ${security_url} ./stable-security ${component}
deb-src ${security_url} ./stable-security ${component}

deb ${repo_url} ./stable-updates ${component}
deb-src ${repo_url} ./stable-updates ${component}

deb ${repo_url} ./stable-backports ${component}
deb-src ${repo_url} ./stable-backports ${component}
EOF"

# apt preferences setup
sudo sh -c "cat << EOF > /etc/apt/preferences
Package: *
Pin: release a=stable
Pin-Priority: 500

Package: *
Pin: release a=stable-backports
Pin-Priority: 100

#######################

Package: linux-image-* firmware-*
Pin: release a=stable-backports
Pin-Priority: 1000
EOF"

#install packages
sudo sh -c "apt update -y && apt upgrade -y"
sudo apt install -y --install-recommends ${i_pkg}
