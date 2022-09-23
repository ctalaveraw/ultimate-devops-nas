# How to install `packer` on Proxmox

First, install the `packer` application on the Proxmox Hypervisor:

```bash
apt-get -y install packer
```

This will connect to the server to begin the creation of a standardized VMI (Virtual Machine Image) that contains `cloud-init`.

## Prerequisite files for the `packer` project

- `credentials.pkr.hcl` - contains the connection settings for the Proxmox server
  - These credentials can be created and retrieved from "Proxmox>Permissions>API Tokens"
- `ubuntu-server-jammy.pkr.hcl` - this is the main project file, and will contain the following:
  - Variables
  - Defined resources for the VM

### Using the `ubuntu-server-jammy.pkr.hcl` file

[In-depth documentation](v) is available for configuring the Packer project file to your specific needs; a short-breakdown of each part of the project file is listed below:

#### Variable Definitions

The variables related to the connecting to the Proxmox server must first be defined at the beginning of the file:

https://raw.githubusercontent.com/ctalaveraw/ultimate-devops-k8s-nas/master/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L9-L21

#### Resource Definitions

Begin the `proxmox` resource block:

https://raw.githubusercontent.com/ctalaveraw/ultimate-devops-k8s-nas/master/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L23-L25

##### Add Proxmox Connection Settings

The variables previously defined will be used for the Proxmox connection settings:

```HCL
# VM Template Resource Definition
source "proxmox" "ubuntu-server-jammy" {
  ...
  ...
  ...
    # Proxmox Connection Settings
    username = "${var.proxmox_api_token_id}"
    token = "${var.proxmox_api_token_secret}"
    proxmox_url = "${var.proxmox_api_url}"
  ...
  ...
  ...
}
```

##### TLS Verification

If the Proxmox hypervisor has any self-signed  certificates, be sure to use this line to disable TLS verification:

```HCL
# VM Template Resource Definition
source "proxmox" "ubuntu-server-jammy" {
  ...
  ...
  ...
    # TLS Verification Skip (If needed)
    # insecure_skip_tls_verify = true
  ...
  ...
  ...
}
```

##### Add VM General Settings

This is where the metadata of the VM template is defined:

```HCL
# VM Template Resource Definition
source "proxmox" "ubuntu-server-jammy" {
  ...
  ...
  ...
    # VM General Settings
    node = "tva" # Name of the destination "node" on Proxmox
    vm_id = "100"
    vm_name = "ubuntu-server-jammy"
    template_description = "Ubuntu 22.04.1 LTS Jammy Jellyfish VMI"
  ...
  ...
  ...
}
```

##### Setting the ISO source

Two options are available for the base ISO:

`option 1` - the base ISO is downloaded from a remote URL:

```HCL
# VM Template Resource Definition
source "proxmox" "ubuntu-server-jammy" {
  ...
  ...
  ...
    # VM ISO source (Choose ONLY ONE)
    
    # Download ISO (Option 1)
    iso_url = "https://releases.ubuntu.com/22.04/ubuntu-22.04.1-live-server-amd64.iso"
    iso_checksum = "INSERT_CHECKSUM_HERE"
    
    # Local ISO File (Option 2)
    # iso_file = "local:iso/ubuntu-22.04.1-live-server-amd64.iso"
  ...
  ...
  ...
}
```

`option 2` - the base ISO is retrieved locally:

```HCL
# VM Template Resource Definition
source "proxmox" "ubuntu-server-jammy" {
  ...
  ...
  ...
    # VM ISO source (Choose ONLY ONE)
    
    # Download ISO (Option 1)
    # iso_url = "https://releases.ubuntu.com/22.04/ubuntu-22.04.1-live-server-amd64.iso"
    # iso_checksum = "INSERT_CHECKSUM_HERE"
    
    # Local ISO File (Option 2)
    iso_file = "local:iso/ubuntu-22.04.1-live-server-amd64.iso"
  ...
  ...
  ...
}
```

##### Adding VM OS, System and Hard Disk Settings

Set the base configuration for the following conponents:

- OS settings
- System settings
- Hard disk settings

https://raw.githubusercontent.com/ctalaveraw/ultimate-devops-k8s-nas/master/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L49-L64

##### Adding VM CPU, Memory and Network Settings

Set the base configuration for the following conponents:

- CPU settings
- Memory settings
- Network settings

https://raw.githubusercontent.com/ctalaveraw/ultimate-devops-k8s-nas/master/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L66-L77

