# Ultimate Ansible NAS - Kubernetes Edition

[![license](https://img.shields.io/github/license/DAVFoundation/api_doc.svg?style=flat-square)](https://github.com/davestephens/ansible-nas/blob/master/LICENSE)

This project draws inspiration from:

- [Ansible NAS](https://github.com/davestephens/ansible-nas) - NAS project by David Stephens
- [Wolfgang's Home Server Playbook](https://github.com/notthebee/infra) - Automated Home Server by Linux YouTuber [Wolfgang](https://www.youtube.com/c/WolfgangsChannel)

## What Ultimate Ansible NAS Does

Use the Ultimate Ansible NAS to set up any of the following applications listed below on your home server.

Use an owned domain name to configure applications to be accessible externally from your home network; they'll be configured with a sensible hostname and DNS gets updated accordingly if your home IP address changes.

## List of Self-Hosted NAS Applications

### Host Services

#### ~~CI/CD Pipelines & Server Automation~~

- ~~[n8n](https://n8n.io/) - Nodemation, a node based workflow and automation service like IFTTT.~~
- ~~[Woodpecker-CI](https://woodpecker-ci.org) - a simple CI engine with great extensibility, forked from Drone.~~
- ~~[GitLab](https://about.gitlab.com/features/) - Self-hosted GitHub clone of the highest order~~

#### Front-End

- [Dashy](https://dashy.to/) - A self-hosted startpage for your server. Easy to use visual editor, status checking, widgets, themes and tons more!
- ~~[Flame](https://github.com/pawelmalak/flame) (Another static home page)~~
- ~~[Homer](https://hub.docker.com/r/b4bz/homer) (A static home page)~~
- ~~[Krusader](https://krusader.org/) - Twin panel file management for your desktop~~
- ~~[Organizr](https://organizr.app/) - ORGANIZR aims to be your one stop shop for your Servers Frontend.~~

#### Infrastructure & Application Management

- [Grafana](https://grafana.com/) - Query, visualize, alert on, and understand your data no matter where it’s stored (via stats role).
- [healthchecks.io](https://healthchecks.io/) - Ensure your NAS is online and get notified otherwise
- [Portainer](https://portainer.io/) - for managing Docker and running custom images
- [Prometheus](https://prometheus.io/) - Time series database and monitoring system (via stats role).
- ~~[Netdata](https://my-netdata.io/) - An extremely comprehensive system monitoring solution~~
- ~~[Tautulli](http://tautulli.com/) - Monitor Your Plex Media Server~~
- ~~[Watchtower](https://github.com/v2tec/watchtower) - Monitor your Docker containers and update them if a new version is available~~

#### ~~Microservices~~

- ~~[Gotify](https://gotify.net/) - Self-hosted server for sending push notifications~~
- ~~[Mosquitto](https://mosquitto.org/) - An open source MQTT broker~~

#### Networking & Remote Access

- [bunkerized-nginx](https://github.com/bunkerity/bunkerized-nginx) (A NGINX-based web server focused on security; needs Certbot + fail2ban)
- [Cloudflare DDNS](https://hub.docker.com/r/joshuaavalon/cloudflare-ddns/) - automatically update Cloudflare with your IP address
- [Guacamole](https://guacamole.apache.org/) - Web based remote desktop gateway, supports VNC, RDP and SSH
- [PiHole + Unbound](https://github.com/chriscrowe/docker-pihole-unbound) (An all-in-one DNS solution with built-in ad-blocking)
- [UniFi Controller](https://hub.docker.com/r/linuxserver/unifi-controller) (A controller for UniFi devices such as routers and Access Points)
- ~~[SWAG](https://hub.docker.com/r/linuxserver/swag) (A reverse proxy with built-in support for dynamic DNS, Certbot and fail2ban)~~
- ~~[DuckDNS](https://hub.docker.com/r/linuxserver/duckdns/) (A dynamic DNS client for DuckDNS)~~
- ~~[netboot.xyz](https://netboot.xyz/) - a PXE boot server~~

#### Security

- [Authelia](https://hub.docker.com/r/authelia/authelia) (An authentication provider)
- [Traefik](https://traefik.io/) - Web proxy and SSL certificate manager
- [Vaultwarden](https://hub.docker.com/r/vaultwarden/server) (A FOSS Bitwarden fork written in Rust)
- [Wireguard](https://hub.docker.com/r/linuxserver/wireguard) (A VPN server)

#### Utilities

- ~~[Code Server](https://code.visualstudio.com/) - Powerful IDE from Microsoft accessible through the browser~~
- [MariaDB](https://hub.docker.com/r/linuxserver/mariadb) (A database server for Nextcloud)
- [Syncthing](https://syncthing.net/) - sync directories with another device

### Media Streaming

#### Content Aggregation & Management

- [Bazarr](https://github.com/morpheus65535/bazarr) - companion to Radarr and Sonarr for downloading subtitles
- [Lidarr](https://github.com/lidarr/Lidarr) - Music collection manager for Usenet and BitTorrent users
- [Mylar](https://github.com/evilhero/mylar) - An automated Comic Book downloader (cbr/cbz) for use with SABnzbd, NZBGet and torrents
- [Radarr](https://radarr.video/) - for organising and downloading movies
- [Sonarr](https://sonarr.tv/) - for downloading and managing TV episodes
- [Prowlarr](https://github.com/Prowlarr/Prowlarr) - Indexer aggregator for Sonarr, Radarr, Lidarr, etc.
- [Jackett](https://github.com/Jackett/Jackett) - API Support for your favorite torrent trackers
- [YouTubeDL-Material](https://github.com/Tzahi12345/YoutubeDL-Material) - Self-hosted YouTube downloader built on Material Design
- ~~[CouchPotato](https://couchpota.to/) - for downloading and managing movies~~
- ~~[Overseerr](https://docs.overseerr.dev) - open source software application for managing requests for your media library; front end replacement for Sonarr and Radarr~~

#### Content Downloading

- [arch-delugevpn](https://hub.docker.com/r/binhex/arch-delugevpn) (An Arch Linux container running Deluge and an Wireguard/OpenVPN client with a kill switch)
- ~~[Transmission](https://transmissionbt.com/) - BitTorrent client (with OpenVPN if you have a supported VPN provider)~~
- ~~[pyLoad](https://pyload.net/) - A download manager with a friendly web-interface~~

#### Content Streaming

- [Airsonic](https://airsonic.github.io/) - catalog and stream music
- [Booksonic](https://hub.docker.com/r/linuxserver/booksonic) (An audiobook server)
- [Calibre-web](https://github.com/janeczku/calibre-web) - Provides a clean interface for browsing, reading and downloading eBooks using an existing Calibre database.
- [Jellyfin](https://jellyfin.github.io) - The Free Software Media System
- [Komga](https://komga.org/) - a media server for your comics, mangas, BDs and magazines
- [Navidrome](https://www.navidrome.org/) - Modern Music Server and Streamer compatible with Subsonic/Airsonic
- [PhotoPrism](https://hub.docker.com/r/linuxserver/photoprism) - A photo library
- ~~[Miniflux](https://miniflux.app/) - An RSS news reader~~
- ~~[Paperless_ng](https://github.com/jonaswinkler/paperless-ng) - Scan, index and archive all your physical documents~~
- ~~[Ubooquity](http://vaemendis.net/ubooquity/) - Book and comic server~~
- ~~[Piwigo](https://piwigo.org/) - Photo Gallery Software~~
- ~~[Plex](https://www.plex.tv/) - Plex Media Server~~

### Miscellaneous

#### Private Cloud Storage

- [Nextcloud](https://nextcloud.com/) - A self-hosted Dropbox alternative

#### Smart Home Management

- [Home Assistant](https://www.home-assistant.io) - Open source home automation
- ~~[openHAB](https://www.openhab.org/) - A vendor and technology agnostic open source automation software for your home; Alternative to Home Assistant~~

## Tech Stack

- Hypervisor: `proxmox`
- Guest OS: `Ubuntu Desktop LTS`
- Application Infrastructure - `containerd` & `kubernetes`
- Application Provisioning - `ansible`
- Container Provisioning - `docker-compose`
- Filesystem - `zfs`
- Storage Pooling - `mergerfs`
- Redundancy - `snapraid`
- Remote Access - `wireguard` VPN

## Installation

TBD

## Documentation

TBD

## Requirements

TBD
