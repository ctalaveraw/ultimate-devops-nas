# Drive Config

This is the Ansible playbook handing drive mounting, SnapRAID setup and array sync scheduling with cron.

Other deployments will handle configuration of OS configuration and services deployment.

\*\* IMPORTANT \*\*

This deployment must be done ****FIRST**** so the Ultimate DevOps NAS has storage to mount for Samba shares.

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
git clone https://github.com/ctalaveraw/ultimate-devops-nas && cd ./ultimate-devops-nas/code/environments/dev/init-ultimate-nas/config/ansible/drive-config
```

2. Create custom inventory/config files to a directory called `drive-config`:

```Bash
cp -rfpv ./inventories/sample ./inventories/drive-config
```

3. Review the deployment variables in `group_vars/all.yml` and copy the contents to a custom env file at `inventories/drive-config/group_vars/nas.yml`:

```Bash
cat ./group_vars/all.yml > ./inventories/drive-config/group_vars/all.yml
```

4. Declare all desired NAS deployment settings; edit `inventories/drive-config/group_vars/all.yml` and save changes:

```Bash
vim ./inventories/drive-config/group_vars/nas.yml
``` 

5. Update the `inventories/drive-config/inventory` file to point to the correct master and target host IPs

```Bash
vim ./inventories/drive-config/inventory
```

6. Install all Ansible role dependencies:

```Bash
ansible-galaxy install -r ./requirements.yml
```

7. Execute the Ansible playbook; this runs the initial setup and deployments:

```Bash
ansible-playbook -i ./inventories/drive-config/inventory ./nas.yml -b -K
```

8. (Optional) After initial deployment, run individual roles to add/modify specific service(s):

```Bash
ansible-playbook -i ./inventories/drive-config/inventory ./nas.yml -b -K --tag=snapraid,mergerfs
```
