# Proxmox Secrets

variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
}

# Proxmox connection configuration

variable "proxmox_target_node" {
    type = string
    default = "pve"
}

variable "proxmox_vm_template_name" {
    type = string
    default = "ubuntu-server-jammy"
}
