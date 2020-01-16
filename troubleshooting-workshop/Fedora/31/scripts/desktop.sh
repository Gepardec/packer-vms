#!/usr/bin/env bash

set -e
set -x

USERNAME=gepard

if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    id=$ID
    os_version_id=$VERSION_ID
    
elif [ -f /etc/redhat-release ]; then
    id="$(awk '{ print tolower($1) }' /etc/redhat-release | sed 's/"//g')"
    os_version_id="$(awk '{ print $3 }' /etc/redhat-release | sed 's/"//g' | awk -F. '{ print $1 }')"
fi
if [[ $id == "fedora" ]]; then
    sudo dnf -y groupinstall "Basic Desktop"
    sudo dnf -y install gnome-classic-session gnome-terminal \
    nautilus-open-terminal control-center liberation-mono-fonts
    sudo ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target
    GDM_CUSTOM_CONFIG=/etc/gdm/custom.conf
    sudo mkdir -p "$(dirname ${GDM_CUSTOM_CONFIG})"
    sudo bash -c "echo "[daemon]" > $GDM_CUSTOM_CONFIG"
    sudo bash -c "echo "# Enabling automatic login" >> $GDM_CUSTOM_CONFIG"
    sudo bash -c "echo "AutomaticLoginEnable=True" >> $GDM_CUSTOM_CONFIG"
    sudo bash -c "echo "AutomaticLogin=${USERNAME}" >> $GDM_CUSTOM_CONFIG"
    LIGHTDM_CONFIG=/etc/lightdm/lightdm.conf
    echo "==> Configuring lightdm autologin"
    sudo bash -c "echo "[SeatDefaults]" > $LIGHTDM_CONFIG"
    sudo bash -c "echo "autologin-user=${USERNAME}" >> $LIGHTDM_CONFIG"
fi

# We need to create artifact to trigger open-vm-tools-desktop install
if [ "$PACKER_BUILDER_TYPE" = "vmware-iso" ]; then
    sudo touch /etc/vmware_desktop
    
elif [ "$PACKER_BUILDER_TYPE" = "virtualbox-iso" ]; then
    sudo touch /etc/virtualbox_desktop
fi
