
---
title: "OPFORGE Network Internet Access Setup Guide"
date: 2025-06-12
draft: false
---
# OPFORGE Network Internet Access Setup Guide

This guide outlines the configuration steps used to enable full internet access from the Red Network within the OPFORGE lab environment. It includes configuration of VyOS routers `opf-rtred` and `opf-rt-inet`, as well as ensuring connectivity from a host such as `opf-lnx01`.

---

## 🔧 1. `opf-rt-inet` Configuration (Internet Gateway)

### Interfaces
- `eth0`: 192.168.10.2/24 (RED_NET)
- `eth1`: 192.168.1.25/24 (WAN - External/Internet-facing)

### Commands
```bash
configure

# Set interface IPs (if not set)
set interfaces ethernet eth0 address 192.168.10.2/24
set interfaces ethernet eth1 address 192.168.1.25/24

# Default route to WAN gateway
set protocols static route 0.0.0.0/0 next-hop 192.168.1.1

# Enable NAT for RED_NET to WAN
set nat source rule 100 outbound-interface eth1
set nat source rule 100 source address 192.168.10.0/24
set nat source rule 100 translation address masquerade

# Enable DNS forwarding
set service dns forwarding listen-address 192.168.10.2
set service dns forwarding allow-from 192.168.10.0/24
set service dns forwarding name-server 1.1.1.1
set service dns forwarding name-server 8.8.8.8

commit
save
exit
```

---

## 🔧 2. `opf-rtred` Configuration (Red Network Router)

### Interfaces
- `eth0`: 192.168.10.1/24 (RED_NET)

### Commands
```bash
configure

# Set static default route to forward traffic to opf-rt-inet
set protocols static route 0.0.0.0/0 next-hop 192.168.10.2

# Set DNS resolver to point to opf-rt-inet
set system name-server 192.168.10.2

commit
save
exit
```

---

## 🧪 3. `opf-lnx01` or Red Network Host

Ensure the following are configured on your RED_NET endpoints:

### Example `/etc/resolv.conf`
```bash
nameserver 192.168.10.2
```

### Test Connectivity
```bash
ping 8.8.8.8
ping google.com
```

---

## ✅ Verification Checklist

| Device        | Internet (8.8.8.8) | DNS Resolution (`google.com`) |
|---------------|-------------------|-------------------------------|
| `opf-rt-inet` | ✅                | ✅                            |
| `opf-rtred`   | ✅                | ✅                            |
| `opf-lnx01`   | ✅                | ✅                            |

---

**Author**: Alfredo Pelaez  
**Date**: 2025-06-12  
**Lab**: OPFORGE – Threat Emulation & Detection Validation
