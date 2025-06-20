---
title: "Post 3: Foundational Segmentation Setup" 
date: 2025-06-17T02:49:00-05:00 
tags: ["opforge", "segmentation", "lab_setup", "routing", "firewall"] 
categories: ["infrastructure", "networking"] 
related_cert: ["CISSP", "OSCP"] 
tooling: ["vyos", "vmware"] 
artifact_type: ["design_note", "lab_log"]
---

> "Order and simplification are the first steps toward mastery of a subject." — Thomas Mann

# ✨ Foundational Segmentation Setup

This post captures the introduction of initial segmentation boundaries within the OPFORGE lab. Before advanced VLAN tagging and DMZ logic, basic subnet design and routing were validated to support scalable infrastructure development.

---

## 📌 Abstract

**Problem Statement:** The original flat lab design limited control over traffic flow and security boundaries, making it unsuitable for advanced threat simulation or detection testing.

**Methodology:** The network was segmented into dedicated subnets representing RED\_NET, INT\_NET, and DMZ\_NET using VyOS routers. Static routes and basic firewall policies were used to simulate initial traffic controls.

**Certifications & Academic Link:** This work aligns with CISSP (network architecture design) and OSCP (pivoting foundations). It sets up the groundwork for forensics and detection scenarios supported by GCFA and GCFR.

**Expected Outcomes:** Defined network boundaries, validated communication pathways, and laid the groundwork for VLAN and DMZ transitions in future phases.

---

## 📚 Prerequisites

- Familiarity with basic VyOS routing commands
- VMware configured with isolated VMnets for each subnet
- OPFORGE VMs placed into respective segments:
  - `opf-rt-red` (Red Team router)
  - `opf-rt-inet` (Transit router)
  - `opf-fw-dmz` (DMZ firewall, pfSense base install)

---

## ✅ Tasks This Phase

- Define IP schema for segmented subnets
- Deploy and validate initial VyOS configurations for routing
- Confirm interface-to-interface reachability via ICMP
- Ensure pfSense DMZ firewall interface responds to test probes

---

## 🔧 Configuration & Validation

### VyOS Routing Setup

```bash
configure
set interfaces ethernet eth0 address 192.168.10.1/24
set interfaces ethernet eth1 address 192.168.20.1/24
set protocols static route 192.168.50.0/24 next-hop 192.168.20.2
commit ; save
```

### pfSense Interface Setup

- `em0` (connected to 192.168.20.0/24): assigned 192.168.20.2
- `em1` (DMZ): assigned 192.168.50.1/24

### Test Command

```bash
ping 192.168.50.1
```

---

## 🌟 Key Takeaways

- Early subnet segmentation enables clean expansion into VLAN-aware setups
- VyOS proved effective for modular routing in lab networks
- Sanity checks like ICMP build confidence before adding complexity

---

## 🧭 On Deck

- Confirm bidirectional reachability through DMZ to INT\_NET
- Begin DNS infrastructure deployment using pfSense DNS Resolver
- Start mapping segmentation logic to VLAN tagging and pfSense NAT

A clean segmentation plan today avoids future rework and frustration.

- H.Y.P.R.

