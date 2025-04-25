#!/bin/bash

# Setup virtual machine

set -e

sudo dnf config-manager --enable devel
sudo dnf -y install libvirt qemu-kvm libvirt-devel virt-install
python3 -m venv sushy-venv
pip install libvirt-python
source sushy-venv/bin/activate

sudo usermod -aG libvirt $USER
sudo systemctl enable --now virtqemud
sudo systemctl enable --now virtstoraged
sudo systemctl enable --now virtnetworkd

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
