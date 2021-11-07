#!/bin/sh
# wget -qO- https://git.io/JX4sd | sudo sh

#rpm to deb conversion tools (temporary)
sudo apt install -y alien

#extensions in rpm
#popshell="gnome-shell-extension-pop-shell"
#rpm_get="$(wget -qO- "https://rpmfind.net/linux/rpm2html/search.php?query=${popshell}&system=opensuse&arch=noarch" | grep -Po "(?<=href=')[^']*.rpm" | head -1)"
#wget -N https://rpmfind.net${rpm_get}

#extensions in rpm
gnome_ext="gnome-shell-extension-pop-shell"
rpm_get="$(wget -qO- "https://rpmfind.net/linux/rpm2html/search.php?query=${gnome_ext}&system=opensuse&arch=noarch" | grep -Po "(?<=href=')[^']*.rpm" | head -1)"
wget -N https://rpmfind.net${rpm_get}

#convert rpm package to deb
sudo alien -i ${gnome_ext}*.rpm #sudo alien -d ${popshell}*.rpm && 
sudo apt autoremove --purge alien -y

#enable installed gnome extensions
for e in $(gnome-extensions list); do
  gnome-extensions enable $e
done
