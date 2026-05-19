#!/bin/bash

# Proxmox Backup Check

echo "================================="
echo " Proxmox Backup Validation Check "
echo "================================="

echo ""
echo "[*] Checking Proxmox storage..."
pvesm status

echo ""
echo "[*] Checking vzdump backup files..."
find /var/lib/vz/dump -type f

echo ""
echo "[*] Checking disk usage..."
df -h

echo ""
echo "[*] Checking recent backup tasks..."
grep vzdump /var/log/syslog | tail -20

echo ""
echo "[*] Backup validation complete."

# Then make it exacutable:

chmod +x proxmox-backup-check.sh