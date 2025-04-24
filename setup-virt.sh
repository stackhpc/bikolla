#!/bin/bash

# Setup virtual machine

set -e

tmpfile=$(mktemp /tmp/sushy-domain.XXXXXX)
sudo virt-install \
   --name vbmc-node \
   --ram 1024 \
   --disk size=20 \
   --vcpus 2 \
   --os-type linux \
   --os-variant ubuntu24.04 \
   --graphics vnc \
   --print-xml > $tmpfile
sudo virsh define --file $tmpfile
rm $tmpfile
