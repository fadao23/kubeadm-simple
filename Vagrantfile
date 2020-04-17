# -*- mode: ruby -*-
# vi:set ft=ruby sw=2 ts=2 sts=2:

# Define the number of master and worker nodes
# If this number is changed, remember to update setup-hosts.sh script with the new hosts IP details in /etc/hosts of each VM.
NUM_MASTER_NODE = 1
NUM_WORKER_NODE = 1

IP_NW = "192.168.6."
MASTER_IP_START = 10
NODE_IP_START = 20

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
  config.vm.box = "mbigras/ubuntu-18.04"
  config.vm.box_version = "0.0.1"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = true

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Provision Master Nodes
  (1..NUM_MASTER_NODE).each do |i|
      config.vm.define "master-#{i}" do |node|
        # Name shown in the GUI
        node.vm.provider "virtualbox" do |vb|
            vb.name = "kubernetes-master-#{i}"
            vb.memory = 2048
            vb.cpus = 2
        end
        node.vm.hostname = "master-#{i}"
        node.vm.network :private_network, ip: IP_NW + "#{MASTER_IP_START + i}"
        node.vm.network "forwarded_port", guest: 22, host: "#{2810 + i}"

        node.vm.provision "setup-hosts", :type => "shell", :path => "config/vagrant/setup-hosts.sh" do |s|
          s.args = ["eth1"]
        end

        node.vm.provision ! "setup-kubeadm", :type => "shell", :path => 'config/install-kubeadm.sh'
        node.vm.provision ! "setup-master", :type => "shell", :path => 'config/config-master.sh'
        node.vm.provision ! "setup-network", :type => "shell", :path => 'config/install-cli.sh'
        node.vm.provision "setup-dns", type: "shell", :path => "config/update-dns.sh"

      end
  end

  # Provision Worker Nodes
  (1..NUM_WORKER_NODE).each do |i|
    config.vm.define "worker-#{i}" do |node|
        node.vm.provider "virtualbox" do |vb|
            vb.name = "kubernetes-worker-#{i}"
            vb.memory = 512
            vb.cpus = 1
        end
        node.vm.hostname = "worker-#{i}"
        node.vm.network :private_network, ip: IP_NW + "#{NODE_IP_START + i}"
		node.vm.network "forwarded_port", guest: 22, host: "#{2820 + i}"

        node.vm.provision "setup-hosts", :type => "shell", :path => "config/vagrant/setup-hosts.sh" do |s|
          s.args = ["eth1"]
        end

        node.vm.provision "setup-dns", type: "shell", :path => "config/update-dns.sh"
        node.vm.provision "allow-bridge-nf-traffic", :type => "shell", :path => "config/allow-bridge-nf-traffic.sh"
        node.vm.provision ! "setup-kubeadm", :type => "shell", :path => 'config/install-kubeadm.sh'

    end
  end
end