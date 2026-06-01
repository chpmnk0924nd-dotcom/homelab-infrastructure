Write-Host "====================================="
Write-Host " HOMELAB POST-OUTAGE HEALTH CHECK"
Write-Host "====================================="
Write-Host "Date: $(Get-Date)"
Write-Host "Computer: $env:COMPUTERNAME"
Write-Host "User: $env:USERNAME"
Write-Host ""

$Results = @()

function Add-Result {
    param (
        [string]$Name,
        [string]$Target,
        [string]$Check,
        [string]$Status,
        [string]$Notes
    )

    $script:Results += [PSCustomObject]@{
        Name   = $Name
        Target = $Target
        Check  = $Check
        Status = $Status
        Notes  = $Notes
    }
}

function Test-PingCheck {
    param (
        [string]$Name,
        [string]$Target
    )

    Write-Host "Checking ping: $Name ($Target)"
    $ok = Test-Connection $Target -Count 2 -Quiet

    if ($ok) {
        Add-Result $Name $Target "Ping" "PASS" "Host responded to ping"
    }
    else {
        Add-Result $Name $Target "Ping" "FAIL" "No ping response"
    }
}

function Test-PortCheck {
    param (
        [string]$Name,
        [string]$Target,
        [int]$Port
    )

    Write-Host "Checking port: $Name ($($Target):$Port)"
    $test = Test-NetConnection $Target -Port $Port -InformationLevel Quiet -WarningAction SilentlyContinue

    if ($test) {
        Add-Result $Name "$($Target):$Port" "TCP Port" "PASS" "Port is reachable"
    }
    else {
        Add-Result $Name "$($Target):$Port" "TCP Port" "FAIL" "Port is not reachable"
    }
}

function Test-DnsCheck {
    param (
        [string]$Name
    )

    Write-Host "Checking DNS: $Name"
    try {
        $result = Resolve-DnsName $Name -ErrorAction Stop
        $ip = ($result | Where-Object {$_.Type -eq "A"} | Select-Object -First 1).IPAddress

        if ($ip) {
            Add-Result $Name $ip "DNS" "PASS" "Resolved successfully"
        }
        else {
            Add-Result $Name "N/A" "DNS" "FAIL" "No A record found"
        }
    }
    catch {
        Add-Result $Name "N/A" "DNS" "FAIL" $_.Exception.Message
    }
}

Write-Host ""
Write-Host "=== Core Ping Checks ==="
Test-PingCheck "Gateway / OPNsense" "192.168.10.1"
Test-PingCheck "DC01 / DNS" "192.168.10.11"
Test-PingCheck "Ubuntu Docker Host" "192.168.10.60"

Write-Host ""
Write-Host "=== DNS Port Checks ==="
Test-PortCheck "DC01 DNS" "192.168.10.11" 53

Write-Host ""
Write-Host "=== Ubuntu Docker Host Port Checks ==="
Test-PortCheck "SSH Ubuntu Host" "192.168.10.60" 22
Test-PortCheck "Nginx Proxy Manager HTTP" "192.168.10.60" 80
Test-PortCheck "Nginx Proxy Manager Admin" "192.168.10.60" 81
Test-PortCheck "Nginx Proxy Manager HTTPS" "192.168.10.60" 443
Test-PortCheck "Grafana Direct Port" "192.168.10.60" 3002
Test-PortCheck "Prometheus Direct Port" "192.168.10.60" 9091
Test-PortCheck "Alertmanager Direct Port" "192.168.10.60" 9093

Write-Host ""
Write-Host "=== Internal DNS Checks ==="
Test-DnsCheck "grafana.homelab.local"
Test-DnsCheck "prometheus.homelab.local"
Test-DnsCheck "alertmanager.homelab.local"
Test-DnsCheck "keycloak.homelab.local"
Test-DnsCheck "portainer.homelab.local"
Test-DnsCheck "uptime.homelab.local"

Write-Host ""
Write-Host "=== DC01 DNS Server Checks ==="

$InternalNames = @(
    "grafana.homelab.local",
    "prometheus.homelab.local",
    "alertmanager.homelab.local",
    "keycloak.homelab.local",
    "portainer.homelab.local",
    "uptime.homelab.local"
)

foreach ($name in $InternalNames) {
    Write-Host "Checking DC01 DNS directly: $name"
    try {
        $result = Resolve-DnsName $name -Server 192.168.10.11 -ErrorAction Stop
        $ip = ($result | Where-Object {$_.Type -eq "A"} | Select-Object -First 1).IPAddress

        if ($ip) {
            Add-Result "$name via DC01" $ip "DNS Server" "PASS" "Resolved through DC01"
        }
        else {
            Add-Result "$name via DC01" "N/A" "DNS Server" "FAIL" "No A record returned from DC01"
        }
    }
    catch {
        Add-Result "$name via DC01" "192.168.10.11" "DNS Server" "FAIL" $_.Exception.Message
    }
}

Write-Host ""
Write-Host "====================================="
Write-Host " HEALTH CHECK RESULTS"
Write-Host "====================================="

$Results | Format-Table -AutoSize

$ReportPath = "$PSScriptRoot\homelab-post-outage-report.txt"

$Results | Format-Table -AutoSize | Out-String | Set-Content $ReportPath

Write-Host ""
Write-Host "Report saved to:"
Write-Host $ReportPath