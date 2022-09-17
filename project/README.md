# Ultimate NAS overview

## Environment Layout

The enviornment will be seperated into `dev`, `staging`, and `prod`; this will allow for breaking changes to be isolated during upgrades and testing.

## Environment provisioning

The following toolset will be used for the environment:

### Build

- Hypervisor - `proxmox`
- Guest OS - `ubuntu`
- Machine image creation - `packer`
- Image base configuration - `cloud-init`
- Infrastructure provisioning - `terraform`

### Provision

- Application configuration - `ansible`
- Container infrastructure provisioning - `ansible`

#### To be added later

- CI/CD engine - `gitlab` or `jenkins`
  - Unit testing
  - Security testing
- Artifact registry
