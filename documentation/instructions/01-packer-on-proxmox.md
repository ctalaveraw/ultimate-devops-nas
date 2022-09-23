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

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/3a963a35e687b86a658c8bf4d74496a26750551e/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L9-L21

#### Resource Definitions

Begin the `proxmox` resource block:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/3a963a35e687b86a658c8bf4d74496a26750551e/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L23-L25

##### Add Proxmox Connection Settings

The variables previously defined will be used for the Proxmox connection settings:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/3a963a35e687b86a658c8bf4d74496a26750551e/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L26-L29

##### TLS Verification

If the Proxmox hypervisor has any self-signed  certificates, be sure to use this line to disable TLS verification:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/3a963a35e687b86a658c8bf4d74496a26750551e/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L31-L32

##### Add VM General Settings

This is where the metadata of the VM template is defined:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/3a963a35e687b86a658c8bf4d74496a26750551e/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L34-L38

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
    iso_checksum = "10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
    
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
    # iso_checksum = "10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
    
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

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/3a963a35e687b86a658c8bf4d74496a26750551e/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L49-L64

##### Adding VM CPU, Memory and Network Settings

Set the base configuration for the following components:

- CPU settings
- Memory settings
- Network settings

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/3a963a35e687b86a658c8bf4d74496a26750551e/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L66-L77

##### Adding VM `cloud-init` settings

Set the base configuration use with `cloud-init`:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/3a963a35e687b86a658c8bf4d74496a26750551e/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L79-L81

##### Adding `packer` boot commands

There is additional `packer` [documentation](https://www.packer.io/plugins/builders/proxmox/iso#boot-command) detailing how Packer runs commands at boot.

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/3a963a35e687b86a658c8bf4d74496a26750551e/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L83-L92

##### Setting up `packer` auto-install HTTP server

`packer` is able to stand up a temporary HTTP server for assisting with auto-install functionality:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/3a963a35e687b86a658c8bf4d74496a26750551e/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L94-L96

###### Setting static IP for temporary HTTP server (optional)

If required, the IP assigned to the temporary HTTP server can be defined:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/3a963a35e687b86a658c8bf4d74496a26750551e/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L99-L102

##### Setting up SSH authentication

Two options are available for authenticating via SSH:

`option 1` - use a generated private SSH key file (RECOMMENDED):

```HCL
# VM Template Resource Definition
source "proxmox" "ubuntu-server-jammy" {
  ...
  ...
  ...
    # Authentication (CHOOSE ONLY ONE)
    
    # Use private SSH Key file (Option 1 - RECOMMENDED)
    ssh_private_key_file = "~/.ssh/id_rsa"
    ssh_timeout = "10m" # Raise the timeout, when installation takes longer
    
    # Use SSH Password (Option 2)
    # ssh_password = "your-password"
  ...
  ...
  ...
}
```

`option 2` - use a hard-coded SSH password:

```HCL
# VM Template Resource Definition
source "proxmox" "ubuntu-server-jammy" {
  ...
  ...
  ...
    # Authentication (CHOOSE ONLY ONE)
    
    # Use private SSH Key file (Option 1 - RECOMMENDED)
    # ssh_private_key_file = "~/.ssh/id_rsa"
    # ssh_timeout = "10m" # Raise the timeout, when installation takes longer
    
    # Use SSH Password (Option 2)
    ssh_password = "your-password"
  ...
  ...
  ...
}
```

#### VM Template Build Definition

Lastly, the `build` block can defined for the image:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/3a963a35e687b86a658c8bf4d74496a26750551e/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L114-L117

##### Bootstrap provisioner script for `cloud-init` integration

This first script executes the commands that prepares the ISO for `cloud-init` integration:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/3a963a35e687b86a658c8bf4d74496a26750551e/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L119-L132

##### Sourcing configuration file for `cloud-init` integration

This sources the configuration that prepares the ISO for `cloud-init` integration:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/3a963a35e687b86a658c8bf4d74496a26750551e/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L134-L138

##### Injecting configuration file for `cloud-init` integration

This injects the configuration that prepares the ISO for `cloud-init` integration:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/3a963a35e687b86a658c8bf4d74496a26750551e/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L140-L143

##### (Optional) Add any additional scripts at boot time here

Any additional commands that should be run during ISO build can be added here:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/3a963a35e687b86a658c8bf4d74496a26750551e/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L145-L146