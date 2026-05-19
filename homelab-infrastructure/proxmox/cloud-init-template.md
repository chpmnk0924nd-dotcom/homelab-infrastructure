# Proxmox Cloud-Init Ubuntu Template

## Overview

This document describes how I built a reusable Ubuntu cloud-init template in Proxmox. The goal was to create a standardized VM template that can be cloned quickly and automatically configured on first boot.

## Goals

- Create a reusable Ubuntu Server template
- Use cloud-init for automated configuration
- Automatically create a user account
- Configure hostname and FQDN
- Assign static IP addresses during cloning
- Install baseline packages automatically
- Install Docker automatically
- Install prometheus-node-exporter automatically
- Make new VMs monitoring-ready immediately

## Environment

- Hypervisor: Proxmox VE
- Template VM ID: 9000
- Template name: ubuntu-cloud-template
- Base image: Ubuntu Server cloud image
- Storage: local-lvm
- Network bridge: vmbr0
- Cloud-init user: nick

## Template Build Process

The Ubuntu cloud image was downloaded to the Proxmox ISO/template directory.

```bash
cd /var/lib/vz/template/iso
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img

A new VM was created for the template.

```bash
qm create 9000 \
  --name ubuntu-cloud-template \
  --memory 4096 \
  --cores 2 \
  --net0 virtio,bridge=vmbr0 \
  --scsihw virtio-scsi-pci \
  --agent enabled=1 \
  --ostype l26
```

The Ubuntu cloud image was imported as a disk.

```bash
qm importdisk 9000 noble-server-cloudimg-amd64.img local-lvm
```

The imported disk was attached to the VM.

```bash
qm set 9000 --scsi0 local-lvm:vm-9000-disk-0
```

The VM was configured to boot from the imported disk.

```bash
qm set 9000 --boot c --bootdisk scsi0
```

A cloud-init drive was added.

```bash
qm set 9000 --ide2 local-lvm:cloudinit
```

Serial console support was added.

```bash
qm set 9000 --serial0 socket --vga serial0
```

Cloud-init networking was configured.

```bash
qm set 9000 --ipconfig0 ip=dhcp
```

The default cloud-init user was configured.

```bash
qm set 9000 --ciuser nick
qm set 9000 --cipassword 'REDACTED'
```

The disk was resized for normal server usage.

```bash
qm resize 9000 scsi0 40G
```

## Cloud-Init User Data

A custom cloud-init user-data file was created to automate first-boot configuration.

File path:

```text
/var/lib/vz/snippets/ubuntu-template-userdata.yaml
```

Example configuration:

```yaml
#cloud-config
preserve_hostname: false
manage_etc_hosts: true

hostname: ubuntu-monitor01
fqdn: ubuntu-monitor01.homelab.local

ssh_pwauth: true
disable_root: false

users:
  - name: nick
    groups: sudo, docker
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    lock_passwd: false

chpasswd:
  expire: false
  users:
    - name: nick
      password: REDACTED
      type: text

package_update: true
package_upgrade: true

packages:
  - qemu-guest-agent
  - curl
  - wget
  - htop
  - net-tools
  - docker.io
  - prometheus-node-exporter

runcmd:
  - systemctl enable --now qemu-guest-agent
  - systemctl enable --now docker
  - systemctl enable --now prometheus-node-exporter
```

The custom cloud-init file was attached to the template.

```bash
qm set 9000 --cicustom "user=local:snippets/ubuntu-template-userdata.yaml"
```

The VM was converted into a Proxmox template.

```bash
qm template 9000
```

## Testing the Template

A new VM was cloned from the template.

```bash
qm clone 9000 210 --name ubuntu-monitor01 --full
```

A static IP address was assigned.

```bash
qm set 210 --ipconfig0 ip=192.168.10.151/24,gw=192.168.10.1
```

The VM was started.

```bash
qm start 210
```

## Validation Steps

After the VM booted, I verified the following:

```bash
hostname
hostname -f
ip -br a
docker --version
systemctl status prometheus-node-exporter --no-pager
curl http://127.0.0.1:9100/metrics
```

Expected validation results:

| Check | Expected Result |
|---|---|
| Hostname | Custom hostname applied |
| FQDN | Custom homelab.local name applied |
| Network | Static IP assigned |
| Docker | Installed successfully |
| Node Exporter | Active and running |
| Metrics Endpoint | Responds on port 9100 |

## Results

The template successfully created a VM that automatically configured itself on first boot.

Validated results:

- Hostname applied successfully
- FQDN applied successfully
- Static IP applied successfully
- Docker installed automatically
- prometheus-node-exporter installed automatically
- Node exporter service enabled and running
- Metrics endpoint accessible
- VM ready for Prometheus monitoring

## Skills Practiced

- Proxmox VM template creation
- Cloud-init automation
- Linux server provisioning
- VM cloning
- Static IP assignment
- First-boot automation
- Automated package installation
- Monitoring agent deployment
- Infrastructure standardization

## Troubleshooting Performed

During setup, I troubleshot:

- Imported disk showing as `unused0`
- Cloud-init password login failures
- User creation issues
- Hostname not applying automatically
- Serial console behavior
- First boot cloud-init failures
- Testing new clones after template changes

## Lessons Learned

- Cloud-init is most reliable when tested on a fresh clone.
- Password and user settings must be configured before first boot.
- Hostname automation requires proper cloud-init configuration.
- A reusable template saves significant time compared to manual VM creation.
- Standardized templates make monitoring and automation easier.
- Infrastructure should be repeatable and documented.

## Future Improvements

- Replace password login with SSH key authentication
- Add Ansible post-deployment configuration
- Add Terraform Proxmox provisioning
- Create specialized Kubernetes worker templates
- Create Docker host templates
- Add automatic DNS registration
- Add automatic Prometheus target registration