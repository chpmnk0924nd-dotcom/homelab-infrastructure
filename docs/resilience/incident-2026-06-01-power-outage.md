## Health Check Script Results

The health-check script confirmed that the main Docker and reverse proxy services were reachable after recovery, while DC01 DNS remained unreachable from the Windows host.

### Passing Checks

- Gateway / OPNsense at `192.168.10.1`
- Ubuntu Docker host at `192.168.10.60`
- SSH to Ubuntu host
- Nginx Proxy Manager HTTP, HTTPS, and admin ports
- Local hostname resolution for internal services

### Failing Checks

- DC01 ping from Windows host
- DC01 DNS port `53`
- Direct DC01 DNS resolution for internal `.homelab.local` records
- Direct Grafana, Prometheus, and Alertmanager service ports from Windows

### Key Finding

Grafana was not actually down. Grafana and Nginx Proxy Manager were operational. The outage exposed a DNS dependency problem: the Windows host could not query DC01 at `192.168.10.11`, so internal hostnames failed until a temporary hosts-file workaround was added.

## Final Health Check Results

After moving the Windows host network configuration from the physical adapter to `vEthernet (LAB-SWITCH)`, the health-check script confirmed that the main infrastructure dependency chain was restored.

### Passing Checks

- Gateway / OPNsense: `192.168.10.1`
- DC01 / DNS: `192.168.10.11`
- DC01 DNS port `53`
- Ubuntu Docker host: `192.168.10.60`
- Nginx Proxy Manager HTTP, HTTPS, and admin ports
- Local internal hostname resolution
- Direct DNS resolution through DC01 for `.homelab.local` services

### Remaining Expected Failures

The direct service ports for Grafana, Prometheus, and Alertmanager did not respond from the Windows host:

- Grafana direct port: `192.168.10.60:3002`
- Prometheus direct port: `192.168.10.60:9091`
- Alertmanager direct port: `192.168.10.60:9093`

These services are intended to be accessed through Nginx Proxy Manager using internal hostnames, so the reverse-proxy path is the primary validated access method.

### Confirmed Permanent Fix

The Windows host was previously using the physical adapter `Ethernet 2` for `192.168.10.50`, while the Hyper-V virtual switch adapter `vEthernet (LAB-SWITCH)` had an APIPA address. This caused the host to lose direct communication with the Hyper-V DC01 VM.

The fix was to move the host LAN configuration to `vEthernet (LAB-SWITCH)`, allowing the Windows host, Hyper-V VM, DC01 DNS, and LAN services to communicate correctly.