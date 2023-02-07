# Creates a new VM from a previously-created VM template

resource "proxmox_vm_qemu" "nas-host" {
  /*
    Sensible defaults for VM settings are used
    Documentation on minimum system requirements for self-hosting GitLab can be found here:
    https://docs.gitlab.com/ee/install/requirements.html
    */

  ## VM General Settings
  target_node = var.proxmox_target_node
  name        = var.proxmox_vm_name
  vmid        = 202
  desc        = "VM to host containers for running all services for Ultimate NAS"

  ## VM OS Settings
  clone = var.proxmox_vm_template_name
  boot  = "order=virtio0" # by default, VM disk is type "virtio", named "virtio0"
  bios  = "seabios"       # use 'omvf" for PCI-e passthrough

  ## VM System Settings
  agent = 1 # Set to "1" to enable QEMU Guest Agent

  ## VM Advanced General Settings
  onboot = true

  ## VM Memory Settings
  memory = 16384

  ## VM CPU Settings
  cores   = 6
  sockets = 1
  cpu     = "host" # Set to "host" for best CPU emulation performance

  ## VM Network Settings
  network {
    bridge = "vmbr0"
    model  = "virtio"
  }

  ## VM Disk Settings

  # OS Disk
  disk {        # This block must mirror the storage used in VM template
    ssd     = "0" # set to "1" if disk is SSD
    type    = "virtio"
    size    = "50G"
    storage = var.proxmox_vm_disk_storage_pool
    format  = "raw"
  }

  ## VM Cloud-Init Settings
  os_type = "cloud-init"

  ## IP Address and Gateway
  ipconfig0  = "ip=${var.vm_host_ip}/24,gw=${var.gateway_ip}"
  nameserver = var.dns_ip

  ## Default User
  ciuser = var.cloudinit_ssh_username

  ## Add the public SSH key
  sshkeys = <<EOF
    ${var.cloudinit_ssh_key}
    EOF
}