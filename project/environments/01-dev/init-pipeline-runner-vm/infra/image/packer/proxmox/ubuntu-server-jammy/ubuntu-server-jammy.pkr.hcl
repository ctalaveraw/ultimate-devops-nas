/*
Written by: https://github.com/ctalaveraw

This project is for deploying a Packer template on Proxmox.
This VMI (Virtual Machine Image) will be based on Ubuntu 22.04.1 LTS
This is the "Jammy Jellyfish" release and will contain "cloud-init" baked in.
*/

# Variable Definitions
variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

variable "proxmox_api_url" {
    type = string
}

# VM Template Resource Definition
source "proxmox" "ubuntu-server-jammy" {

    # Proxmox Connection Settings
    username = "${var.proxmox_api_token_id}"
    token = "${var.proxmox_api_token_secret}"
    proxmox_url = "${var.proxmox_api_url}"
    
    # TLS Verification Skip (If needed)
    # insecure_skip_tls_verify = true
    
    # VM General Settings
    node = "tva" # Name of the destination "node" on Proxmox
    vm_id = "100"
    vm_name = "ubuntu-server-jammy"
    template_description = "Ubuntu 22.04.1 LTS Jammy Jellyfish VMI"
    
    # VM ISO source (Choose ONLY ONE)
    
    # Download ISO (Option 1)
    iso_url = "https://releases.ubuntu.com/22.04/ubuntu-22.04.1-live-server-amd64.iso"
    iso_checksum = "10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
    
    # Local ISO File (Option 2)
    # iso_file = "local:iso/ubuntu-22.04.1-live-server-amd64.iso"
    
    # VM OS Settings
    iso_storage_pool = "local" # This is where Proxmox is installed; change if images need storage elsewhere
    unmount_iso = true # Dismount's the ISO after build is done
    
    # VM System Settings
    qemu_agent = true
    
    # VM Hard Disk Settings
    scsi_controller = "virtio-scsi-pci"
    disks {
        disk_size = "50G"
        format = "raw"
        storage_pool = "vm_os_storage" # This is the name of the target storage pool in Proxmox
        storage_pool_type = "zfspool"
        type = "virtio"
    }
    
    # VM CPU Settings
    cores = "1"
    
    # VM Memory Settings
    memory = "10240" 
    
    # VM Network Settings
    network_adapters {
        model = "virtio"
        bridge = "vmbr0"
        firewall = "false"
    } 
    
    # VM Cloud-Init Settings
    cloud_init = true
    cloud_init_storage_pool = "local-zfs"
    
    # Packer Boot Commands
    boot_command = [
        "<esc><wait><esc><wait>",
        "<f6><wait><esc><wait>",
        "<bs><bs><bs><bs><bs>",
        "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
        "--- <enter>"
    ]
    boot = "c"
    boot_wait = "5s"

    # Packer HTTP Server Settings for Autoinstall
    http_directory = "http" 
    ssh_username = "your-user-name"
    

    # Bind IP Address and Port Statically (Optional)
    http_bind_address = "10.69.69.170"
    http_port_min = 9000
    http_port_max = 9005
    
    # Authentication (CHOOSE ONLY ONE)
    
    # Use private SSH Key file (Option 1 - RECOMMENDED)
    ssh_private_key_file = "~/.ssh/id_rsa"
    ssh_timeout = "10m" # Raise the timeout, when installation takes longer
    
    # Use SSH Password (Option 2)
    # ssh_password = "your-password"
}
# Build Definition to create the VM Template
build {
    name = "ubuntu-server-focal"
    sources = ["source.proxmox.ubuntu-server-focal"]
    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
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
    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source = "files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }
    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }
    # Add additional provisioning scripts here
    # ...
}
