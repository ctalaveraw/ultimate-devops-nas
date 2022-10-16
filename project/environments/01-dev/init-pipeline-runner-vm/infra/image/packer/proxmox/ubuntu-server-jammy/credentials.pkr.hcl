## ISO path configuration

proxmox_ubuntu_iso_url = ""
proxmox_ubuntu_iso_checksum = ""
# OR
# proxmox_ubuntu_iso_local_path = ""

## HTTP server configuration

http_host_ip = ""
http_host_port = ""

## Proxmox connection configuration

proxmox_api_url = "" # This is the Proxmox server's API endpoint, format is "https://{PROXMOX_IP}:{PROXMOX_PORT}/api2/json"
proxmox_api_token_id = "" # This is the API Token ID, format is "root@pam!{TOKEN_NAME}"
proxmox_api_token_secret = "" # This is the API Token Secret, format is "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
proxmox_target_node = "" # This is the name of the destination "node" on Proxmox

## SSH configuration

# proxmox_ssh_keyfile_path = ""
# OR
proxmox_ssh_username = ""
proxmox_ssh_password = ""
