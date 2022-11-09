# Creates a new VM from a previously-created VM template

resource "proxmox_vm_qemu" "pipeline-runner" {
    /*
    Sensible defaults for VM settings are used
    Documentation on minimum system requirements for self-hosting GitLab can be found here:
    https://docs.gitlab.com/ee/install/requirements.html
    */

    # VM General Settings
    target_node = "${var.proxmox_target_node}"
    name = "${var.proxmox_vm_name}"
    vmid = 101
    desc = "VM to host containers for running GitLab, which will host the CI/CD pipeline"

    # VM OS Settings
    clone = "${var.proxmox_vm_template_name}"
    
    # VM System Settings
    agent = 1 # Set to "1" to enable QEMU Guest Agent

    # VM Advanced General Settings
    onboot = true 

    # VM Memory Settings
    memory = 4096

    # VM CPU Settings
    cores = 4
    sockets = 1
    cpu = "host" # Set to "host" for best CPU emulation performance
    
    # VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    # VM Disk Settings
    disk { # This block must mirror the storage used in VM template
        storage= "${var.proxmox_vm_disk_storage_pool}"
        type = "virtio"
        format = "raw"
        size = "50G"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

    # IP Address and Gateway
    ipconfig0 = "ip=${var.http_host_ip}/24,gw=${var.http_gateway_ip}"
    nameserver = "${var.http_gateway_ip}"
    
    # Default User
    ciuser = "${var.cloudinit_ssh_username}"
    
    # Add the public SSH key
    sshkeys = <<EOF
    ${var.cloudinit_ssh_key}
    EOF
}