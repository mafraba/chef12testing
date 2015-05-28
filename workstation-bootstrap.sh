#!/usr/bin/env bash

apt-get update
apt-get upgrade -y
sudo locale-gen es_ES.UTF-8

# Ensure that the Server is Accessible by Hostname
sudo echo "192.168.33.11 192.168.33.11 aserver" >> /etc/hosts
sudo echo "192.168.33.12 192.168.33.12 aworks" >> /etc/hosts
sudo echo "192.168.33.13 192.168.33.13 anode" >> /etc/hosts

# Get and install Chef DK
if [ ! -f /vagrant/pkgs/chefdk_0.6.0-1_amd64.deb ]; then
    wget -O /vagrant/pkgs/chefdk_0.6.0-1_amd64.deb https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.6.0-1_amd64.deb
fi
cp /vagrant/pkgs/chefdk_*.deb .
sudo dpkg -i chefdk_*.deb
chef verify
rm chefdk_*.deb

# Use the Chef development kit version of Ruby
echo 'Setting system ruby'
echo 'eval "$(chef shell-init bash)"' >> /etc/profile
