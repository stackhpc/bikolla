#!/bin/bash

# Enroll baremetal machine

set -e
python3 -m venv os-venv
source os-venv/bin/activate
pip install -U pip
pip install -U setuptools
pip install python-openstackclient python-ironicclient python-ironic-inspector-client

openstack baremetal node create \
--driver redfish \
--driver-info redfish_system_id=$1 \
--driver-info redfish_address="http://192.168.33.3:8000" \
--driver-info ipmi_address="http://192.168.33.3:8000" \
--name test-vm

openstack baremetal node manage test-vm
