# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">= 1.7.2"

COREOS_CHANNEL="alpha"
COREOS_RELEASE="current"
IMAGE_PATH="data/dnsmasq/tftpboot"
DATA_PATH="data/"



USER_DATA = File.expand_path(File.join(File.expand_path(File.dirname(__FILE__)), 'master.yaml'))
Vagrant.configure(2) do |config|

  config.vm.box = "http://#{COREOS_CHANNEL}.release.core-os.net/amd64-usr/#{COREOS_RELEASE}/coreos_production_vagrant.box"

  config.vm.box_check_update = true

  config.ssh.insert_key = false

  config.vm.network "public_network", adapter: 2, bridge: 'en0: Ethernet 1', ip: "172.16.16.15"
  config.vm.network "private_network", adapter: 3, ip: "192.168.100.10" 

  config.vm.network "forwarded_port", guest: 2375, host: 2375

  config.vm.hostname = "node-vagrant"
  
  config.vm.synced_folder ".", "/vagrant", disabled: false, type: "nfs", nfs_udp: true, mount_options: ['rsize=32768', 'wsize=32768', 'nolock']
  #config.vm.synced_folder "data/" , "/vagrant_data", disabled: false, type: "nfs", nfs_udp: true, mount_options: ['rsize=32768', 'wsize=32768', 'nolock']
  config.vm.provider :virtualbox do |vb, override|
    vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
    vb.customize ["controlvm", :id, "nicpromisc2", "allow-all"]
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
  system "tar -zxf #{DATA_PATH}registry.tar.gz -C #{DATA_PATH}"

  if File.exists?(USER_DATA)
    config.vm.provision :file, :source => USER_DATA, :destination => "/tmp/vagrantfile-user-data"
    config.vm.provision :shell, :privileged => true,
    inline: <<-EOF
      mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/
    EOF
  end
end
