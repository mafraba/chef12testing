#!/usr/bin/env bash

sudo apt-get update
sudo apt-get upgrade -y
sudo locale-gen es_ES.UTF-8

# Ensure that the Server is Accessible by Hostname
# sudo echo "127.0.1.1 192.168.33.11 aserver" > /etc/hosts
sudo echo "127.0.0.1 localhost" > /etc/hosts
sudo echo "192.168.33.11 aserver" >> /etc/hosts
sudo echo "192.168.33.12 aworks" >> /etc/hosts
sudo echo "192.168.33.13 anode" >> /etc/hosts

echo "Hostname:"
echo `hostname -f`

# Get and install Chef server
if [ ! -f /vagrant/pkgs/chef-server-core_12.4.1-1_amd64.deb ]; then
  mkdir -p /vagrant/pkgs
  wget -O /vagrant/pkgs/chef-server-core_12.4.1-1_amd64.deb https://packagecloud.io/chef/stable/packages/ubuntu/trusty/chef-server-core_12.4.1-1_amd64.deb/download
fi
cp /vagrant/pkgs/chef-server-core_*.deb .
sudo dpkg -i chef-server-core_*.deb
sudo chef-server-ctl reconfigure
rm chef-server-core_*.deb

# Create an Admin User and Organization
sudo chef-server-ctl user-create admin admin admin admin@example.com examplepass -f admin.pem
sudo chef-server-ctl org-create acme "ACME" --association_user admin -f acme-validator.pem

# Copy pivotal.pem to /vagrant, so that we can easily retrieve it from the workstation
sudo /bin/cp -f /etc/opscode/pivotal.pem /vagrant
