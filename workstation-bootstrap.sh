#!/usr/bin/env bash

apt-get update
apt-get upgrade -y
sudo locale-gen es_ES.UTF-8

# Ensure that the Server is Accessible by Hostname
sudo echo "192.168.33.11 192.168.33.11 aserver" >> /etc/hosts
sudo echo "192.168.33.12 192.168.33.12 aworks" >> /etc/hosts
sudo echo "192.168.33.13 192.168.33.13 anode" >> /etc/hosts

# TO-DO Get and install Chef DK


