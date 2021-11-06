#!/usr/bin/env bash
# wget -qO- https://git.io/????? | sudo sh

set -e

#variables
_arch=$(dpkg --print-architecture)
ver_name=$(cat /etc/*-release | grep VERSION_CODENAME | cut -f2 -d'=')
repo_url=$(cat /etc/apt/sources.list | grep -o "deb http[^']\+${dist_name}" | head -1 | cut -f2 -d' ')
component="main contrib non-free"
