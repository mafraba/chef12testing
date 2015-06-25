# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "aserver" do |server|
    server.vm.box = "trusty64"
    server.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
    server.vm.hostname = "aserver"
    server.vm.network "public_network"
    server.vm.network "private_network", ip: "192.168.33.11"
    server.vm.provision :shell, path: "server-bootstrap.sh"
    server.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "4096"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
  end

  config.vm.define "aworks" do |ws|
    ws.vm.box = "trusty64"
    ws.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
    ws.vm.hostname = "aworks"
    ws.vm.network "private_network", ip: "192.168.33.12"
    ws.vm.provision :shell, path: "workstation-bootstrap.sh"
  end

#  config.vm.define "anode" do |node|
#    node.vm.box = "trusty64"
#    node.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
#    node.vm.hostname = "anode"
#    node.vm.network "private_network", ip: "192.168.33.13"
#  end

end
