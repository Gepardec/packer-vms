#!/usr/bin/env bash

set -x

if [ "$PACKER_BUILDER_TYPE" != "virtualbox-iso" ]; then
    exit 0
fi

if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    id=$ID
    os_version_id=$VERSION_ID
    
elif [ -f /etc/redhat-release ]; then
    id="$(awk '{ print tolower($1) }' /etc/redhat-release | sed 's/"//g')"
    os_version_id="$(awk '{ print $3 }' /etc/redhat-release | sed 's/"//g' | awk -F. '{ print $1 }')"
fi

if [[ $id == "ol" ]]; then
    os_version_id_short="$(echo $os_version_id | cut -f1 -d".")"
else
    os_version_id_short="$(echo $os_version_id | cut -f1-2 -d".")"
fi
if [[ $id == "fedora" ]]; then
    sudo dnf -y install gcc kernel-devel-"$(uname -r)" kernel-headers-"$(uname -r)" dkms make bzip2 perl && \
    sudo dnf -y groupinstall "Development Tools"
    if [[ $os_version_id -ge 28 ]]; then
        sudo dnf -y remove virtualbox-guest-additions
    fi
fi

if [ -f /home/gepard/VBoxGuestAdditions.iso ]; then
    sudo rm -rf /home/gepard/VBoxGuestAdditions.iso
elif [ -f /root/VBoxGuestAdditions.iso ]; then
    sudo rm -rf /root/VBoxGuestAdditions.iso
fi
