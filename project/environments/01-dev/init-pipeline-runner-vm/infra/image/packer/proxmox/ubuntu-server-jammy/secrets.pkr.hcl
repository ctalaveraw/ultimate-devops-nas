##  Optional ISO configuration

# proxmox_iso_checksum = "" # This is the checksum of the ISO used for the template (optional)
# proxmox_iso_storage_pool = "" # This is the location where Proxmox will store the VM ISO image (uncomment and define if not default location of "local")

## ISO path configuration

proxmox_ubuntu_iso_version = "" # This is the version of Ubuntu used in the URL of the ISO Image used for this template
# OR
# proxmox_ubuntu_iso_local_path = "" # This is the local path of the ISO Image used for the template

## HTTP server configuration

http_host_ip = "" # This is the IP of the current machine used for the temporary HTTP server for hosting cloud-init script
http_host_port = "" # This is the open port on the current machine used for the temporary HTTP server for hosting cloud-init script

## Proxmox VM configuration

proxmox_vm_template_name = "" # This is the name of the VM Template that will be created
# proxmox_vm_disk_storage_pool = "" # This is the location where Proxmox will store the VM hard disk (uncomment and define if not using "local-zfs")

## Proxmox connection configuration

proxmox_target_node = "" # This is the name of the destination "node" on Proxmox
proxmox_api_url = "" # This is the Proxmox server's API endpoint, format is "https://{PROXMOX_IP}:{PROXMOX_PORT}/api2/json"
proxmox_api_token_id = "" # This is the API Token ID, format is "root@pam!{TOKEN_NAME}"
proxmox_api_token_secret = "" # This is the API Token Secret, format is "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

## SSH configuration

proxmox_ssh_username = "" # This is the username used for SSH connections between the current machine and the Proxmox VE machine

# proxmox_ssh_password = "" # This is the password for the username used for SSH connections between the current machine and the Proxmox VE machine
# OR
proxmox_ssh_keyfile_path = "" # This is the path of the authorized key used for SSH connections between the current machine and the Proxmox VE machine
