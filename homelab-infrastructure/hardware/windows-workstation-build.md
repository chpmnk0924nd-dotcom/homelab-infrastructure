# Windows 11 Workstation Build

## Overview

This document describes the primary Windows 11 workstation used in the homelab environment.

The workstation is used for:

- Infrastructure management
- Hyper-V virtualization
- Remote administration
- Documentation
- Monitoring access
- Development and scripting
- Kubernetes management
- Windows administration
- Infrastructure troubleshooting

---

## System Information

| Component | Details |
|---|---|
| Hostname | WIN11-01 |
| Operating System | Microsoft Windows 11 Pro |
| Version | 25H2 |
| OS Build | 26200 |
| Architecture | x64-based PC |
| Domain | homelab.local |
| System Type | Desktop Workstation |
| Install Date | 02/08/2026 |

---

## Motherboard

| Component | Details |
|---|---|
| Manufacturer | NZXT |
| Model | N9 X870E |
| BIOS Vendor | American Megatrends International, LLC. |
| BIOS Version | 3.25 |
| BIOS Date | 05/14/2025 |
| BIOS Mode | UEFI |

---

## CPU

| Component | Details |
|---|---|
| CPU Model | AMD Ryzen 9 9950X3D |
| Architecture | AMD64 |
| Core Count | 16 Cores |
| Thread Count | 32 Threads |
| Clock Speed | ~4.3 GHz |
| Virtualization | Hyper-V Enabled |

### CPU Role in Homelab

The workstation CPU supports:

- Hyper-V virtualization
- Infrastructure administration
- Multiple management applications
- Browser-based monitoring dashboards
- Scripting and automation
- Development workloads
- Virtual machine experimentation

---

## Memory

| Component | Details |
|---|---|
| Installed RAM | 96 GB DDR5 |
| Memory Speed | 5600 MT/s |
| Memory Manufacturer | Micron Technology |
| Module Count | 2 DIMMs |
| Individual Module Size | 48 GB |

### Current Memory Usage During Documentation

| Metric | Value |
|---|---|
| Total Physical Memory | ~96 GB |
| Available Memory | ~70 GB |
| Virtual Memory Max | ~109 GB |

The memory configuration supports:

- Hyper-V workloads
- Large browser sessions
- Multiple infrastructure dashboards
- Development workloads
- Virtual machines
- Documentation workflows

---

## Networking

| Interface | Purpose | IP Address |
|---|---|---|
| Ethernet 2 | Primary homelab LAN | 192.168.10.10 |
| 10G Proxmox Link | High-speed infrastructure link | 192.168.20.10 |
| Hyper-V Virtual Switch | Virtual networking | 192.168.10.50 |
| Wi-Fi | Wireless connectivity | Disconnected |

### Network Features

The workstation networking environment supports:

- High-speed Proxmox connectivity
- Infrastructure management
- Hyper-V virtual networking
- Remote server administration
- DNS resolution testing
- Kubernetes access
- Monitoring access

---

## Virtualization Environment

### Hyper-V

Hyper-V is enabled on the workstation for virtualization testing and lab experimentation.

Features include:

- Virtual switch networking
- VM experimentation
- Infrastructure testing
- Windows virtualization workflows

### Virtualization Security

| Feature | Status |
|---|---|
| Virtualization-Based Security | Running |
| Hypervisor Enforced Code Integrity | Enabled |
| UEFI Security Features | Enabled |

---

## Storage and Operating Environment

| Component | Details |
|---|---|
| Windows Directory | C:\WINDOWS |
| System Directory | C:\WINDOWS\system32 |
| Boot Device | HarddiskVolume5 |
| Page File | C:\pagefile.sys |

---

## Infrastructure Role

This workstation acts as the primary management and administration endpoint for the homelab environment.

Primary responsibilities include:

- Managing Proxmox
- Accessing Grafana dashboards
- Kubernetes administration
- Editing infrastructure documentation
- Managing Docker services
- Accessing Windows Server infrastructure
- Managing DNS and Active Directory
- Security monitoring and troubleshooting

---

## Management Software Used

The workstation is used to manage:

- Proxmox VE
- Grafana
- Prometheus
- Loki
- CrowdSec
- Keycloak
- Portainer
- Uptime Kuma
- Nginx Proxy Manager
- Kubernetes
- Windows Server
- Active Directory
- DNS infrastructure

---

## Skills Practiced

- Windows administration
- Hyper-V virtualization
- Infrastructure management
- DNS troubleshooting
- Active Directory administration
- Kubernetes management
- Linux remote administration
- PowerShell usage
- Infrastructure documentation
- Network troubleshooting
- Virtualization workflows

---

## Operational Stability

The workstation has demonstrated:

- Stable uptime
- Reliable virtualization support
- Strong multitasking performance
- Stable infrastructure management capabilities
- High memory availability for lab workloads

---

## Lessons Learned

- High memory capacity greatly improves virtualization workflows.
- Infrastructure management benefits from dedicated high-speed networking.
- Hyper-V virtual networking provides flexibility for lab testing.
- Workstation hardware planning is important for infrastructure engineering.
- Documentation improves infrastructure troubleshooting and operational awareness.

---

## Future Improvements

Planned future upgrades include:

- Dedicated workstation backup strategy
- Additional NVMe storage
- GPU virtualization experiments
- Expanded Hyper-V infrastructure
- PowerShell automation improvements
- Centralized Windows monitoring
- Additional 10Gb networking
- Infrastructure scripting expansion