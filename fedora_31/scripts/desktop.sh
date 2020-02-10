#!/usr/bin/env bash

set -e
set -x

sudo dnf -y groupinstall xfce
sudo ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target

#install some useful stuff
sudo dnf -y install firefox gedit unzip zip net-tools

# We need to create artifact to trigger open-vm-tools-desktop install
if [ "$PACKER_BUILDER_TYPE" = "vmware-iso" ]; then
    sudo touch /etc/vmware_desktop
    
elif [ "$PACKER_BUILDER_TYPE" = "virtualbox-iso" ]; then
    sudo touch /etc/virtualbox_desktop
fi
