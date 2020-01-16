#!/usr/bin/env bash

set -e
set -x

if [ "$PACKER_BUILDER_TYPE" != "vmware-iso" ]; then
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
    if [ -f /etc/vmware_desktop ]; then
        sudo dnf -y install open-vm-tools-desktop
    else
        sudo dnf -y install open-vm-tools
    fi
    sudo /bin/systemctl restart vmtoolsd.service
fi
