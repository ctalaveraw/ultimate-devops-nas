## HTTP server configuration
variable "vm_host_ip" {
  type      = string
  sensitive = false
}

variable "gateway_ip" {
  type      = string
  sensitive = false
  default   = "192.168.1.1"
}

variable "dns_ip" {
  type      = string
  sensitive = false
  default   = "1.1.1.1"
}

## cloud-init configuration
variable "cloudinit_ssh_username" {
  type      = string
  sensitive = false
  default   = "root"
}

variable "cloudinit_ssh_key" {
  type      = string
  sensitive = true
}

# Proxmox connection configuration
variable "proxmox_vm_name" {
  type      = string
  sensitive = false
  default   = "ultimate-nas"
}

variable "proxmox_vm_template_name" {
  type      = string
  sensitive = false
  default   = "nas-vm-template"
}

variable "proxmox_vm_disk_storage_pool" {
  type      = string
  sensitive = false
  default   = "local-zfs"
}

variable "proxmox_target_node" {
  type      = string
  sensitive = false
  default   = "pve"
}

# Proxmox Secrets
variable "proxmox_api_url" {
  type      = string
  sensitive = false
}

variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}
