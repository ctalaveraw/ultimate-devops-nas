# Ultimate NAS Deploy

This is the main deployment playbook for Ultimate DevOps NAS.

Other deployments will handle configuration of hypervisor and provisioning/mounting of NAS storage.

## Requirements

### Host running the deployment

#### Required configuration

- SSH connection to the target host

#### Required Packages

- `python3`
- `ansible`
- `git`

### Target Host to create NAS

#### Required configuration

- Target host running Ubuntu LTS

#### Required Packages

- `python3`

## Installation steps

1. Clone the repository and navigate to the playbook deployment directory:

```Bash
git clone https://github.com/ctalaveraw/ultimate-devops-nas && cd ./ultimate-devops-nas/code/environments/dev/init-ultimate-nas/config/ansible/ultimate-nas-deploy
```

2. Create custom inventory/config files to a directory called `devops-nas`:

```Bash
cp -rfpv ./inventories/sample ./inventories/devops-nas
```

3. Review the deployment variables in `group_vars/all.yml` and copy the contents to a custom env file at `inventories/devops-nas/group_vars/nas.yml`:

```Bash
cat ./group_vars/all.yml > ./inventories/devops-nas/group_vars/nas.yml
```

4. Declare all desired NAS deployment settings; apps can be added to NAS deployment by adding a line to config to enable (ex. `plex_enabled="true"`). Edit `inventories/devops-nas/group_vars/nas.yml` and save changes:

```Bash
vim ./inventories/devops-nas/group_vars/nas.yml
``` 

5. Update the `inventories/devops-nas/inventory` file to point to the correct master and target host IPs

```Bash
vim ./inventories/devops-nas/inventory
```

6. Install all Ansible role dependencies:

```Bash
ansible-galaxy install -r ./requirements.yml
```

7. Execute the Ansible playbook; this runs the initial setup and deployments:

```Bash
ansible-playbook -i ./inventories/devops-nas/inventory ./nas.yml -b -K
```

8. (Optional) After initial deployment, run individual roles to add/modify specific service(s):

```Bash
ansible-playbook -i ./inventories/devops-nas/inventory ./nas.yml -b -K --tag=plex,jellyfin
```
