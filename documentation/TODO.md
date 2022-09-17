# To-do list

## ~~Set up bare metal host~~ (done manually, need to automate this process)

- ~~Install the Proxmox VE hypervisor on NAS host; use on NVMe drive, formatted as `zfs`~~
- ~~[Set](https://www.servethehome.com/how-to-change-primary-proxmox-ve-ip-address/) internal static IP of the Proxmox host~~
- ~~Create [ZFS pool(s)](https://www.45drives.com/community/articles/RAID-and-RAIDZ/) and choose RAID level from available storage; RAID explained [here](https://eshop.macsales.com/blog/56056-a-beginners-guide-to-understanding-raid/)~~

## Configure Proxmox automation

- Use Packer to create a standard VMI (Virtual Machine Image) containing `cloud-init`; this will produce an artifact for later deployment use - ***have base config, needs testing***
- Use Terraform to automate provisioning of a VM on the Proxmox platform ***have base config, needs testing***
- Use `cloud-init` to complete bare-minimum configuration of the VM
- Use custom Ansible playbooks to start application configuration and standing up of container infrastructure
