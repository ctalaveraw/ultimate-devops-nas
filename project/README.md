# Ultimate NAS overview

## Environment Layout

The enviornment will be seperated into `dev`, `staging`, and `prod`; this will allow for breaking changes to be isolated during upgrades and testing.

## Environment provisioning

The following toolset will be used for the environment:

### Build

- Hypervisor - `proxmox`
- Guest OS - `ubuntu`
- Machine image creation - `packer`
  - tutorial [here](https://www.youtube.com/watch?v=1nf3WOEFq1Y)
- Image base configuration - `cloud-init`
- VM provisioning - `terraform`
  - tutorial [here](https://www.youtube.com/watch?v=dvyeoDBUtsU)
  - docs on Proxmox Terraform provider [here](https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/guides/installation.md)

### Provision

- Application configuration - `ansible`
- Container infrastructure provisioning - `ansible`

#### To be added later

- CI/CD engine - `gitlab` or `jenkins`
  - Unit testing
  - Security testing
- Artifact registry
