# -*- mode: ruby -*-
# vi:set ft=ruby sw=2 ts=2 sts=2:

# Define the number of master and worker nodes
# If this number is changed, remember to update setup-hosts.sh script with the new hosts IP details in /etc/hosts of each VM.
NUM_SERVER_CLIENT = 1
NUM_WORKER_CLIENT = 3

IP_NW = "192.168.56."
SERVER_IP_START = 10
CLIENT_IP_START = 20

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  # config.vm.box = "base"
  config.vm.box = "bento/ubuntu-22.04-arm64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Provision Master Nodes
  (1..NUM_SERVER_CLIENT).each do |i|
    config.vm.define "server-#{i}" do |node|
      # Name shown in the GUI
      node.vm.provider "virtualbox" do |vb|
        vb.name = "nomad-server-#{i}"
        vb.memory = 1024
        vb.cpus = 1
      end
      node.vm.hostname = "server-#{i}"
      node.vm.network :private_network, ip: IP_NW + "#{SERVER_IP_START + i}"
      node.vm.network "forwarded_port", guest: 22, host: "#{2710 + i}"
      node.vm.provision "shell", path: "bootstrap.sh", args: ["server"]
      node.vm.provision "shell", path: "server.sh"
    end
  end

  # Provision Worker Nodes
  (1..NUM_WORKER_CLIENT).each do |i|
    config.vm.define "worker-#{i}" do |node|
      node.vm.provider "virtualbox" do |vb|
        vb.name = "nomad-worker-#{i}"
        vb.memory = 1024
        vb.cpus = 1
      end
      node.vm.hostname = "worker-#{i}"
      node.vm.network :private_network, ip: IP_NW + "#{CLIENT_IP_START + i}"
      node.vm.network "forwarded_port", guest: 22, host: "#{2720 + i}"
      node.vm.provision "shell", path: "bootstrap.sh", args: ["client"]
    end
  end
end
