#!/bin/sh
# wget -qO- https://git.io/JX4sd | sudo sh

#rpm to deb conversion tools (temporary)
sudo apt install -y alien

#extensions in rpm
popshell="gnome-shell-extension-pop-shell"
wget -qO- https://rpmfind.net/linux/rpm2html/search.php?query=${popshell}&system=opensuse&arch=noarch \
| grep -Po "(?<=href=')[^']*.rpm" | head -1

#convert rpm package to deb
sudo alien -i ${popshell}*.rpm #sudo alien -d ${popshell}*.rpm && 
sudo apt autoremove --purge alien -y

#enable installed gnome extensions
for e in $(gnome-extensions list); do
  gnome-extensions enable $e
done
