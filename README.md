# insta-cluster

## Usage

### Configure DHCP configuration

We are using dnsmasq for DHCP and as our tftp server(pxelinux).
The configuration file is located at ```data/dnsmasq.conf.d/dnsmasq.conf```


## Kubectl

You will need to set kubectl to the correct local cluster. Preferred method is to create an alias

```bash
alias kubenuc="kubectl --server=http://172.16.16.15:8080"
```
You will then use kubenuc to manage the kubenetes cluster running on the VMs and Nucs
