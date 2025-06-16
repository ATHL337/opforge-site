---
title: "OPFORGE Genesis: Designing a Full-Spectrum Cyber Lab"
date: 2025-06-16
draft: false
tags: ["opforge", "cyberlab", "architecture", "post-1"]
categories: ["infrastructure", "blog-series", "redteam", "blueteam"]
related_cert: []
tooling: ["vyos", "pfsense", "vmware"]
artifact_type: ["network_diagram", "setup-notes"]
---

> *"Before we wage war in cyberspace, we must first build the battlefield."*

### 🧭 Overview

Welcome to the first post of the OPFORGE blog series. This series walks through the step-by-step development of OPFORGE: a purpose-built, full-spectrum cyber operations lab environment designed to showcase and implement real-world capabilities tied to professional certifications, advanced education, and operational experience.

In this foundational post, we focus on Phase 1: the initial lab topology and routing architecture. This layer sets the stage for future red vs blue scenarios, AI-driven detection, and system-level investigations.

---

### 🌐 Initial Network Segment: RED\_NET

The **RED\_NET** is our threat emulation and offensive operations subnet. It contains:

- `opf-red01` – Main Red Team C2 (Sliver, Covenant, custom tooling)
- `opf-lnx01` – Linux-based offensive staging (Python tooling, Impacket, BloodHound)
- Gateway: `opf-rt-red (eth0: 192.168.10.1)`

Subnet: `192.168.10.0/24`

---

### 🔁 Routing Infrastructure (Phase 1)

This phase implements multi-hop routing from RED\_NET to the internet via chained VyOS routers. It emulates a real-world multi-zone topology with enforced segmentation and control points.

#### Routing Flow:

```
[opf-red01]      [opf-lnx01]
     |                |
     |                |
     +------> [opf-rt-red (eth0:192.168.10.1)]
                        |
                        v
             [opf-rt-inet (eth0:192.168.10.2)]
                        |
                        v
             [opf-rt-inet (eth1:192.168.1.25)] — Bridged to internet
```

- `opf-rt-red` is the edge router for RED\_NET and the default gateway for red team boxes.
- `opf-rt-inet` serves as a central hub with a bridged NIC to the physical network, allowing internet access from controlled segments.

---

### ⚙️ Not Yet Configured (Next Steps)

These routers are placed but not yet configured. These represent the external, DMZ, and internal zones:

| Router        | NIC  | Destination                         | Note              |
| ------------- | ---- | ----------------------------------- | ----------------- |
| `opf-rt-inet` | eth2 | To `opf-rt-ext`                     | Static IP pending |
| `opf-rt-ext`  | TBD  | To `opf-rt-dmz` (pfSense)           | Static IP pending |
| `opf-rt-dmz`  | TBD  | To `opf-rt-int`                     | Static IP pending |
| `opf-rt-int`  | TBD  | To `INTERNAL_NET (192.168.30.0/24)` | Not set up yet    |

This modular build enables staged validation and deliberate segmentation — ideal for tracking ingress/egress across threat zones.

---

### 🔖 Artifacts Created

- Draft network map (WIP; will be converted to diagram)
- VyOS routing configs for `opf-rt-red` and `opf-rt-inet`
- Lab documentation in Obsidian + GitHub wiki

---

### 📌 Coming Next

In Post #2, we’ll complete routing between `opf-rt-red` and `opf-rt-inet`, validate internet access from the RED_NET, and capture packet traces to establish baseline network behavior. We'll also begin designing the next routing phase—linking `opf-rt-inet1` to `opf-rt-ext`—to scaffold segmentation for DMZ and internal services.

As we build, each component will map back to a capability area and ultimately showcase how certifications and operational knowledge translate into real-world implementation.

Stay sharp.

— H.Y.P.R.

