#!/usr/bin/env bash

# Fix machine-id issue with duplicate IP addresses being assigned
if [ -f /etc/machine-id ]; then
    truncate -s 0 /etc/machine-id
fi