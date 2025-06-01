---
title: "Correcting OPF-DC01 Placement in ADINFRA Segment"
date: 2025-05-27
draft: false
tags: ["opf-dc01", "adinfra", "networking", "activedirectory"]
---

## Background

Originally, `OPF-DC01` was deployed with an IP address in the `CSOCINFRA (192.168.20.0/24)` subnet. However, per OPFORGE's logical segmentation, all domain services must reside in the `ADINFRA (192.168.40.0/24)` segment to maintain operational and architectural integrity.

---

## Problem

- `OPF-DC01` had IP `192.168.20.100` (incorrect subnet).
- The gateway was misconfigured as `192.168.50.5` (C2 CONTROL).
- This broke domain service accessibility and violated the subnet's trust boundary.

---

## Solution

### 1. Re-IP OPF-DC01 to ADINFRA

```powershell
New-NetIPAddress -InterfaceAlias "Ethernet0" `
  -IPAddress "192.168.40.100" `
  -PrefixLength 24 `
  -DefaultGateway "192.168.40.5"
```

### 2. Update DNS

```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet0" -ServerAddresses "192.168.40.100"
```

### 3. Fix Default Route

```powershell
Remove-NetRoute -InterfaceAlias "Ethernet0" -NextHop 192.168.50.5

New-NetRoute -InterfaceAlias "Ethernet0" `
  -DestinationPrefix "0.0.0.0/0" `
  -NextHop "192.168.40.5"
```

---

## Results

- `OPF-DC01` now properly resides at `192.168.40.100`.
- Routing flows through `opf-fw01` via gateway `192.168.40.5`.
- It is ready to serve domain joins from endpoints like `OPF-MBR01`.

