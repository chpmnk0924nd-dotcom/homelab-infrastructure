# Backup and Disaster Recovery

## Overview

This document describes my Proxmox backup and disaster recovery workflow. My goal is to make sure virtual machines can be restored quickly from NAS backups and verified after recovery.

## Environment

- Hypervisor: Proxmox VE
- Backup storage: NAS storage device
- Backup schedule: Every Sunday
- Backup type: Proxmox VM backups
- Test restore VMs:
  - Ubuntu Server
  - Kali Linux

## Backup Strategy

Proxmox is configured to back up selected virtual machines to NAS storage on a weekly schedule. These backups provide recovery options in case a VM becomes corrupted, misconfigured, or unavailable.

## Restore Testing

I tested restoring virtual machines from NAS backups to confirm that the backup files were usable.

### Restore Test Results

| VM | Restore Source | Result | Estimated Recovery Time |
|---|---|---|---|
| Ubuntu Server | NAS backup | Successful | 7-10 minutes |
| Kali Linux | NAS backup | Successful | Under 5 minutes restore, 7-10 minutes total recovery |

## Recovery Validation Steps

After restoring a VM, I verified:

- VM boots successfully
- Network connectivity works
- IP address is reachable
- Operating system login works
- Services start correctly
- Restored VM can communicate with the network

## Skills Practiced

- Proxmox backup management
- NAS backup storage integration
- VM restore testing
- Disaster recovery validation
- Recovery Time Objective testing
- Linux network verification
- Post-restore troubleshooting

## Lessons Learned

- Backups are only useful if they can be restored successfully.
- Restore testing is an important part of disaster recovery.
- A VM can restore quickly, but total recovery includes booting, checking network settings, and verifying services.
- Documenting the recovery process makes future restores faster and more reliable.

## Current Recovery Estimate

Based on testing, my estimated recovery time is:

```text
7-10 minutes per VM