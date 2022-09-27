#!/bin/bash

# Removes apt errors while updating
echo "Removes apt errors while updating..."
rm /etc/apt/sources.list.d/pve-enterprise.list

# Edit sources list to include community repo
echo "Edit sources list to include community repo..."
echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list

# Adding repo PGP key for Proxmox VE 7.1
echo "Adding repo PGP key..."
wget https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg 

# Verify GPG key
echo "Verify PGP key..."
sha512sum /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg

# Update system
echo "Update system..."
apt -y full-upgrade