# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.7.0"

Vagrant.configure(2) do |config|

  config.vm.box = "l33tch/docker2registry"
  config.ssh.username ="docker"

  config.vm.box_check_update = true

  config.vm.network "public_network",  adapter: 2, bridge: 'en0: Ethernet 1', ip: "172.16.16.15"
  #config.vm.network "private_network", adapter: 3, ip: "192.168.100.10" 

  config.vm.network "forwarded_port", guest: 2379, host: 2379
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.network "forwarded_port", guest: 53, host: 53, protocol: 'udp'
  config.vm.network "forwarded_port", guest: 67, host: 67, protocol: 'udp'
  config.vm.network "forwarded_port", guest: 68, host: 68, protocol: 'udp'
  config.vm.network "forwarded_port", guest: 69, host: 69, protocol: 'udp'
  
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "data/" , "/vagrant_data", disabled: false
  #config.vm.synced_folder "data/" , "/vagrant_data", disabled: false, :nfs true, nfs_version: 4, :mount_options 'rw,rsize=32768,wsize=32768,intr,hard,vers=3,bg,udp,noatime,nolock'

  config.vm.provider :virtualbox do |vb, override|
    #vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    #vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
    #vb.customize ["modifyvm", :id, "--nictype3", "virtio"]
    vb.memory = 2048  # default memory size is 2048
    vb.cpus = 2       # default cpus is 2
    vb.customize ["controlvm", :id, "nicpromisc2", "allow-all"]
  end
end
