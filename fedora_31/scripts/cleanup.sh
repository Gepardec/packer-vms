#!/usr/bin/env bash

set -e
set -x

if [ -f /etc/os-release ]; then
  # shellcheck disable=SC1091
  source /etc/os-release
  id=$ID
elif [ -f /etc/redhat-release ]; then
  id="$(awk '{ print tolower($1) }' /etc/redhat-release | sed 's/"//g')"
fi

if [[ $id == "fedora" ]]; then
  sudo dnf clean all
fi

#clear audit logs
if [ -f /var/log/audit/audit.log ]; then
  sudo bash -c "cat /dev/null > /var/log/audit/audit.log"
fi
if [ -f /var/log/wtmp ]; then
  sudo bash -c "cat /dev/null > /var/log/wtmp"
fi
if [ -f /var/log/lastlog ]; then
  sudo bash -c "cat /dev/null > /var/log/lastlog"
fi

#cleanup persistent udev rules
if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
  sudo rm /etc/udev/rules.d/70-persistent-net.rules
fi

#cleanup /tmp directories
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

#cleanup current ssh keys
sudo rm -f /etc/ssh/ssh_host_*

#reset hostname
sudo bash -c "cat /dev/null > /etc/hostname"

#cleanup shell history
history -w
history -c
