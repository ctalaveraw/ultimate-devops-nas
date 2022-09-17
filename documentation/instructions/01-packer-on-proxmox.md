# How to install `packer` on Proxmox

First, install the `packer` application on the Proxmox Hypervisor:

```bash
apt-get -y install packer
```

This will connect to the server to begin the creation of a standardized VMI (Virtual Machine Image) that contains `cloud-init`.

## Prerequisite files for the `packer` project

- `credentials.pkr.hcl` - contains the connection settings for the Proxmox server
  - These credentials can be retrieved from "Proxmox>Permissions>API Tokens"
- `ubuntu-server-jammy.pkr.hcl` - this is the main project file, and will contain the following:
  - Variables
  - Defined resources for the VM

### Using the `ubuntu-server-jammy.pkr.hcl` file

If the Proxmox hypervisor has any self-signed  certificates, be sure to use this line to disable TLS verification:

```HCL
insecure_skip_tls_verify = true

```
