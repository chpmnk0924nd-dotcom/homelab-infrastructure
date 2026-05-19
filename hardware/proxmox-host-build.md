# Proxmox Host Hardware Build

## Overview

This document describes the primary Proxmox virtualization host used in the homelab environment.

The server is responsible for:

- Virtual machine hosting
- Kubernetes infrastructure
- Monitoring stack hosting
- Reverse proxy services
- Identity management services
- Security monitoring
- Containerized infrastructure services

---

## System Information

| Component | Details |
|---|---|
| Operating System | Debian GNU/Linux 13 (trixie) |
| Kernel | 6.17.13-2-pve |
| Hypervisor | Proxmox VE |
| Architecture | x86_64 |
| Uptime During Documentation | 28+ days |

---

## Motherboard

| Component | Details |
|---|---|
| Manufacturer | ASRock |
| Model | B550M Pro4 |
| BIOS Vendor | American Megatrends LLC |
| BIOS Version | P3.90 |
| BIOS Date | 09/30/2025 |

---

## CPU

| Component | Details |
|---|---|
| CPU Model | AMD Ryzen 5 5600G |
| Architecture | Zen 3 |
| Core Count | 6 Cores |
| Thread Count | 12 Threads |
| Base/Boost | Up to 4.4 GHz |
| Virtualization Support | AMD-V (SVM) |
| L3 Cache | 16 MiB |

### CPU Features

```text
avx
avx2
ht
svm
sse
sse2
sse3
sse4_1
sse4_2
```

---

## Memory

| Component | Details |
|---|---|
| Installed Memory | 64 GB DDR4 |
| Available Memory | ~62 GB |
| Current Usage During Capture | ~32 GB |

The memory capacity supports:

- Multiple virtual machines
- Kubernetes workloads
- Monitoring stack services
- Docker containers
- Long uptime infrastructure workloads

---

## Graphics

| Component | Details |
|---|---|
| Dedicated GPU | AMD Radeon RX 7600 |
| Integrated GPU | AMD Radeon Vega |
| GPU Passthrough Driver | vfio-pci |

### GPU Usage

The dedicated GPU is configured for:

- PCI passthrough experimentation
- Virtualization testing
- Future GPU acceleration workloads

---

## Networking

| Interface | Details |
|---|---|
| nic0 | Realtek RTL8126 5GbE |
| nic1 | Realtek RTL8111 Gigabit Ethernet |
| vmbr0 | Primary Proxmox bridge |
| vmbr1 | Secondary network bridge |

### Network Infrastructure

The Proxmox host supports:

- Virtual bridges
- VM networking
- Kubernetes networking
- Reverse proxy traffic
- Monitoring traffic
- Infrastructure segmentation experiments

---

## Storage Configuration

| Device | Model | Capacity |
|---|---|---|
| NVMe 0 | Samsung PM9A1 | 256 GB |
| NVMe 1 | Samsung 990 EVO Plus | 1 TB |
| SATA SSD | Crucial MX500 | 1 TB |
| HDD | Seagate ST4000NC001 | 4 TB |

### Storage Usage

The storage configuration supports:

- Proxmox VM storage
- ISO storage
- Backup storage
- Container volumes
- Monitoring data
- Kubernetes workloads

### Filesystems

| Mount Point | Filesystem | Purpose |
|---|---|---|
| / | ext4 | Proxmox root filesystem |
| /boot/efi | vfat | EFI boot partition |
| swap | swap | System swap |

---

## Virtualization Environment

The Proxmox host currently supports:

- Ubuntu Server virtual machines
- Kubernetes worker nodes
- Monitoring infrastructure
- Windows Server infrastructure
- Docker workloads
- Reverse proxy services
- Security monitoring infrastructure

### Example Hosted Services

- Prometheus
- Grafana
- Loki
- CrowdSec
- Keycloak
- Portainer
- Uptime Kuma
- Nginx Proxy Manager
- Windows Server DNS
- k3s Kubernetes cluster

---

## Cooling and System Health

| Sensor | Reading |
|---|---|
| CPU Temperature | ~38°C |

### Operational Stability

The system has demonstrated:

- Stable long-term uptime
- Consistent virtualization performance
- Multi-service hosting capability
- Stable monitoring workloads
- Kubernetes workload support

---

## Infrastructure Role

This Proxmox host acts as the core infrastructure platform for the homelab environment.

Primary responsibilities include:

- Virtualization
- Infrastructure hosting
- Container hosting
- Monitoring and observability
- Security tooling
- Identity management
- Backup and recovery operations
- Infrastructure experimentation

---

## Skills Practiced

- Proxmox administration
- Hardware planning
- Virtualization
- Infrastructure monitoring
- Linux administration
- Kubernetes hosting
- Docker infrastructure
- GPU passthrough concepts
- Storage management
- Network bridge configuration
- Infrastructure troubleshooting

---

## Lessons Learned

- Infrastructure planning benefits from flexible hardware capacity.
- Monitoring resource usage is important in virtualized environments.
- Reliable storage layouts improve infrastructure stability.
- Long uptime systems require proper observability and monitoring.
- Virtualization environments benefit from standardized infrastructure documentation.
- Infrastructure documentation simplifies troubleshooting and future upgrades.

---

## Future Hardware Improvements

Planned future upgrades include:

- Additional NAS storage
- 10Gb networking
- Dedicated backup storage
- UPS battery backup
- Rack-mounted infrastructure
- Improved cable management
- Additional Kubernetes worker nodes
- Dedicated monitoring server
- Hardware redundancy improvements