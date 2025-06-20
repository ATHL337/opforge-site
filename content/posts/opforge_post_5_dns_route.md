---
title: "Post 5: DNS & Routing End-to-End"
date: 2025-06-17T02:57:00-05:00 
tags: ["opforge", "dns", "routing", "pfsense", "vyos"] 
categories: ["infrastructure", "networking"] 
related_cert: ["CISSP", "GCFA", "GCFR"] 
tooling: ["vyos", "pfsense", "elastic"] 
artifact_type: ["lab_log", "design_note"]
---

> "If you know the way broadly, you will see it in all things." — Miyamoto Musashi

# ✨ DNS & Routing End-to-End

This post captures the initial end-to-end routing and DNS resolution across segmented subnets in the OPFORGE lab. It enabled reliable communication across infrastructure zones and laid the groundwork for centralized visibility and detection.

---

## 📌 Abstract

**Problem:** The initial network configuration lacked reliable inter-segment routing and DNS resolution, limiting endpoint communication and visibility into host activity.

**Approach:** Implement static routing across VyOS nodes and configure pfSense to serve DNS using its resolver. Validate communication paths from RED to DMZ to Internal zones.

**Alignment:** Reinforces certification knowledge: CISSP (Network Architecture), GCFA (Log Source Centralization), GCFR (Infrastructure Mapping).

**Outcome:** Endpoints now resolve domain names and reach targets across segments. Routing and DNS now mirror realistic enterprise networks.

---

## 📚 Prerequisites

- `opf-fw-dmz` deployed with pfSense 2.7.2
- VyOS routers (`opf-rt-red`, `opf-rt-inet`, `opf-rt-ext`, `opf-rt-int`) in position
- VMs attached to appropriate VMnet subnets
- Base interfaces and IPs assigned (see Post 4)

---

## ✅ Tasks This Phase

- Set static routes on each VyOS router to reach adjacent zones
- Configure pfSense DNS Resolver to serve 192.168.x.x/24 ranges
- Test DNS resolution from RED, DMZ, and INT zones
- Validate TCP reachability (e.g., ping, curl, etc.) across routed hops

---

## 🔧 Configuration Summary

### VyOS (opf-rt-red)

```bash
configure
set protocols static route 192.168.30.0/24 next-hop 192.168.20.2
commit ; save
```

### VyOS (opf-rt-inet)

```bash
configure
set protocols static route 192.168.10.0/24 next-hop 192.168.20.1
set protocols static route 192.168.50.0/24 next-hop 192.168.30.2
commit ; save
```

### VyOS (opf-rt-ext)

```bash
configure
set protocols static route 192.168.60.0/24 next-hop 192.168.50.1
commit ; save
```

### VyOS (opf-rt-int)

```bash
configure
set protocols static route 192.168.30.0/24 next-hop 192.168.50.2
commit ; save
```

### pfSense (opf-fw-dmz)

- DNS Resolver: Enabled
- Network Interfaces: LAN, WAN
- Domain Overrides: none (using root hints)
- Firewall Rules: Allow port 53 UDP from internal zones

---

## 🌟 Key Takeaways

- Routing across multiple VyOS nodes provides granular control of east-west and north-south traffic
- pfSense's DNS Resolver simplifies internal name resolution and supports visibility tools like Zeek and Suricata
- Proper route planning avoids asymmetric routing and visibility blind spots

---

## 🛍 On Deck

- Migrate to VLAN tagging for trunked segments
- Introduce Zeek and ELK for traffic analysis
- Begin integrating endpoint logging with Winlogbeat

The OPFORGE lab continues to evolve into a trusted, validated cyber operations training ground where every emulation leaves a detection trail—by design.

- H.Y.P.R.

