#!/bin/bash

# Redfish emulator dependencies setup

set -e

source ~/bikolla/sushy-venv/bin/activate
pip install sushy-tools

sushy-emulator -i 192.168.33.3 --config ~/bikolla/sushy.conf
                                                       