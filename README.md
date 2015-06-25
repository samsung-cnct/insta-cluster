# insta-cluster
__This is PINNED to KUBERNETES RELEASE 0.18.2 and COREOS BETA 895.2.0__

This deployment is designed to work off-net once you cloned this repository and performa an initial ```vagrant up``` to grab all the executables and binaries, the ones that weren't fit to print(not able to commit to git).

## Usage

To start off you'll need to configure your Mac OS to allow ip forwarding by running

```bash
sudo sysctl -w net.inet.ip.forwarding=1
```

Create the ```master``` node first to ensure that all services are available for the ```node-primary```. 

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
Run ```vagrant up node-primary``` once the ```master``` completes it's start process. 


 and ```master``` and ```node-primary```.
IP Address for those VMs along with all Nucs are fixed by the DHCP server. 

```bash
master = 172.16.16.15
node-primary = 172.16.16.16
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
