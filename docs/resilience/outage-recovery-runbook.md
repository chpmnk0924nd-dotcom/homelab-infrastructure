# Homelab Outage Recovery Runbook

## Purpose

This runbook documents the step-by-step recovery process for the homelab after a power outage, reboot, or unexpected shutdown.

The goal is to verify the core dependency chain:

Windows Host → Hyper-V DC01 DNS → Internal DNS Records → Nginx Proxy Manager → Docker Services → Grafana/Prometheus/Uptime Kuma

---

## Core Infrastructure

| Service | Hostname | IP Address | Purpose |
|---|---:|---:|---|
| OPNsense Gateway | opnsense.homelab.local | 192.168.10.1 | Router / gateway |
| Windows Host | WIN11-01 | 192.168.10.50 | Hyper-V host |
| DC01 | dc01.homelab.local | 192.168.10.11 | AD DS / DNS |
| Ubuntu Docker Host | ubuntu01.homelab.local | 192.168.10.60 | Docker / NPM / Grafana |
| Grafana | grafana.homelab.local | 192.168.10.60 | Dashboards |
| Prometheus | prometheus.homelab.local | 192.168.10.60 | Metrics |
| Nginx Proxy Manager | npm | 192.168.10.60:81 | Reverse proxy |

---

## Recovery Order

1. Verify the Windows host is online.
2. Verify the gateway is reachable.
3. Verify Hyper-V VMs are running.
4. Verify DC01 has network access.
5. Verify DNS service is running on DC01.
6. Verify internal DNS names resolve.
7. Verify Ubuntu Docker host is reachable.
8. Verify Docker containers are running.
9. Verify Nginx Proxy Manager is online.
10. Verify Grafana is reachable.
11. Document the issue and the fix.

---

## Windows Host Checks

Run from Windows PowerShell:

```powershell
ping 192.168.10.1
ping 192.168.10.11
ping 192.168.10.60
```

Expected results:

192.168.10.1 should reply.
192.168.10.11 should reply if DC01 is online and reachable.
192.168.10.60 should reply if the Ubuntu Docker host is online

---

# Hyper-V Checks

Run from Windows PowerShell as Administrator:

```powershell
Get-VM
Get-VMSwitch
Get-VMNetworkAdapter -VMName "DC01" | Select VMName,SwitchName,Status,MacAddress,IPAddresses
```

Expected:

DC01 should be running.
DC01 should be attached to the correct external switch.
DC01 should have IP 192.168.10.11.

---

# DC01 Checks

Run inside DC01 powershell:

```powershell
ipconfig /all
ping 192.168.10.1
ping 192.168.10.60
Get-Service DNS
Restart-Service DNS
nslookup grafana.homelab.local 127.0.0.1
```

Expected:

DC01 should have IP 192.168.10.11.
Gateway should be 192.168.10.1.
DNS should point to itself using 127.0.0.1 or ::1.
DNS should resolve grafana.homelab.local to 192.168.10.60.

---

# DNS Checks from Windows Host

Run from Windows PowerShell:

```powershell
Test-NetConnection 192.168.10.11 -Port 53
nslookup grafana.homelab.local
ping grafana.homelab.local
```

Expected:

Port 53 should succeed.
Grafana should resolve to 192.168.10.60

---

# Ubuntu Docker Host Checks

SSH into Ubuntu host:

```powershell
ssh nick@192.168.10.60
```

```powershell
hostname -I
docker ps -a
curl -I http://localhost:81
curl -I http://localhost:3002
sudo ss -tulpn | grep -E ':80|:81|:443|:3002'
```

Expected:

Nginx Proxy Manager should respond on port 81.
Grafana should respond locally on port 3002.
Docker containers should show as running.

---

# Nginx Proxy Manager Checks

Open:
http://192.168.10.60:81 in browser.

Check proxy hosts:

| Hostname | Forward Destination |
|---|---|
| grafana.homelab.locaL | http://192.168.10.60:3002 |
| prometheus.homelab.local | http://192.168.10.60:9091 |
| alertmanager.homelab.local | http://192.168.10.60:9093 |
| keycloak.homelab.local | http://192.168.10.60:8081 |

---

# Grafana Checks

1. Try in browser:

https://grafana.homelab.local

2. If DNS is broken, temporarily add this to the Windows hosts file:

192.168.10.60 grafana.homelab.local

Hosts file path:

C:\Windows\System32\drivers\etc\hosts

3. Then flush DNS:

```powershell
ipconfig /flushdns
```

4. Document Incident Notes

Date:

Issue:

Symptoms:

Root Cause:

Fix:

Prevention:

Save the file.

5. Add a short project summary to your README

Open your main README:

```powershell
notepad README.md
```

## Homelab Outage Recovery and Service Resilience

Built a post-outage recovery workflow for validating core homelab services after power loss or unexpected shutdown. The recovery process checks Windows host connectivity, Hyper-V VM status, Windows Server DNS, Docker services, Nginx Proxy Manager, and Grafana availability.

Key areas covered:

- Windows Server DNS recovery
- Hyper-V virtual switch troubleshooting
- Docker service validation
- Nginx Proxy Manager reverse proxy checks
- Grafana service verification
- Temporary hosts-file DNS workaround
- Step-by-step outage recovery documentation

---

# Health Check Results

Name                       Target             Check    Status Notes                 
----                       ------             -----    ------ -----                 
Gateway / OPNsense         192.168.10.1       Ping     PASS   Host responded to ping
DC01 / DNS                 192.168.10.11      Ping     FAIL   No ping response      
Ubuntu Docker Host         192.168.10.60      Ping     PASS   Host responded to ping
DC01 DNS                   192.168.10.11:53   TCP Port FAIL   Port is not reachable 
SSH Ubuntu Host            192.168.10.60:22   TCP Port PASS   Port is reachable     
Nginx Proxy Manager HTTP   192.168.10.60:80   TCP Port PASS   Port is reachable     
Nginx Proxy Manager Admin  192.168.10.60:81   TCP Port PASS   Port is reachable     
Nginx Proxy Manager HTTPS  192.168.10.60:443  TCP Port PASS   Port is reachable     
Grafana Direct Port        192.168.10.60:3002 TCP Port FAIL   Port is not reachable 
Prometheus Direct Port     192.168.10.60:9091 TCP Port FAIL   Port is not reachable 
Alertmanager Direct Port   192.168.10.60:9093 TCP Port FAIL   Port is not reachable 
grafana.homelab.local      192.168.10.60      DNS      PASS   Resolved successfully 
prometheus.homelab.local   192.168.10.60      DNS      PASS   Resolved successfully 
alertmanager.homelab.local 192.168.10.60      DNS      PASS   Resolved successfully 
keycloak.homelab.local     192.168.10.60      DNS      PASS   Resolved successfully 
portainer.homelab.local    192.168.10.60      DNS      PASS   Resolved successfully 
uptime.homelab.local       192.168.10.60      DNS      PASS   Resolved successfully 

---

## Health Check Results

The post-outage health-check script successfully validated that the gateway, Ubuntu Docker host, Nginx Proxy Manager, and internal service hostnames were reachable.

Remaining issues detected:

- DC01 did not respond to ping from the Windows host.
- DNS port 53 on DC01 was not reachable from the Windows host.
- Direct access to Grafana, Prometheus, and Alertmanager ports failed from the Windows host.
- Internal hostname resolution was temporarily restored using the Windows hosts file.

This confirmed that Grafana itself was operational, while the remaining weakness was DNS/DC01 reachability from the Hyper-V host.