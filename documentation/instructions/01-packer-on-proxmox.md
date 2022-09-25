# Table of Contents
- [Table of Contents](#table-of-contents)
- [How to install `packer` on Proxmox](#how-to-install-packer-on-proxmox)
- [Prerequisite files for the `packer` project](#prerequisite-files-for-the-packer-project)
  - [Using the `credentials.pkr.hcl` file](#using-the-credentialspkrhcl-file)
  - [Using the `ubuntu-server-jammy.pkr.hcl` file](#using-the-ubuntu-server-jammypkrhcl-file)
    - [Variable Definitions](#variable-definitions)
    - [Resource Definitions](#resource-definitions)
      - [Add Proxmox Connection Settings](#add-proxmox-connection-settings)
      - [TLS Verification](#tls-verification)
      - [Add VM General Settings](#add-vm-general-settings)
      - [Setting the ISO source](#setting-the-iso-source)
      - [Adding VM OS, System and Hard Disk Settings](#adding-vm-os-system-and-hard-disk-settings)
      - [Adding VM CPU, Memory and Network Settings](#adding-vm-cpu-memory-and-network-settings)
      - [Adding VM `cloud-init` settings](#adding-vm-cloud-init-settings)
      - [Adding `packer` boot commands](#adding-packer-boot-commands)
      - [Setting up `packer` auto-install HTTP server](#setting-up-packer-auto-install-http-server)
        - [Setting static IP for temporary HTTP server](#setting-static-ip-for-temporary-http-server)
      - [Setting up SSH authentication](#setting-up-ssh-authentication)
    - [VM Template Build Definition](#vm-template-build-definition)
      - [Bootstrap provisioner script for `cloud-init` integration](#bootstrap-provisioner-script-for-cloud-init-integration)
      - [Sourcing configuration file for `cloud-init` integration](#sourcing-configuration-file-for-cloud-init-integration)
      - [Injecting configuration file for `cloud-init` integration](#injecting-configuration-file-for-cloud-init-integration)
      - [(Optional) Add any additional scripts at boot time here](#optional-add-any-additional-scripts-at-boot-time-here)
      - [Add script to template to install `docker`](#add-script-to-template-to-install-docker)
  - [Using the `http/user-data` file](#using-the-httpuser-data-file)
    - [Defining the `autoinstall` block](#defining-the-autoinstall-block)
    - [Defining the `ssh` block](#defining-the-ssh-block)
    - [Defining the `packages` block](#defining-the-packages-block)
    - [Defining the `storages` block](#defining-the-storages-block)
    - [Defining the `user-data` block](#defining-the-user-data-block)
      - [Defining the `users` block](#defining-the-users-block)

# How to install `packer` on Proxmox

First, install the `packer` application on the Proxmox Hypervisor:

```bash
apt-get -y install packer
```

This will connect to the server to begin the creation of a standardized VMI (Virtual Machine Image) that contains `cloud-init`.

# Prerequisite files for the `packer` project

- `credentials.pkr.hcl` - contains the connection settings for the Proxmox server
  - These credentials can be created and retrieved from "Proxmox>Permissions>API Tokens"
- `ubuntu-server-jammy.pkr.hcl` - this is the main project file, and will contain the following:
  - Variables
  - Defined resources for the VM
- `http/user-data` - this contains the custom-defined configuration for `cloud-init` to read

## Using the `credentials.pkr.hcl` file

The unique secrets that need to be plugged into the project can be defined here:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/credentials.pkr.hcl#L1-L3

## Using the `ubuntu-server-jammy.pkr.hcl` file

[In-depth documentation](v) is available for configuring the Packer project file to your specific needs; a short-breakdown of each part of the project file is listed below:

### Variable Definitions

The variables related to the connecting to the Proxmox server must first be defined at the beginning of the file; the actual values will be set in the `credentials.pkr.hcl` file:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L9-L21

### Resource Definitions

Begin the `proxmox` resource block:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L23-L25

#### Add Proxmox Connection Settings

The variables previously defined will be used for the Proxmox connection settings:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L26-L29

#### TLS Verification

If the Proxmox hypervisor has any self-signed  certificates, be sure to use this line to disable TLS verification:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L31-L32

#### Add VM General Settings

User-specific input:

- `node` - the name of the destination node" on Proxmox

This is where the metadata of the VM template is defined:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L34-L38

#### Setting the ISO source

User-specific input:

- `iso_url` - the URL of the lastest Ubuntu LTS ISO image; this may change in the future and may need to be updated
- `iso_checksum` - the checksum of the defined Ubuntu LTS ISO image; this may change in the future and may need to be updated

OR

- `iso_file` - the local location of the target ISO file

Two options are available for the base ISO:

`option 1` - the base ISO is downloaded from a remote URL:

```HCL
 VM Template Resource Definition
source "proxmox" "ubuntu-server-jammy" {
  ...
  ...
  ...
     VM ISO source (Choose ONLY ONE)
    
     Download ISO (Option 1)
    iso_url = "https://releases.ubuntu.com/22.04/ubuntu-22.04.1-live-server-amd64.iso"
    iso_checksum = "10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
    
     Local ISO File (Option 2)
     iso_file = "local:iso/ubuntu-22.04.1-live-server-amd64.iso"
  ...
  ...
  ...
}
```

`option 2` - the base ISO is retrieved locally:

```HCL
 VM Template Resource Definition
source "proxmox" "ubuntu-server-jammy" {
  ...
  ...
  ...
     VM ISO source (Choose ONLY ONE)
    
     Download ISO (Option 1)
     iso_url = "https://releases.ubuntu.com/22.04/ubuntu-22.04.1-live-server-amd64.iso"
     iso_checksum = "10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
    
     Local ISO File (Option 2)
    iso_file = "local:iso/ubuntu-22.04.1-live-server-amd64.iso"
  ...
  ...
  ...
}
```

#### Adding VM OS, System and Hard Disk Settings

Set the base configuration for the following components using personal preferences:

- OS settings
- System settings
- Hard disk settings

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L49-L64

#### Adding VM CPU, Memory and Network Settings

Set the base configuration for the following components using personal preferences:

- CPU settings
- Memory settings
- Network settings

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L66-L77

#### Adding VM `cloud-init` settings

Set the base configuration use with `cloud-init`:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L79-L81

#### Adding `packer` boot commands

User-specific input:

- `HTTPIP` - the static IP of the HTTP auto-install server
- `HTTPPort` - the port of the HTTP auto-install server

There is additional `packer` [documentation](https://www.packer.io/plugins/builders/proxmox/iso#boot-command) detailing how Packer runs commands at boot; see the [documentation](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html) for more context on how Ubuntu uses a local `cloud-init` configuration. These key presses allows an unattended Ubuntu install without manual input.


https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L83-L92

#### Setting up `packer` auto-install HTTP server

User-specific input:

- `ssh_username` - the SSH username on Proxmox configured to allow unattended install

`packer` is able to stand up a temporary HTTP server for assisting with auto-install functionality:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L94-L96

##### Setting static IP for temporary HTTP server

User-specific input:

- `HTTPIP` - the static IP of the HTTP auto-install server
- `HTTPPort` - the port of the HTTP auto-install server

The IP assigned to the temporary HTTP server needs to be defined:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L99-L102

#### Setting up SSH authentication

User-specific input:

- `ssh_private_key_file` - private SSH key file used for authentication

OR

- `ssh_password` - SSH password used for authentication

Two options are available for authenticating via SSH:

`option 1` - use a generated private SSH key file (RECOMMENDED):

```HCL
 VM Template Resource Definition
source "proxmox" "ubuntu-server-jammy" {
  ...
  ...
  ...
     Authentication (CHOOSE ONLY ONE)
    
     Use private SSH Key file (Option 1 - RECOMMENDED)
    ssh_private_key_file = "~/.ssh/id_rsa"
    ssh_timeout = "10m"  Raise the timeout, when installation takes longer
    
     Use SSH Password (Option 2)
     ssh_password = "your-password"
  ...
  ...
  ...
}
```

`option 2` - use a hard-coded SSH password:

```HCL
 VM Template Resource Definition
source "proxmox" "ubuntu-server-jammy" {
  ...
  ...
  ...
     Authentication (CHOOSE ONLY ONE)
    
     Use private SSH Key file (Option 1 - RECOMMENDED)
     ssh_private_key_file = "~/.ssh/id_rsa"
     ssh_timeout = "10m"  Raise the timeout, when installation takes longer
    
     Use SSH Password (Option 2)
    ssh_password = "your-password"
  ...
  ...
  ...
}
```

### VM Template Build Definition

Lastly, the `build` block can defined for the image:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L114-L117

#### Bootstrap provisioner script for `cloud-init` integration

This first script executes the commands that prepares the ISO for `cloud-init` integration:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L119-L132

#### Sourcing configuration file for `cloud-init` integration

This sources the configuration that prepares the ISO for `cloud-init` integration:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L134-L138

#### Injecting configuration file for `cloud-init` integration

This injects the configuration that prepares the ISO for `cloud-init` integration:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L140-L143

#### (Optional) Add any additional scripts at boot time here

Any additional commands that should be run during ISO build can be added here:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L145-L146

#### Add script to template to install `docker` 

A provisioner will be made to run all the commands to install the `docker` daemon:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L148-L158
## Using the `http/user-data` file

This is the configuration file that `cloud-init` will reference.

This will need to be defined; please reference the [documentation](https://cloudinit.readthedocs.io/en/latest/topics/modules.html) to see more details on how to set up the YAML file:

### Defining the `autoinstall` block

Sensible defaults have been provided for the following fields:

- `version`
- `locale`
- `keyboard`

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/http/user-data#L3-L7

### Defining the `ssh` block

This installs an SSH server using `cloud-init` as well as allow password authentication; important for provisioning tasks:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/http/user-data#L8-L13

### Defining the `packages` block

This preinstalls the following Ubuntu packages:

- `sudo`
- `qemu-guest-agent`

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/http/user-data#L14-L16

### Defining the `storages` block

Sensible defaults have been provided for the following fields:

- `layout`
- `swap`

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/http/user-data#L17-L21

### Defining the `user-data` block

Sensible defaults have been provided for the following fields:

- `package_upgrade`
- `timezone` (change if needed)

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/http/user-data#L22-L24

#### Defining the `users` block

User-specific input:

- `name` - the name of the created Linux user used for SSH connection
- `ssh_authorized_keys` - the SSH key file used for SSH connection

OR

- `passwd` - the password used for SSH connection

Sensible defaults have been provided for the following fields:

- `groups`
- `shell`
- `sudo`
- `lock-passwd`

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/8551dfe470b6c0785482f11dcf121b8aff5211df/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/http/user-data#L25-L35