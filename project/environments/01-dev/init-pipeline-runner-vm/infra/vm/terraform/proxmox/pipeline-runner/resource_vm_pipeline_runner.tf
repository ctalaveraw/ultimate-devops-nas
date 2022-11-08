# Proxmox Full-Clone
# ---
# Create a new VM from a clone

# VMID generator
resource "random_integer" "vmid" {
  min = 100
  max = 199
}

resource "proxmox_vm_qemu" "pipeline-runner" {
    
    # VM General Settings
    target_node = "${var.proxmox_target_node}"
    vmid = random_integer.vmid
    name = "pipeline-runner"
    desc = "VM to host containers for running GitLab, which will host the CI/CD pipeline"

    # VM Advanced General Settings
    onboot = true 

    # VM OS Settings
    clone = "your-clone"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 1
    sockets = 1
    cpu = "host"    
    
    # VM Memory Settings
    memory = 1024

    # VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

    # (Optional) IP Address and Gateway
    # ipconfig0 = "ip=0.0.0.0/0,gw=0.0.0.0"
    
    # (Optional) Default User
    # ciuser = "your-username"
    
    # (Optional) Add your SSH KEY
    # sshkeys = <<EOF
    # #YOUR-PUBLIC-SSH-KEY
    # EOF
}