# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">= 1.7.2"

COREOS_CHANNEL = "beta"
COREOS_RELEASE = "695.2.0"
IMAGE_PATH = "data/tftpboot"
DATA_PATH = "data/"
BRIDGE_INTERFACE = '' || 'en0: Ethernet 1'    #this needs to be the extact name of the bridge interface



MASTER_USER_DATA = File.expand_path(File.join(File.expand_path(File.dirname(__FILE__)), 'master.yaml'))
NODE_USER_DATA = File.expand_path(File.join(File.expand_path(File.dirname(__FILE__)), 'node.yaml'))
Vagrant.configure(2) do |config|

  config.vm.define "master" do |master|

    master.vm.box = "http://#{COREOS_CHANNEL}.release.core-os.net/amd64-usr/#{COREOS_RELEASE}/coreos_production_vagrant.box"
    master.vm.box_check_update = true

    master.ssh.insert_key = false

    master.vm.network "public_network", adapter: 2,  bridge: BRIDGE_INTERFACE,ip: "172.16.16.15"
    master.vm.network "private_network", adapter: 3, ip: "192.168.100.10" 

    master.vm.network "forwarded_port", guest: 2375, host: 2375

    master.vm.hostname = "master"
    
    master.vm.synced_folder ".", "/vagrant", disabled: false, type: "nfs", nfs_udp: true, mount_options: ['rsize=32768', 'wsize=32768', 'nolock']
    #config.vm.synced_folder "data/" , "/vagrant_data", disabled: false, type: "nfs", nfs_udp: true, mount_options: ['rsize=32768', 'wsize=32768', 'nolock']
    master.vm.provider :virtualbox do |mvb, override|
      mvb.memory = 4048
      mvb.cpus = 2
      mvb.customize ["modifyvm", :id, "--nictype2", "virtio"]
      mvb.customize ["controlvm", :id, "nicpromisc2", "allow-all"]
    end

    if File.exists?(MASTER_USER_DATA)
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

    node.memory = 4048
    node.cpus = 2

    node.ssh.insert_key = false

    node.vm.network "public_network", adapter: 2, bridge: 'en0: Ethernet 1', ip: "172.16.16.16"
    node.vm.network "private_network", adapter: 3, ip: "192.168.100.11" 

    node.vm.hostname = "node-primary"

    node.vm.synced_folder ".", "/vagrant", disabled: false, type: "nfs", nfs_udp: true, mount_options: ['rsize=32768', 'wsize=32768', 'nolock']
    
    node.vm.provider :virtualbox do |nvb, override|
      nvb.memory = 4048
      nvb.cpus = 2
      nvb.customize ["modifyvm", :id, "--nictype2", "virtio"]
      nvb.customize ["controlvm", :id, "nicpromisc2", "allow-all"]
    end

    if File.exists?(NODE_USER_DATA)
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
  system "tar -zxf #{DATA_PATH}registry.tar.gz -C #{DATA_PATH}"

  # Download the required version for kubectl and docker compose for this cluster service deployemnt
  system "wget -N -P bin https://s3-us-west-2.amazonaws.com/insta-cluster/kubectl"
  system "wget -N -P bin https://s3-us-west-2.amazonaws.com/insta-cluster/docker-compose"

  # Make all files executable
  system "chmod -R +x bin"
end
