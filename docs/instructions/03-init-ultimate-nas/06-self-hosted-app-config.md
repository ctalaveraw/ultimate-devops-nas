# Config for each self-hosted app

See the [wiki](https://wiki.servarr.com/) on using "**arr" apps for more details on config and [TRaSH Guides](https://trash-guides.info/Hardlinks/Hardlinks-and-Instant-Moves/) tutorial on hardlinks / instant moves using SMB shares.

## Dashy
See sample [`dashy_conf.json`](content/dashy_conf.json)

## Radarr
Add `/movies` path (Samba share mounted here) under "Settings > Media Management > Root Folders"

## Prowlarr

- Add indexers to sync
- Add downloader (Deluge or Transmission)
- Add integration to other "**arr" apps
   - Grab API token from "Settings > General > Security > API Key"
   - For Mylar, this is in "Settings > Web Interface"