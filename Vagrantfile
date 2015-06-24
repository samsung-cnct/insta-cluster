# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">= 1.7.2"

COREOS_CHANNEL="alpha"
COREOS_RELEASE="current"
IMAGE_PATH="data/dnsmasq/tftpboot"
DATA_PATH="data/"



MASTER_USER_DATA = File.expand_path(File.join(File.expand_path(File.dirname(__FILE__)), 'master.yaml'))
NODE_USER_DATE = File.expand_path(File.join(File.expand_path(File.dirname(__FILE__)), 'node.yaml'))
Vagrant.configure(2) do |config|

  config.vm.define "master" do |master|

    master.vm.box = "http://#{COREOS_CHANNEL}.release.core-os.net/amd64-usr/#{COREOS_RELEASE}/coreos_production_vagrant.box"

    master.vm.box_check_update = true

    master.ssh.insert_key = false

    master.vm.network "public_network", adapter: 2, bridge: 'en0: Ethernet 1', ip: "172.16.16.15"
    master.vm.network "private_network", adapter: 3, ip: "192.168.100.10" 

    master.vm.network "forwarded_port", guest: 2375, host: 2375

    master.vm.hostname = "master"
    
    master.vm.synced_folder ".", "/vagrant", disabled: false, type: "nfs", nfs_udp: true, mount_options: ['rsize=32768', 'wsize=32768', 'nolock']
    #config.vm.synced_folder "data/" , "/vagrant_data", disabled: false, type: "nfs", nfs_udp: true, mount_options: ['rsize=32768', 'wsize=32768', 'nolock']
    master.vm.provider :virtualbox do |mvb, override|
      mvb.customize ["modifyvm", :id, "--nictype2", "virtio"]
      mvb.customize ["controlvm", :id, "nicpromisc2", "allow-all"]
    end

    if File.exists?(USER_DATA)
      master.vm.provision :file, :source => MASTER_USER_DATA, :destination => "/tmp/vagrantfile-user-data"
      master.vm.provision :shell, :privileged => true,
      inline: <<-EOF
        mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/
      EOF
    end
  end

  config.vm.define "node-primary" do |node|
    node.vm.box = "http://#{COREOS_CHANNEL}.release.core-os.net/amd64-usr/#{COREOS_RELEASE}/coreos_production_vagrant.box"

    node.vm.box_check_update = true

    node.ssh.insert_key = false

    node.vm.network "public_network", adapter: 2, bridge: 'en0: Ethernet 1', ip: "172.16.16.16"

    node.vm.hostname = "node-vagrant"
    
    node.vm.provider :virtualbox do |nvb, override|
      nvb.customize ["modifyvm", :id, "--nictype2", "virtio"]
      nvb.customize ["controlvm", :id, "nicpromisc2", "allow-all"]
    end

    if File.exists?(USER_DATA)
      node.vm.provision :file, :source => NODE_USER_DATA, :destination => "/tmp/vagrantfile-user-data"
      node.vm.provision :shell, :privileged => true,
      inline: <<-EOF
        mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/
      EOF
    end
  end

  # Download the corresponding CoreOS image files for the the TFTP boot server
  # Will not download images if they are not newer then the existing files
  system "wget -N -P #{IMAGE_PATH} http://#{COREOS_CHANNEL}.release.core-os.net/amd64-usr/#{COREOS_RELEASE}/coreos_production_pxe.vmlinuz"
  system "wget -N -P #{IMAGE_PATH} http://#{COREOS_CHANNEL}.release.core-os.net/amd64-usr/#{COREOS_RELEASE}/coreos_production_pxe_image.cpio.gz"

  # Download and extract the docker registry and the local registry docker images
  # Will not download files if they are not newer then the existing files
  system "wget -N -P #{DATA_PATH} https://s3-us-west-2.amazonaws.com/insta-cluster/docker-registry.tar"
  system "wget -N -P #{DATA_PATH} https://s3-us-west-2.amazonaws.com/insta-cluster/registry.tar.gz"
  system "tar -zxf #{DATA_PATH}docker-registry.tar -C #{DATA_PATH}"
  system "tar -zxf #{DATA_PATH}registry.tar.gz -C #{DATA_PATHd}"
end
