#!/bin/bash -ex

vagrant destroy -f
vagrant box list | grep gepardec-containerization
vagrant box remove --force $(vagrant box list | grep gepardec-containerization | awk '{print $1}')
packer build -var 'version=1.2.0' -force box-config.json