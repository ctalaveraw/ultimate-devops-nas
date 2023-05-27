# Ultimate VPN to Home

A simple Ansible deployment that deploys Docker containers that configures a Wireguard VPN server with PiHole, Dynamic DNS on a local Raspberry Pi or other local host of choice.

## Features
* Wireguard + WebUI with `wg-easy`
* DNS black hole + ad-blocking with `pihole`
* Dynamic DNS
* Automated and unattended upgrades

## Requirements
* A Raspberry Pi or other local host running any of the following supported Linux distros:
  * Ubuntu Server 22.04
  * Ubuntu Server 20.04
  * Debian 11
  * Rocky Linux 9
  * Rocky Linux 8
