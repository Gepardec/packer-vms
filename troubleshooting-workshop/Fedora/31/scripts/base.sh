#!/usr/bin/env bash

set -e
set -x

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
    if [[ $os_version_id -lt 30 ]]; then
        sudo dnf -y install python-devel python-dnf
    else
        sudo dnf -y install initscripts python-devel python3-dnf
    fi
fi
  
# Fix machine-id issue with duplicate IP addresses being assigned
if [ -f /etc/machine-id ]; then
    sudo truncate -s 0 /etc/machine-id
fi