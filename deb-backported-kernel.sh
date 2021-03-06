#!/usr/bin/env bash
# wget -qO- https://git.io/JPyUg | sudo sh

set -e

#variables
_arch=$(dpkg --print-architecture)
ver_name=$(cat /etc/*-release | grep VERSION_CODENAME | cut -f2 -d'=')
repo_url=$(cat /etc/apt/sources.list | grep -o "deb http[^']\+${dist_name}" | head -1 | cut -f2 -d' ')
component="main contrib non-free"

#kernel and firmware to install from backports
i_pkg="linux-image-${_arch} firmware-linux firmware-linux-nonfree"

#if backports aren't enabled prompt to enable so the script can continue
#bp_check=$(egrep -v '^#|^ *$' /etc/apt/sources.list | grep -q ${ver_name}-backports; echo $?)
bp_check=$(egrep -v '^#|^ *$' /etc/apt/sources.list | grep -q ${ver_name}-backports; echo $?)
deb_check=$(egrep -v '^#|^ *$' /etc/apt/sources.list | grep -q ${ver_name}-; echo $?)
#$(cat /etc/apt/sources.list | grep "^[^#]" | grep)
#$(sudo apt update | grep "${ver_name}-backports"; echo $?)
if [ ${bp_check} != "0" ]; then
    echo "Debian ${ver_name}-backports not enabled."
fi

if [ ${deb_check} != "0" ]; then
    echo "Debian ${ver_name} is the release."
fi

#    read -p "Do you want to enable and continue? [Y/n] " -n 1 -r
#    echo
#    if [[ ! $REPLY =~ ^[Yy]$ ]]
#    then
#        echo "Abort."
#        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
#    else
#        sudo echo "deb ${repo_url} ${ver_name}-backports ${component}" >> /etc/apt/sources.list 2>&1 && \
#        sudo apt update -y
#    fi

#install backported kernel and firmware
#sudo apt install -t ${ver_name}-backports -y ${i_pkg}
