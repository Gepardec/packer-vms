#!/usr/bin/env bash

set -e
set -x

# Fix machine-id issue with duplicate IP addresses being assigned
if [ -f /etc/machine-id ]; then
    sudo truncate -s 0 /etc/machine-id
fi
