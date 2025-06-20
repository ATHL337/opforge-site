---
title: "Post 2: Routing the OPFORGE Lab" 
date: 2025-06-16T14:00:00-05:00 
tags: ["opforge", "routing", "vyos", "networking"] 
categories: ["infrastructure", "networking"] 
related_cert: ["CISSP", "OSCP"] 
tooling: ["vyos", "vmware"] 
artifact_type: ["lab_log", "network_design"]
---

> "You must understand the whole of life, not just one little part of it. That is why you must read, look at the skies, sing, and dance." — Jiddu Krishnamurti

# 🧠 Routing the OPFORGE Lab

This post outlines the implementation of static routing across segmented subnets in the OPFORGE lab using VyOS routers. With a baseline topology now established, we focus on connecting RED, INT, and DMZ zones through transit routers and validating initial east-west communication.

---

## 📌 Abstract

**Problem Statement:** Without clear routing logic, segmented subnets like RED\_NET and DMZ\_NET could not communicate securely. Static routing is necessary for simulating real-world traffic flows, Red Team movement, and Blue Team monitoring.

**Methodology:** VyOS routers were configured to interconnect the RED, DMZ, and INT zones using static routes. The transit router (`opf-rt-inet`) serves as a hop point for cross-subnet flows. Each zone maintains routing awareness without using a dynamic protocol like OSPF, making the behavior predictable and testable.

**Certifications & Academic Link:** This phase aligns with CISSP (Network Security Architecture) and OSCP (internal pivoting). It supports GCFA/GCFR use cases by enabling data path tracking.

**Expected Outcomes:** Enable reachability across segments, support future firewall and NAT rules, and establish a platform for Zeek and Winlogbeat traffic logging.

---

## 📚 Prerequisites

- VMware Workstation with at least 3 VMnets assigned
- Basic working knowledge of VyOS CLI
- OPFORGE VM deployment with:
  - `opf-rt-red`: handles RED\_NET traffic
  - `opf-rt-inet`: middlebox router
  - `opf-fw-dmz`: terminates DMZ zone

---

## ✅ Tasks This Phase

- Assign IP addresses to interfaces across three routers
- Configure static routes to interconnect RED, INT, and DMZ
- Use ICMP to verify reachability between zones
- Confirm that routers can reach pfSense for future gateway testing

---

## 🔧 Configuration & Validation

### VyOS: `opf-rt-red`

```bash
configure
set interfaces ethernet eth0 address 192.168.10.1/24
set interfaces ethernet eth1 address 192.168.20.1/24
set protocols static route 192.168.50.0/24 next-hop 192.168.20.2
commit ; save
```

### VyOS: `opf-rt-inet`

```bash
configure
set interfaces ethernet eth0 address 192.168.20.2/24
set interfaces ethernet eth1 address 192.168.30.1/24
set protocols static route 192.168.10.0/24 next-hop 192.168.20.1
set protocols static route 192.168.50.0/24 next-hop 192.168.30.2
commit ; save
```

### pfSense: `opf-fw-dmz`

- `em0` = 192.168.30.2 (connected to `opf-rt-inet`)
- `em1` = 192.168.50.1 (DMZ firewall interface)

Test from `opf-rt-red`:

```bash
ping 192.168.50.1
```

---

## 🌟 Key Takeaways

- Static routing between zones allows deliberate control over flow paths
- Intermediate routing via `opf-rt-inet` simplifies NAT and monitoring
- Routing logic sets the foundation for firewall and segmentation work

---

## 🧭 On Deck

- Confirm DNS configuration from RED to DMZ
- Expand DMZ services to include NGINX and Zeek sensor nodes
- Begin VLAN testing and pfSense NAT scenarios

A lab without routing is just a group of strangers on different subnets. We build bridges.

- H.Y.P.R.

