#!/bin/bash

set -e

docker ps || (echo "Cannot communicate with docker engine. Have you logged out and back in?"; exit 1)
source kolla-venv/bin/activate
kolla-ansible -vv -i /etc/kolla/inventory/all-in-one prechecks -e ansible_python_interpreter=~/bikolla/kolla-venv/bin/python
kolla-ansible -vv -i /etc/kolla/inventory/all-in-one pull -e ansible_python_interpreter=~/bikolla/kolla-venv/bin/python 
kolla-ansible -vv -i /etc/kolla/inventory/all-in-one deploy -e ansible_python_interpreter=~/bikolla/kolla-venv/bin/python
kolla-ansible -vv -i /etc/kolla/inventory/all-in-one post-deploy -e ansible_python_interpreter=~/bikolla/kolla-venv/bin/python

