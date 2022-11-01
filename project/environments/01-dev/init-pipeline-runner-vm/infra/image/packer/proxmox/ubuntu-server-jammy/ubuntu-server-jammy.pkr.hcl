/*
    Written by: https://github.com/ctalaveraw

    This project is for deploying a Packer template on Proxmox.
    This VMI (Virtual Machine Image) will be based on Ubuntu 22.04.1 LTS
    This is the "Jammy Jellyfish" release and will contain "cloud-init" baked in.
*/

### Variable Definitions

/*
    Details are listed here:
    https://developer.hashicorp.com/packer/plugins/builders/proxmox/iso#proxmox_url
    https://developer.hashicorp.com/packer/plugins/builders/proxmox/iso#username
    https://developer.hashicorp.com/packer/plugins/builders/proxmox/iso#token
*/

## HTTP server configuration
variable "http_host_ip" {
    type = string
}

variable "http_host_port" {
    type = string
    default = "8021"
}

## ISO path configuration
variable "proxmox_ubuntu_iso_url" {
    type = string
    default = "https://releases.ubuntu.com/22.04/ubuntu-22.04.1-live-server-amd64.iso"
}

variable "proxmox_ubuntu_iso_checksum" {
    type = string
    default = "10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
    sensitive = false
}

# OR

/*
variable "proxmox_ubuntu_iso_local_path" {
    type = string
    default = "local:iso/ubuntu-22.04.1-live-server-amd64.iso"
}
*/

## Proxmox connection configuration
variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

variable "proxmox_target_node" {
    type = string
}

## SSH configuration
variable "proxmox_ssh_username" {
    type = string
    default = "root"
}

variable "proxmox_ssh_keyfile_path" {
    type = string
    default = "~/.ssh/id_rsa"
}

# OR

/*
variable "proxmox_ssh_password" {
    type = string
    sensitive = true
}
*/

### VM Template Resource Definition
source "proxmox" "ubuntu-server-jammy" {

    ## Proxmox Connection Settings
    username = "${var.proxmox_api_token_id}"
    token = "${var.proxmox_api_token_secret}"
    proxmox_url = "${var.proxmox_api_url}"
    node = "${var.proxmox_target_node}"
    
    ## TLS Verification Skip (If needed)
    insecure_skip_tls_verify = true
    
    ## VM General Settings
    vm_id = "100"
    vm_name = "ubuntu-server-jammy"
    template_description = "Ubuntu Server LTS 22.04.1 Jammy Jellyfish VMI"
    
    ## VM ISO source (Choose ONLY ONE)
    
    ## Download ISO (Option 1)
    iso_url = "${var.proxmox_ubuntu_iso_url}"
    iso_checksum = "${var.proxmox_ubuntu_iso_checksum}"
    
    # OR

    ## Local ISO File (Option 2)
    # iso_file = "${var.proxmox_ubuntu_iso_local_path}"
    
    ## VM OS Settings
    iso_storage_pool = "local" # This is where Proxmox is installed; change if images need storage elsewhere
    unmount_iso = true # Dismount's the ISO after build is done
    
    ## VM System Settings
    qemu_agent = true
    
    ## VM Hard Disk Settings
    scsi_controller = "virtio-scsi-pci"
    disks {
        disk_size = "50G"
        format = "raw"
        storage_pool = "vm_os_storage" # This is the name of the target storage pool in Proxmox
        storage_pool_type = "zfspool"
        type = "virtio"
    }
    
    ## VM CPU Settings
    cores = "1"
    
    ## VM Memory Settings
    memory = "10240" 
    
    ## VM Network Settings
    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        firewall = "false"
    } 
    
    ## VM Cloud-Init Settings
    cloud_init = true
    cloud_init_storage_pool = "local-zfs"
    
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

    ## Packer HTTP Server Settings for Autoinstall
    http_directory = "http" 
    

    ## Bind IP Address and Port Statically
    http_bind_address = "${var.http_host_ip}"
    http_port_min = "${var.http_host_port}"
    http_port_max = "${var.http_host_port}"
    
    ## Authentication (CHOOSE ONLY ONE)
    ssh_timeout = "20m" # Raise the timeout, when installation takes longer
    
    ## Use private SSH Key file (Option 1 - RECOMMENDED)
    ssh_username = "${var.proxmox_ssh_username}"
    ssh_private_key_file = "${var.proxmox_ssh_keyfile_path}"
    
    # OR

    ## Use SSH Password (Option 2)
    # ssh_password = "${var.proxmox_ssh_password}"
}

### Build definition to create the VM Template
build {
    name = "ubuntu-server-jammy"
    sources = ["source.proxmox.ubuntu-server-jammy"]
    
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
    
    ## Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source = "files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }
    
    ## Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }
    
    ## Add additional provisioning scripts here
    # ...

    ## Provisioning the VM Template for Docker Installation #4
    provisioner "shell" {
        inline = [ 
            "sudo apt-get -y install ca-certificates curl gnupg lsb-release",
            "sudo mkdir -p /etc/apt/keyrings",
            "curl -SLfs https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
            "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/ocker.gpg] dhttps://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
            "sudo apt-get -y update",
            "sudo apt-get -y install docker-ce docker-ce-cli containerd.io"
        ]
    }
}
