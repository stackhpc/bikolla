#!/bin/bash

set -e

if ! ip l show breth1 >/dev/null 2>&1; then
    sudo ip l add breth1 type bridge
fi
sudo ip l set breth1 up
if ! ip a show breth1 | grep 192.168.33.3/24; then
    sudo ip a add 192.168.33.3/24 dev breth1
fi
if ! ip l show dummy1 >/dev/null 2>&1; then
    sudo ip l add dummy1 type dummy
fi
sudo ip l set dummy1 up
sudo ip l set dummy1 master breth1

sudo dnf -y install wget python-devel libffi-devel gcc openssl-devel dbus-devel dbus-glib-devel

if [[ ! -f ~/.ssh/id_rsa ]]; then
  ssh-keygen  -f ~/.ssh/id_rsa -t rsa -N ''
fi
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys 

if [[ ! -d ./kolla-ansible ]]; then
  git clone https://github.com/openstack/kolla-ansible -b stable/2024.1
fi
python3 -m venv kolla-venv
source kolla-venv/bin/activate
pip install -U pip
pip install -U setuptools
pip install ./kolla-ansible
pip install ansible docker dbus-python
ansible-galaxy install -r ./kolla-ansible/requirements.yml

sudo mkdir -p /etc/kolla
sudo chown $USER: -R /etc/kolla/
cp -r etc/kolla/* /etc/kolla/
mkdir -p /etc/kolla/config/ironic

if [[ ! -d /etc/kolla/config/ironic/ironic-agent.initramfs ]]; then
  wget -O /etc/kolla/config/ironic/ironic-agent.initramfs https://tarballs.openstack.org/ironic-python-agent/tinyipa/files/tinyipa-master.gz
fi
if [[ ! -d /etc/kolla/config/ironic/ironic-agent.kernel ]]; then
  wget -O /etc/kolla/config/ironic/ironic-agent.kernel https://tarballs.openstack.org/ironic-python-agent/tinyipa/files/tinyipa-master.vmlinuz
fi

if [[ ! -e /etc/kolla/passwords.yml ]]; then
  cp kolla-venv/share/kolla-ansible/etc_examples/kolla/passwords.yml /etc/kolla/
  kolla-genpwd
fi
ssh-keyscan 127.0.0.1 >> ~/.ssh/known_hosts
kolla-ansible -i /etc/kolla/inventory/all-in-one bootstrap-servers
sudo usermod -aG docker $USER

if ! groups | grep docker >/dev/null; then
  echo "Please log out then log back in to pick up Docker group membership"
  echo "After this, run kolla-deploy.sh"
else
  echo "Now run kolla-deploy.sh"
fi
