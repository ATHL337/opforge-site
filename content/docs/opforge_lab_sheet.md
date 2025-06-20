---
title: "OPFORGE Lab Companion Sheet" 
date: 2025-06-19T19:45:00-05:00 
read_time: 7 
technical_difficulty: "Intermediate" 
tags: ["opforge", "lab", "infrastructure", "reference"] 
categories: ["lab_docs"] 
related_cert: ["CISSP", "GCFA", "GCFR", "OSCP", "GXPN"] 
tooling: ["vyos", "pfSense", "vmware", "windows", "ubuntu"] 
artifact_type: ["reference", "companion_sheet"]
---
> "Luck is what happens when preparation meets opportunity." — Seneca

# 🧭 OPFORGE Lab Companion Sheet

This companion sheet is a quick-reference guide for building and navigating the OPFORGE segmented lab environment. It aligns with blog posts 1 through 7 and supports realistic threat emulation, detection validation, and cyber-AI experimentation.

---

## 🧱 Lab Zones & Addressing

| Zone               | CIDR            | Description                                 | Gateway      |
| ------------------ | --------------- | ------------------------------------------- | ------------ |
| RED\_NET           | 192.168.50.0/24 | Offensive tools, implants, C2s              | 192.168.50.1 |
| INTERNAL\_NET      | 192.168.60.0/24 | Clients, Domain Controller, Blue Team infra | 192.168.60.1 |
| DMZ\_NET           | 192.168.20.0/24 | Public-facing services                      | 192.168.20.1 |
| LAN\_WORKSTATIONS  | 192.168.30.0/24 | User workstations                           | 192.168.30.1 |
| EXT\_NET (Transit) | 192.168.41.0/24 | Between DMZ and InternetSim                 | 192.168.41.1 |
| InternetSim        | 192.168.40.0/24 | Simulated public Internet                   | 192.168.40.1 |

## 📦 Core Systems

| Hostname    | Role                               | IP Address   | Notes                                    |
| ----------- | ---------------------------------- | ------------ | ---------------------------------------- |
| OPF-DC01    | Windows AD/DNS Controller          | 192.168.60.5 | Authoritative for opforge.local          |
| OPF-FW-DMZ  | pfSense Firewall                   | 192.168.20.5 | Routes/filters between DMZ + EXT\_NET    |
| OPF-RT-RED  | VyOS Router for RED\_NET           | 192.168.50.1 | Static route → EXT\_NET via 192.168.50.2 |
| OPF-RT-EXT  | VyOS Router between DMZ & RED      | 192.168.20.2 | Dual NIC on DMZ + EXT                    |
| OPF-RT-INET | VyOS Router for simulated Internet | 192.168.40.1 | Outbound only                            |
| OPF-RT-INT  | VyOS Router for Internal Network   | 192.168.60.1 | Connected to Domain + workstations       |
| OPF-RT-DMZ  | Trunk router with VLAN 41          | 192.168.41.2 | Connected to pfSense DMZ transit         |

## 📡 DNS Role Assignment

| Device        | Interface Role      | Primary DNS  | Fallback DNS     | Notes                            |
| ------------- | ------------------- | ------------ | ---------------- | -------------------------------- |
| `opf-rt-int`  | Internal network    | 192.168.60.5 | 1.1.1.1, 8.8.8.8 | Uses AD DNS                      |
| `opf-rt-inet` | Internet gateway    | 1.1.1.1      | 8.8.8.8          | Strict external only             |
| `opf-rt-red`  | Red team network    | 192.168.50.1 | 1.1.1.1          | pfSense for monitoring           |
| `opf-rt-ext`  | External/DMZ router | 192.168.50.1 | 1.1.1.1          | No internal lookup               |
| `opf-fw-dmz`  | DMZ Firewall        | 1.1.1.1      | 8.8.8.8          | Forwards to internal or external |

## 🔐 Firewall Rule Logic (pfSense)

- **Allow** DNS (TCP/UDP 53) from INTERNAL\_NET to `opf-dc01`
- **Allow** ICMP selectively (ping, traceroute validation)
- **Allow** NTP (UDP 123)
- **Allow** HTTP/HTTPS only to specific zones
- **Deny** all else explicitly with logging

## 📑 DNS Resolver Config (pfSense)

- Enabled DNS Resolver
- Domain override: `opforge.local` → `192.168.60.5`
- General DNS: `1.1.1.1`, `8.8.8.8`
- Outgoing Interface: `DMZ_TRANSIT_VLAN41`

## 🔄 VyOS Routing Sample (per router)

```vyos
configure
set protocols static route 192.168.30.0/24 next-hop 192.168.20.2
set protocols static route 192.168.60.0/24 next-hop 192.168.30.1
commit; save
```

## 🧪 Validation Commands

### Windows

```powershell
ping opf-dc01
nslookup google.com
tracert opf-dc01.opforge.local
```

### Linux

```bash
cat /etc/resolv.conf
ping opf-dc01.opforge.local
systemd-resolve --status
```

## 🗺 Timeline Snapshot (Posts 1–7)

| Post # | Milestone                                       |
| ------ | ----------------------------------------------- |
| 1      | Lab Design + Purpose Defined                    |
| 2      | Static Routing and Interfaces Set               |
| 3      | Subnet Segmentation (Red, Blue, DMZ)            |
| 4      | (Deprecated – merged into 5 & 7)                |
| 5      | DNS Resolver, Domain Controller Setup           |
| 6      | Cross-zone DNS + Routing Fully Validated        |
| 7      | VLAN 41 Added, pfSense Transit Config Completed |

## 🧠 Tips & Notes

- Always snapshot before making routing/firewall changes
- Use `tcpdump` or `Packet Capture` in pfSense for flow debugging
- Keep `/etc/hosts` clean and prefer DNS testing via resolvers
- Maintain NAT boundaries only where necessary (egress control)

## 🧩 Next Companion Add-ons

- Network diagram (SVG/PNG)
- Credential vault structure (how secrets are handled)
- Integration plans for Zeek and detection engines

---

Stay methodical. Document everything. Grow forward.

— H.Y.P.R.

