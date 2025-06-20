---
title: "Post 6: Routing + DNS Success Across the OPFORGE Lab" 
date: 2025-06-19T14:15:00-05:00 
read_time: 8 
technical_difficulty: "Intermediate" 
tags: ["opforge", "dns", "routing", "networking"] 
categories: ["infrastructure", "dns", "routing"] 
related_cert: ["CISSP", "GCFA", "GCFR"] 
tooling: ["vyos", "pfSense", "windows", "ubuntu"] 
artifact_type: ["lab_log", "troubleshooting"]
---


> "It is not because things are difficult that we do not dare, it is because we do not dare that they are difficult." \
> — Seneca

# 🌐 Routing + DNS Success Across the OPFORGE Lab

In this post, I walk through the successful validation of DNS and routing configurations across segmented OPFORGE networks. After implementing static routes, DNS forwarding, and conditional resolvers, systems across RED, DMZ, INT, and CSOC segments can now resolve `opforge.local` and route correctly.

---

## 📌 Abstract

**Problem Statement:** Without effective DNS and route resolution across segmented subnets, endpoint visibility and command/control emulation are degraded. Initial attempts left gaps in cross-zone name resolution and static route propagation.

**Methodology:** Built upon previously defined subnets and pfSense + VyOS topology. Implemented DNS conditional forwarding from pfSense to Domain Controller and set external resolvers on pfSense to enable internet resolution. Verified with `nslookup`, PowerShell, and browser tests.

**Certifications & Academic Link:** Supports CISSP (network architecture), GCFA (endpoint resolution validation), GCFR (forensics via FQDN traceability).

**Expected Outcomes:** Cross-segment DNS success, complete route propagation, and operational readiness for Zeek tagging and C2 testing.

---

## 📚 Prerequisites

- Completion of OPFORGE Post 5: DNS server running on `opf-dc01`, pfSense resolver configured
- Static routes in place between `opf-fw-dmz`, `opf-rt-ext`, `opf-rt-inet`, `opf-rt-int`
- Windows Domain Controller `opf-dc01` configured at `192.168.60.5`
- Windows systems configured to use `opf-dc01` as DNS
- Linux systems resolving via pfSense with `.local` domain override

---

## ✅ Tasks This Phase

- Verified pfSense `System > General Setup` DNS entries: `1.1.1.1`, `8.8.8.8`
- Enabled DNS Resolver with domain override: `opforge.local` → `192.168.60.5`
- Confirmed that internal lookups do not leak to upstream resolvers
- Verified internal and external DNS resolution from both Windows and Linux hosts
- Captured trace routes and verified NAT return paths

---

## 🔧 Configuration Highlights

### pfSense DNS Configuration

- **DNS Resolver:** Enabled
- **Domain Override:** `opforge.local` → `192.168.60.5`
- **External Resolvers:** `1.1.1.1`, `8.8.8.8` in General Settings
- **Options:** Disabled DNS override and enabled query forwarding

### VyOS Routing

```bash
configure
set protocols static route 192.168.30.0/24 next-hop 192.168.20.2
set protocols static route 192.168.20.0/24 next-hop 192.168.30.1
delete system name-server <legacy_ip>
commit; save
```

### Windows DNS Validation

```powershell
nslookup opf-dc01.opforge.local
Resolve-DnsName opf-dc01
ping opf-dc01
```

### Linux DNS Validation

```bash
cat /etc/resolv.conf
systemd-resolve --status | grep opforge.local
ping opf-dc01.opforge.local
```

---

## 🔧 DNS Role Assignment

To enforce separation of concern and traceable DNS activity, we explicitly assigned roles for DNS resolution across the routers and firewalls:

| Router        | Interface Role      | Primary DNS  | Fallback DNS     | Notes                                     |
| ------------- | ------------------- | ------------ | ---------------- | ----------------------------------------- |
| `opf-rt-int`  | Internal network    | 192.168.60.5 | 1.1.1.1, 8.8.8.8 | AD DNS for internal name resolution       |
| `opf-rt-inet` | Internet gateway    | 1.1.1.1      | 8.8.8.8          | No internal resolution, strict egress DNS |
| `opf-rt-red`  | Red Team network    | 192.168.50.1 | 1.1.1.1          | Uses pfSense DNS for monitoring/logging   |
| `opf-rt-ext`  | External/DMZ router | 192.168.50.1 | 1.1.1.1          | Simulated public infra, isolated          |
| `opf-fw-dmz`  | DMZ Firewall        | 1.1.1.1      | 8.8.8.8          | Forwarding DNS, optionally recursive      |

---

## 🧪 Final Validations

From `OPF-DC01` (`192.168.60.5`):

- 🟢 Can ping all expected routers
- 🟢 `nslookup google.com` resolves via `opf-fw-dmz`
- 🟢 `tracert` validates return paths
- 🟢 Internal name resolution (`opf-dc01.opforge.local`) functions as intended

Captured logs in pfSense confirm that **denied packets now show proper rule association** and help trace misconfigurations faster.

---

## 📦 Snapshot Recommendation

After completing this, I took **snapshots of all active VMs** under the `OPFORGE Phase 1 - Routing + DNS Lock-in` milestone. Recommend tagging all systems now that:

- DNS is resolvable per trust boundary
- NAT is applied only where required
- Static routes cover all isolated subnets
- pfSense rule logic is layered, traceable, and minimal

---

## 🌟 Key Takeaways

- Conditional DNS forwarding via pfSense links internal domain awareness with internet access
- Static routes across VyOS routers require clean design and bidirectional consideration
- Using multiple OS types validated cross-platform reliability of infrastructure

---

## 🗺 On Deck

- Begin Zeek deployment for passive DNS and connection monitoring
- Create DNS logging use cases to support detection engineering
- Implement DHCP reservations and test reverse lookup integration

This milestone solidifies the foundational DNS and routing necessary for advanced OPFORGE testing. From here, the lab grows smarter.

- H.Y.P.R.

