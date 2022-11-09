# Proxmox connection configuration

variable "proxmox_vm_template_name" {
    type = string
    sensitive = false
    default = "ubuntu-server-jammy"
}

variable "proxmox_target_node" {
    type = string
    sensitive = false
    default = "pve"
}

# Proxmox Secrets

variable "proxmox_api_url" {
    type = string
    sensitive = false
}

variable "proxmox_api_token_id" {
    type = string
    sensitive = true
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}
