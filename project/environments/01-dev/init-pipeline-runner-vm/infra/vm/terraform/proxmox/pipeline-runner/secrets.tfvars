/*
## HTTP server configuration

http_host_ip    = "" # This is the IP of the current machine used for the temporary HTTP server for hosting cloud-init script
http_gateway_ip = "" # This is the IP of the current network gateway used for the temporary HTTP server for hosting cloud-init script
*/

## Proxmox connection configuration

proxmox_vm_name          = "" # This is the name of the VM being created
proxmox_vm_template_name = "" # This is the name of the template used to create the VM
proxmox_target_node      = "" # This is the name of the destination "node" on Proxmox

## Proxmox secrets

proxmox_api_url          = "" # This is the Proxmox server's API endpoint, format is "https://{PROXMOX_IP}:{PROXMOX_PORT}/api2/json"
proxmox_api_token_id     = "" # This is the API Token ID, format is "root@pam!{TOKEN_NAME}"
proxmox_api_token_secret = "" # This is the API Token Secret, format is "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

## cloud-init configuration
cloudinit_ssh_username = "" # This is the default username that cloud-init uses
cloudinit_ssh_key      = "" # This is the public SSH key that cloud-init uses