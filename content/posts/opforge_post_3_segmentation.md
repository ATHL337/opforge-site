---
title: "Defining the Battlefield: Segmentation Planning Begins"
date: 2025-06-16
draft: false
tags: ["opforge", "network", "segmentation", "design", "post-3"]
categories: ["infrastructure", "planning", "zoning"]
related_cert: ["CISSP", "PMP", "OSCP"]
tooling: ["vyos", "pfsense", "vmware"]
artifact_type: ["ip_plan", "topology_map", "config_template"]
---

> *"A secure architecture begins with deliberate separation of trust."*

### 🧭 Overview

Now that RED\_NET has outbound access through a routed chain, we're ready to define the next phase of the OPFORGE battlefield: **network segmentation**.

In this post, we document our initial IP planning and interface mapping across the four planned security zones: RED (offensive ops), EXT (external untrusted), DMZ (controlled exposure), and INT (internal services and endpoints).

This step lays the architectural groundwork for detection surface placement, access control enforcement, and future emulation scenarios.

---

### 🔲 Planned Network Zones

| Zone | Purpose                          | Example Systems                              | Subnet                         |
| ---- | -------------------------------- | -------------------------------------------- | ------------------------------ |
| RED  | Adversary emulation              | `opf-red01`, `opf-lnx01`                     | 192.168.10.0/24                |
| EXT  | External attacker ingress        | `opf-it-ext`, future IOT targets             | TBD (192.168.22.0/24 proposed) |
| DMZ  | Exposed services / chokepoint    | pfSense FW, logging proxy, exposed honeypots | TBD (192.168.21.0/24 proposed) |
| INT  | Internal LAN (targets/defenders) | `opf-mbr01`, `opf-blue01`, `opf-dc01`        | 192.168.30.0/24                |

---

### 🌐 In-Progress Router Assignments

| Router        | Interface | Role                                     | IP (Planned)              |
| ------------- | --------- | ---------------------------------------- | ------------------------- |
| `opf-rt-inet` | eth2      | Link to `opf-rt-ext`                     | 192.168.22.1 (to confirm) |
| `opf-rt-ext`  | TBD       | Border router for EXT zone               | TBD                       |
| `opf-rt-dmz`  | TBD       | PFsense choke router (zone segmentation) | TBD                       |
| `opf-rt-int`  | TBD       | LAN router for INT zone                  | TBD                       |

> All interface static IPs will be documented and confirmed in `/configs/ip-assignments.md`

---

### 📘 Architectural Decision Log (ADL)

| Decision Point                     | Justification                                             | Impact                                                        |
| ---------------------------------- | --------------------------------------------------------- | ------------------------------------------------------------- |
| Use of VyOS for zone routing       | Lightweight, scriptable, easy snapshotting in lab         | Enables fine-grained routing visibility per zone              |
| Dedicated pfSense for DMZ          | Realistic chokepoint with UI-based control                | Emulates enterprise-grade border firewall                     |
| Non-routable default between zones | Enforces deliberate allowlist rules for cross-zone access | Enhances realism and supports detection exercises             |
| Static IPs per router interface    | Avoids DHCP fragility, ensures predictable logs           | Improves consistency for log correlation and threat injection |
| Phased NIC/interface deployment    | Avoids overprovisioning, aligns with milestone builds     | Enables validation-by-segment methodology                     |

---

### 🛡️ Zone Trust Model (Diagram Description)

```
            [ Internet / WAN ]
                    |
                    v
            [ opf-rt-inet ]
               /     \
              /       \
             v         v
     [ opf-rt-ext ]   [ INT: opf-rt-red ]
            |
            v
        [ opf-rt-dmz ]
            |
            v
        [ INT: opf-rt-int ]

Zone Trust Levels:
- WAN: Untrusted
- EXT: Simulated untrusted (IOT/test attacker)
- RED: Trusted (internal threat emulation)
- DMZ: Semi-trusted / proxy access
- INT: Most protected (domain, SIEM, blue team)
```

This trust zoning guides ACLs, packet inspection points, and future behavioral detections.

---

### ⚙️ Tasks This Phase

-

---

### 🔖 Artifacts (To Be Produced)

- IP/Subnet schema diagram (Obsidian + export to PNG)
- VyOS configs with interface scaffolding
- Logical zone diagram to support ACL planning
- `/configs/decisions/ADL-001.md` for architectural log

---

### 📌 Coming Next

In Post #4, we’ll apply PMP principles to break down the OPFORGE project structure. We’ll define milestone tracking, sprint planning, and how GitLab issues + Hugo documentation will track operational and learning progress.

Until then—plan like a defender, think like an adversary.

— H.Y.P.R.

