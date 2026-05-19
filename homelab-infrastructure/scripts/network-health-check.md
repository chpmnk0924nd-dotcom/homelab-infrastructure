#!/bin/bash

# Homelab Network Health Check
This script checks connectivity to critical homelab infrastructure systems.
Used for validating infrastructure availability and troubleshooting network issues.

# Infrastructure Automation Scripts

## Overview

This directory contains automation and operational scripts used inside the homelab environment.

The scripts are used for:

- Infrastructure validation
- Connectivity testing
- Monitoring support
- Troubleshooting
- Operational checks
- Automation experiments

---

## Scripts

### network-health-check.sh

Checks connectivity to important infrastructure systems.

Example systems checked:

- Proxmox
- Windows Server DNS
- OPNsense
- Grafana
- Nginx Proxy Manager
- Kubernetes nodes

Example usage:

```bash
./network-health-check.sh
```

Example functions:

- Ping validation
- Service availability checks
- Network troubleshooting
- Infrastructure status validation

```bash
Write-Host "=================================="
Write-Host " HOMELAB HEALTH CHECK (WINDOWS)"
Write-Host "=================================="
Write-Host "Date: $(Get-Date)"
Write-Host "User: $env:USERNAME"
Write-Host ""

$ReportPath = "C:\Scripts\homelab-health-report-windows.txt"
Start-Transcript -Path $ReportPath -Force

function Check-Dns {
    param([string]$Name)
    try {
        Resolve-DnsName $Name -ErrorAction Stop | Out-Null
        Write-Host "[OK]   DNS:  $Name"
    }
    catch {
        Write-Host "[FAIL] DNS:  $Name - $($_.Exception.Message)"
    }
}

function Check-Ping {
    param([string]$Name,[string]$HostName)
    if (Test-Connection -ComputerName $HostName -Count 1 -Quiet) {
        Write-Host "[OK]   Ping: $Name ($HostName)"
    }
    else {
        Write-Host "[FAIL] Ping: $Name ($HostName)"
    }
}

function Check-Tcp {
    param([string]$Name,[string]$HostName,[int]$Port)
    $result = Test-NetConnection -ComputerName $HostName -Port $Port -WarningAction SilentlyContinue
    if ($result.TcpTestSucceeded) {
        Write-Host "[OK]   TCP:  $Name ($HostName`:$Port)"
    }
    else {
        Write-Host "[FAIL] TCP:  $Name ($HostName`:$Port)"
    }
}

Write-Host "== DNS CHECKS =="
Check-Dns "dc01.homelab.local"
Check-Dns "ubuntu01.homelab.local"
Check-Dns "rocky01.homelab.local"
Check-Dns "uptime.homelab.local"
Write-Host ""

Write-Host "== PING CHECKS =="
Check-Ping "Domain Controller" "dc01.homelab.local"
Check-Ping "Ubuntu Server" "ubuntu01.homelab.local"
Check-Ping "Ubuntu Desktop" "192.168.1.61"
Check-Ping "Rocky Linux" "rocky01.homelab.local"
Write-Host ""

Write-Host "== TCP CHECKS =="
Check-Tcp "Rocky SSH" "rocky01.homelab.local" 22
Check-Tcp "DC01 DNS" "dc01.homelab.local" 53
Check-Tcp "DC01 Kerberos" "dc01.homelab.local" 88
Write-Host ""

Write-Host "=================================="
Write-Host " DONE"
Write-Host "=================================="

Stop-Transcript
exit 0
```