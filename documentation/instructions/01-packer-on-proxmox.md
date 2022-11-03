# Table of Contents
- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
  - [Local environment](#local-environment)
    - [OS](#os)
      - [Mac/Linux](#maclinux)
      - [Windows](#windows)
    - [Apps to install](#apps-to-install)
      - [`openssh`](#openssh)
      - [`packer`](#packer)
  - [Host enviornment](#host-enviornment)
    - [OS](#os-1)
      - [Proxmox VE](#proxmox-ve)
- [Instructions on deployment](#instructions-on-deployment)
- [Files used in `packer` project](#files-used-in-packer-project)
  - [Using the `secrets.pkr.hcl` file](#using-the-secretspkrhcl-file)
  - [Using the `ubuntu-server-jammy.pkr.hcl` file](#using-the-ubuntu-server-jammypkrhcl-file)
      - [TLS Verification](#tls-verification)
      - [Specifying VM Settings](#specifying-vm-settings)
        - [System settings](#system-settings)
        - [Hard disk settings](#hard-disk-settings)
        - [CPU settings](#cpu-settings)
        - [Memory settings](#memory-settings)
        - [Network settings](#network-settings)
      - [Adding VM `cloud-init` settings](#adding-vm-cloud-init-settings)
      - [Adding `packer` boot commands](#adding-packer-boot-commands)
- [Below documentation will need to be rewritten](#below-documentation-will-need-to-be-rewritten)
      - [Setting up `packer` auto-install HTTP server](#setting-up-packer-auto-install-http-server)
        - [Setting static IP for temporary HTTP server](#setting-static-ip-for-temporary-http-server)
      - [Setting up SSH authentication](#setting-up-ssh-authentication)
- [Above documentation will need to be rewritten](#above-documentation-will-need-to-be-rewritten)
    - [VM Template Build Definition](#vm-template-build-definition)
      - [Bootstrap provisioner script for `cloud-init` integration](#bootstrap-provisioner-script-for-cloud-init-integration)
      - [Sourcing configuration file for `cloud-init` integration](#sourcing-configuration-file-for-cloud-init-integration)
      - [Injecting configuration file for `cloud-init` integration](#injecting-configuration-file-for-cloud-init-integration)
      - [(Optional) Add any additional scripts at boot time here](#optional-add-any-additional-scripts-at-boot-time-here)
      - [Add script to template to install `docker`](#add-script-to-template-to-install-docker)
- [Below documentation will need to be rewritten](#below-documentation-will-need-to-be-rewritten-1)
  - [Using the `http/user-data` file](#using-the-httpuser-data-file)
    - [Defining the `autoinstall` block](#defining-the-autoinstall-block)
    - [Defining the `ssh` block](#defining-the-ssh-block)
    - [Defining the `packages` block](#defining-the-packages-block)
    - [Defining the `storages` block](#defining-the-storages-block)
    - [Defining the `user-data` block](#defining-the-user-data-block)
      - [Defining the `users` block](#defining-the-users-block)

# Prerequisites

## Local environment
A local machine will be used to connect to the NAS via `ssh` and run a `packer` deploy to create a VM template with software pre-baked into the image.

### OS

#### Mac/Linux

Use the built-in terminal to run commands

#### Windows

Use `cmd` or PowerShell prompt to run commands

### Apps to install

#### `openssh`

This will allow connecting to the hypervisor host for troubleshooting if needed.

#### `packer`

`packer` is a tool used for automated provisioning of machine images. HashiCorp provides [official instructions](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli) on how to install `packer` locally


## Host enviornment

The target NAS machine will need to have Proxmox VE installed, and will need to be on the same network as the local machine.

### OS

#### Proxmox VE

Proxmox VE is an open-source hypervisor that will be used to manage VMs.
Proxmox offers [official instructions](https://www.proxmox.com/en/proxmox-ve/get-started) on how to install if needed.

# Instructions on deployment

To run the `packer` deployment, a local machine will be used to connect to a seperate host on the same network. The destination host is assumed to have Proxmox VE installed.

Once the all variables and connection settings are defined, the deployment can be executed by navigating to one of the `packer` project folders and run the following commands:

```bash
cd proxmox/ubuntu-server-jammy
```

```bash
packer build -var-file=secrets.pkr.hcl ubuntu-server-jammy.pkr.hcl
```

# Files used in `packer` project

- `secrets.pkr.hcl` - contains the connection settings and variables for the deployment
  - These credentials can be created and retrieved from the Proxmox VE web console, under "Proxmox>Permissions>API Tokens"
- `ubuntu-server-jammy.pkr.hcl` - this is the main project file, and will contain the following:
  - Variables
  - Defined resources for the VM
- `http/user-data` - this contains the custom-defined configuration for `cloud-init` to read

## Using the `secrets.pkr.hcl` file

The unique secrets that need to be plugged into the project can be defined here:

- **ISO path configuration**
  - `proxmox_ubuntu_iso_url` - input the URL that points to the latest Ubuntu image release
  - `proxmox_ubuntu_iso_checksum` - input the checksum of the latest Ubuntu image release

  ~~OR~~
  
  ~~- `proxmox_ubuntu_iso_local_path` - input the path of an already downloaded ISO image~~

- **HTTP server configuration**
  - `http_host_ip` - input the static IP of the Proxmox host
  - `http_host_port` - input a port for the `cloud-init` HTTP server to bind to

- **Proxmox connection configuration**
  - `proxmox_target_node` - input the name of the destination "node" on Proxmox
  - `proxmox_api_url` - input the Proxmox server's API endpoint; format is:
    
    ```
    https://{PROXMOX_IP}:{PROXMOX_PORT}/api2/json
    ```
  
  - `proxmox_api_token_id` - input the API Token ID; format is:

    ```
    root@pam!{TOKEN_NAME}
    ```

  - `proxmox_api_token_secret` - input the API Token Secret; format is:
    
    ```
    xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    ```
    

- **SSH configuration**
  - `proxmox_ssh_username` - input the user to connect via SSH on the Proxmox host; default is `root` 
  - `proxmox_ssh_keyfile_path` - input the path on the local machine that contains the authorized SSH key to connect to the Proxmox host
  
  ~~OR~~
  
  ~~- `proxmox_ssh_password` - input the password for the root user on Proxmox host~~


## Using the `ubuntu-server-jammy.pkr.hcl` file

[In-depth documentation](https://developer.hashicorp.com/packer/plugins/builders/proxmox/iso) is available for configuring the Packer project file to your specific needs; reasonable default configs have been given with the following specifications, but can be changed if required for a unique configuration:

#### TLS Verification

Skip TLS verification should be left as `true` by default unless using self-signed certificates on the Proxmox hypervisor:

```HCL

### VM Template Resource Definition
source "proxmox" "ubuntu-server-jammy" {

    ....
    ....
    ....
    ....
    ....
        
    ## TLS Verification Skip (If needed)
    insecure_skip_tls_verify = true

```

#### Specifying VM Settings

Sensible defaults have been provided for the following VM configurations but can be changed if needed


##### System settings

`qemu_agent` is required for this deployment and should be set to `true`:

```HCL
    ## VM System Settings
    qemu_agent = true
```

##### Hard disk settings

This deployment configured to use a `zfs` disk pool, but any storage can be used:

```HCL
    ## VM Hard Disk Settings
    scsi_controller = "virtio-scsi-pci"
    disks {
        disk_size = "50G"
        format = "raw"
        storage_pool = "vm_os_storage" # This is the name of the target storage pool in Proxmox
        storage_pool_type = "zfspool"
        type = "virtio"
    }
```

##### CPU settings

Sensible defaults are provided, but can be modified if needed:

```HCL
    ## VM CPU Settings
    cores = "1"
```

##### Memory settings


Sensible defaults are provided, but can be modified if needed:

```HCL
    ## VM Memory Settings
    memory = "10240"
```

##### Network settings

Sensible defaults is to use a bridged connection from the VM to the hypervisor, but can be modified if needed:

```HCL
    ## VM Network Settings
    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        firewall = "false"
    } 
```

#### Adding VM `cloud-init` settings

Set the base configuration use with `cloud-init`; default configuration uses `zfs` but can be modified if needed:

```HCL
    ## VM Cloud-Init Settings
    cloud_init = true
    cloud_init_storage_pool = "local-zfs"
```
#### Adding `packer` boot commands

There is additional `packer` [documentation](https://www.packer.io/plugins/builders/proxmox/iso#boot-command) detailing how Packer runs commands at boot; see the [documentation](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html) for more context on how Ubuntu uses a local `cloud-init` configuration.

These key presses allows an unattended Ubuntu install without manual input. Sensible defaults have been provided; this may change with new version updates of Ubuntu:
```HCL
    ## Packer Boot Commands
    boot_command = [
        "<esc><wait>",
        "e<wait>",
        "<down><down><down><end>",
        "<bs><bs><bs><bs><wait>",
        "autoinstall ds=nocloud-net\\;s=http://${var.http_host_ip}:${var.http_host_port}/ ---<wait>",
        "<f10><wait>"
    ]
    boot = "c"
    boot_wait = "5s"

```

# Below documentation will need to be rewritten

#### Setting up `packer` auto-install HTTP server

User-specific input:

- `ssh_username` - the SSH username on Proxmox configured to allow unattended install

`packer` is able to stand up a temporary HTTP server for assisting with auto-install functionality:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/5a0e9a2fd20164f5eaa90866dd36535ad6b0f4e6/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L94-L96

##### Setting static IP for temporary HTTP server

User-specific input:

- `HTTPIP` - the static IP of the HTTP auto-install server
- `HTTPPort` - the port of the HTTP auto-install server

The IP assigned to the temporary HTTP server needs to be defined:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/5a0e9a2fd20164f5eaa90866dd36535ad6b0f4e6/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/ubuntu-server-jammy.pkr.hcl#L99-L102

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

# Above documentation will need to be rewritten

### VM Template Build Definition

Sensible defaults for each of the provisioner blocks have been provided, but can be modified if needed.


The `build` block is pre-defined:

```HCL
### Build definition to create the VM Template
build {
    name = "ubuntu-server-jammy"
    sources = ["source.proxmox.ubuntu-server-jammy"]
  }
```

#### Bootstrap provisioner script for `cloud-init` integration

This first script executes the commands that prepares the ISO for `cloud-init` integration:

```HCL
    ## Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt -y autoremove --purge",
            "sudo apt -y clean",
            "sudo apt -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo sync"
        ]
    }
```

#### Sourcing configuration file for `cloud-init` integration

This sources the configuration that prepares the ISO for `cloud-init` integration:

```HCL
    ## Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source = "files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }
```

#### Injecting configuration file for `cloud-init` integration

This injects the configuration that prepares the ISO for `cloud-init` integration:

```HCL
    ## Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }
```

#### (Optional) Add any additional scripts at boot time here

Any additional commands that should be run during ISO build can be added here:

```HCL
    ## Add additional provisioning scripts here
    # ...
```

#### Add script to template to install `docker` 

A provisioner will be made to run all the commands to install the `docker` daemon:

```HCL
   ## Provisioning the VM Template for Docker Installation #4
    provisioner "shell" {
        inline = [ 
            "sudo apt-get install -y ca-certificates curl gnupg lsb-release",
            "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
            "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
            "sudo apt-get -y update",
            "sudo apt-get install -y docker-ce docker-ce-cli containerd.io"
        ]
    }
```

# Below documentation will need to be rewritten

## Using the `http/user-data` file

This is the configuration file that `cloud-init` will reference.

This will need to be defined; please reference the [documentation](https://cloudinit.readthedocs.io/en/latest/topics/modules.html) to see more details on how to set up the YAML file:

### Defining the `autoinstall` block

Sensible defaults have been provided for the following fields:

- `version`
- `locale`
- `keyboard`

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/5a0e9a2fd20164f5eaa90866dd36535ad6b0f4e6/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/http/user-data#L3-L7

### Defining the `ssh` block

This installs an SSH server using `cloud-init` as well as allow password authentication; important for provisioning tasks:

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/5a0e9a2fd20164f5eaa90866dd36535ad6b0f4e6/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/http/user-data#L8-L13

### Defining the `packages` block

This preinstalls the following Ubuntu packages:

- `sudo`
- `qemu-guest-agent`

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/5a0e9a2fd20164f5eaa90866dd36535ad6b0f4e6/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/http/user-data#L14-L16

### Defining the `storages` block

Sensible defaults have been provided for the following fields:

- `layout`
- `swap`

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/5a0e9a2fd20164f5eaa90866dd36535ad6b0f4e6/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/http/user-data#L17-L21

### Defining the `user-data` block

Sensible defaults have been provided for the following fields:

- `package_upgrade`
- `timezone` (change if needed)

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/5a0e9a2fd20164f5eaa90866dd36535ad6b0f4e6/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/http/user-data#L22-L24

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

https://github.com/ctalaveraw/ultimate-devops-k8s-nas/blob/5a0e9a2fd20164f5eaa90866dd36535ad6b0f4e6/project/environments/01-dev/init-pipeline-runner-vm/infra/image/packer/proxmox/ubuntu-server-jammy/http/user-data#L25-L35