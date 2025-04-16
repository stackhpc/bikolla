#!/bin/bash

# Enroll baremetal machine

set -e
export OS_CLOUD=bifrost

python3 -m venv os-venv
source os-venv/bin/activate
pip install -U pip
pip install -U setuptools
pip install python-openstackclient python-ironicclient python-ironic-inspector-client

INTERFACE=${INTERFACE:-breth1}
IP=$(ip a show dev $INTERFACE | grep 'inet ' | awk '{ print $2 }' | sed 's/\/.*//g')

if [[ ! -f ~/.config/openstack/clouds.yaml ]]; then
    mkdir -p ~/.config/openstack
    cat << EOF | sudo tee ~/.config/openstack/clouds.yaml
---
clouds:
  bifrost:
    auth_type: "none"
    endpoint: http://$IP:6385
  bifrost-inspector:
    auth_type: "none"
    endpoint: http://$IP:5050
EOF
fi

openstack baremetal node create \
--driver redfish \
--driver-info redfish_system_id=$1 \
--driver-info redfish_address="http://192.168.33.3:8000" \
--driver-info ipmi_address="http://192.168.33.3:8000" \
--name test-vm

openstack baremetal node manage test-vm
