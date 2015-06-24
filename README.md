# insta-cluster

## Usage

### Configure DHCP configuration

```vagrant up``` will deploy to CoreOS VMs, ```master``` and ```node-primary```.
IP Address for those VMs along with all Nucs are fixed by the DHCP server.

```bash
master = 172.16.16.15
node-primary=172.16.16.16
```

We are using dnsmasq for DHCP and as our tftp server(pxelinux).
The configuration file is located at ```data/dnsmasq.conf.d/dnsmasq.conf```
This file will need to be updated with relevant cluster information prior to running ```vagrant up```.
It's possible to update a running ```master``` but it's better not to deal with that now.

## Kubectl

You will need to set kubectl to the correct local cluster. Preferred method is to create an alias

```bash
alias kubenuc="kubectl --server=http://172.16.16.15:8080"
```
You will then use ```kubenuc``` to manage the kubenetes cluster running on the VMs and Nucs
