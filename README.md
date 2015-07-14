# insta-cluster
__This is PINNED to KUBERNETES RELEASE 1.0.0 and COREOS BETA 738.1.0__

This deployment is designed to work off-net once you cloned this repository and performa an initial ```vagrant up``` to grab all the executables and binaries, the ones that weren't fit to print(not able to commit to git).

## Prerequisites
To start off you'll need to configure your Mac OS to allow ip forwarding by running

```bash
sudo sysctl -w net.inet.ip.forwarding=1
```

You will also need to enable a network interface on you workstation with an IP address in the _172.16.16.0/24_ address space(use 172.16.16.10/32)
This will be used as the bridged interface by the VitrualBox VM(s). Make sure you can ping that interface IP before proceeding. If pings don't work you may have a local firewall blocking traffic.

### kubectl

Install kubectl by downloading the binary and installing it in your PATH

```bash
curl -v  -O https://storage.googleapis.com/kubernetes-release/release/v0.20.2/bin/darwin/amd64/kubectl
chmod +x kubectl
mv -f kubectl <PATH>
```

## Usage

Create the ```master``` node first to ensure that all services are available for the ```node-01```. 

```vagrant up master``` will deploy to CoreOS master vm which has the following services running:
_note_** you will be prompted for your system password to enable NFS exports

```bash
dnsmasq
configorator
fleet
kube-apiserver
kube-control-manager
kube-register
```
Run ```vagrant up node-01``` once the ```master``` completes it's start process. 


 and ```master``` and ```node-01```.
IP Address for those VMs along with all Nucs are fixed by the DHCP server. 

```bash
master = 172.16.16.15
node-01 = 172.16.16.16
```

### Configure DHCP configuration

It is strongly advised that you also assign static IPs to the baremetal systems that you are using.
We are using dnsmasq for DHCP and as our tftp server(pxelinux).
The configuration file is located at ```data/dnsmasq.conf.d/dnsmasq.conf```. Format is as follows

```bash
# Disable DNS
port=0

interface=eth1
listen-address=172.16.16.15
listen-address=127.0.0.1

no-hosts

# Enable dhcp and range
dhcp-range=172.16.16.100,172.16.16.150,12h
dhcp-option=1,255.255.255.0
dhcp-option=6,8.8.8.8

dhcp-boot=pxelinux.0,coreosboot,172.16.16.15

# Here is where static IPs are assigned to devices via MAC addresses
dhcp-host=b8:ae:ed:73:dc:2f, node-172-16-16-20, 172.16.16.20

# Enable extended DHCP logging
log-dhcp
```

This file will need to be updated with relevant cluster information prior to running ```vagrant up```.
It's possible to update a running ```master``` but it's better not to deal with that now.

## Kubectl

You will need to set kubectl to the correct local cluster. Preferred method is to create an alias

```bash
alias kubenuc="kubectl --server=http://172.16.16.15:8080"
```
You will then use ```kubenuc``` to manage the kubenetes cluster running on the VMs and Nucs# insta-cluster
__This is PINNED to KUBERNETES RELEASE 0.18.2 and COREOS BETA 895.2.0__

This deployment is designed to work off-net once you cloned this repository and performa an initial ```vagrant up``` to grab all the executables and binaries, the ones that weren't fit to print(not able to commit to git).

## Usage

To start off you'll need to configure your Mac OS to allow ip forwarding by running

```bash
sudo sysctl -w net.inet.ip.forwarding=1
```

Create the ```master``` node first to ensure that all services are available for the ```node-01```. 

```vagrant up master``` will deploy to CoreOS master vm which has the following services running:
_note_** you will be prompted for your system password to enable NFS exports

```bash
dnsmasq
configorator
fleet
kube-apiserver
kube-control-manager
kube-register
```
Run ```vagrant up node-01``` once the ```master``` completes it's start process. 


 and ```master``` and ```node-01```.
IP Address for those VMs along with all Nucs are fixed by the DHCP server. 

```bash
master = 172.16.16.15
node-01 = 172.16.16.16
```

### Configure DHCP configuration

It is strongly advised that you also assign static IPs to the baremetal systems that you are using.
We are using dnsmasq for DHCP and as our tftp server(pxelinux).
The configuration file is located at ```data/dnsmasq.conf.d/dnsmasq.conf```. Format is as follows

```bash
# Disable DNS
port=0

interface=eth1
listen-address=172.16.16.15
listen-address=127.0.0.1

no-hosts

# Enable dhcp and range
dhcp-range=172.16.16.100,172.16.16.150,12h
dhcp-option=1,255.255.255.0
dhcp-option=6,8.8.8.8

dhcp-boot=pxelinux.0,coreosboot,172.16.16.15

# Here is where static IPs are assigned to devices via MAC addresses
dhcp-host=b8:ae:ed:73:dc:2f, node-172-16-16-20, 172.16.16.20



# enable pxelinux
enable-tftp
tftp-root=/var/tftpboot

# Enable extended DHCP logging
log-dhcp
```

This file will need to be updated with relevant cluster information prior to running ```vagrant up```.
It's possible to update a running ```master``` but it's better not to deal with that now.

## Kubectl

You will need to set kubectl to the correct local cluster. Preferred method is to create an alias

```bash
alias kubenuc="kubectl --server=http://172.16.16.15:8080"
```
You will then use ```kubenuc``` to manage the kubenetes cluster running on the VMs and Nucs
