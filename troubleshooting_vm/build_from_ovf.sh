#! /usr/bin/env bash
start=$(date)
hpacker build troubleshooing_vm.json
echo "START: ${start}"
echo "END: $(date)"
