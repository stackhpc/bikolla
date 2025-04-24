#!/bin/bash

# Redfish emulator dependencies setup

set -e

sudo dnf config-manager --enable devel
sudo dnf -y install libvirt qemu-kvm libvirt-devel virt-install
python3 -m venv sushy-venv
pip install libvirt-python sushy-tools
source sushy-venv/bin/activate

sudo usermod -aG libvirt $USER
sudo systemctl enable --now virtqemud
sudo systemctl enable --now virtstoraged
sudo systemctl enable --now virtnetworkd

sushy-emulator -i 192.168.33.3 --config ~/bikolla/sushy.conf
