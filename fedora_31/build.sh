#! /usr/bin/env bash
start=$(date)
hpacker build fedora_31.json
echo "START: ${start}"
echo "END: $(date)"
