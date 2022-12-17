# List of deployments

The list of deploys detailed below.

## 00 - Proxmox Hypervisor Configuration

These are an assortment of `bash` scripts to spin up the configuration of the Proxmox VE host, to allow for easy service account and secret creation for later deployments.

~~- run the scripts within the `../init-proxmox-config/ansible/init-hypervisor-config/` to perform initial hypervisor configuration~~

~~- run the scripts within the `../init-proxmox-config/ansible/init-create-zfs-pools/` to provision the storage pools for the NAS~~

- run the scripts within the `../init-proxmox-config/ansible/init-create-service-accounts/` to provision the required SSH keypair and service accounts for future deployments

## 01 - CI/CD Pipeline Runner VM

This VM will run Ubuntu, with a GitLab self-hosted instance in Docker. This will allow for the stand-up of a CI/CD pipeline to orchestrate the "Ultimate NAS" VM.

- `packer` deployment to create `proxmox` VM template with `ubuntu` as the OS, and `docker` baked-in
- run `bash` script to generate SSH keypair for `terraform` deployment
- `terraform` deployment to create VM using template from `packer` deployment from previous step
- `ansible` deployment, with created VM as the target, to spin up a `docker` container running a self-hosted `gitlab` instance

## 02 - Ultimate NAS VM

This VM will host a assortment of self-hosted apps contanerized in Docker

- `packer` deployment to create `proxmox` VM template with `ubuntu` as the OS, and `docker` baked-in
- `terraform` deployment to create VM using template from `packer` deployment from previous step
- `ansible` deployment, with created VM as the target, to spin up several `docker` containers running a suite of self-hosted applications that will make up the "Ultimate NAS"