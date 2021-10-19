#!/bin/sh

set -e

# variables
dist_name=$(uname -n)
code_name=$(dpkg --status tzdata|grep Provides|cut -f2 -d'-')
repo_url=$(cat /etc/apt/sources.list | grep -o "http[^']\+${dist_name}" | head -1)
component="main contrib non-free"

# backup
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

# sources.list generation
sudo sh -c "cat << EOF > /etc/apt/sources.list
deb ${repo_url} stable ${component}
deb-src ${repo_url} stable ${component}

deb http://security.debian.org/ stable-security ${component}
deb-src http://security.debian.org/ stable-security ${component}

deb ${repo_url} stable-updates ${component}
deb-src ${repo_url} stable-updates ${component}

deb ${repo_url} ${code_name}-backports ${component}
EOF"

# update sources
sudo apt update
