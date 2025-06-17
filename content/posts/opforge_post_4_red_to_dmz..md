---
title: "OPFORGE Post 4: Routing from RED\_NET to DMZ Confirmed" 
date: 2025-06-17 
tags: ["opforge", "routing", "firewall", "validation", "post-4"] 
categories: ["infrastructure", "redteam", "segmentation"] 
related_cert: ["OSCP", "GREM", "GPEN"] 
tooling: ["vyos", "pfsense", "vmware"] 
artifact_type: ["routing_config", "pfSense_rules", "verification_notes"]
---

### ✅ Objective

Ensure full routed communication path from `opf-rt-red (192.168.10.1)` to `opf-fw-dmz (pfSense, 192.168.21.2)` through\:

```
opf-rt-red → opf-rt-inet → opf-rt-ext → opf-fw-dmz
```

---

### 🧭 Summary of Actions Since Post #3

#### 🔧 Interface Corrections

- Verified that `opf-rt-ext eth1` had correct IP `192.168.21.1/24`
- Corrected VMnet assignment for `opf-rt-ext` and `opf-fw-dmz` to share same virtual switch (e.g., VMnet3)
- Validated Layer 2 reachability using `arp -an` and ping

#### 📦 Routing Configuration

- On `opf-rt-red`: Static route to `192.168.22.0/24` via `192.168.10.2`
- On `opf-rt-inet`: Routes to `192.168.21.0/24` and `192.168.22.0/24` via `192.168.22.2`
- On `opf-rt-ext`: Forwarded DMZ-bound traffic to `192.168.21.2`
- On `opf-fw-dmz`: Static route to `192.168.10.0/24` via `192.168.21.1`
  - Added to `/etc/rc.conf.local` for persistence

#### 🔐 Firewall Configuration

- pfSense WAN interface rule added:
  - **Allow ICMP from any to any** on WAN
  - Confirmed ICMP echo replies work from `opf-rt-red`

---

### 🧪 Test Results

- `ping 192.168.21.2` from `opf-rt-red`: ✅ Success
- Traceroute confirmed routed path through `opf-rt-inet` and `opf-rt-ext`
- ARP and ICMP traffic verified using `tcpdump` and manual ARP queries

---

### 📘 Lessons Captured

| Lesson                       | Description                                                                                               |
| ---------------------------- | --------------------------------------------------------------------------------------------------------- |
| 🔌 VMnet Isolation           | Misaligned virtual NICs caused unreachable ARP/NIC comms — VM topology must be tightly controlled         |
| 🔁 Static Routing Discipline | Each router must explicitly know how to reach at least one hop forward and one hop back                   |
| 🧱 pfSense Default Behavior  | ICMP and interzone traffic blocked unless explicitly allowed — must add rules even for internal sim zones |
| 🔄 Route Persistence         | For pfSense, `/etc/rc.conf.local` controls static route persistence (not `/etc/rc.conf` directly)         |

---

### 📦 Artifacts Captured

- `opf-fw-dmz` route config: `/etc/rc.conf.local`
- `opf-rt-*` route configs: CLI command history + saved config tree
- Screenshot archive: ICMP and routing confirmation

---

### 📌 Coming Next

In Post #5, we’ll break down the OPFORGE project using PMP principles:

- Define milestones and work packages
- Map each certification to artifacts and sprint goals
- Begin sprint tracking in GitLab to capture ongoing execution

This checkpoint locks in the RED → DMZ routing success as the operational foundation for both threat emulation and blue team telemetry validation.

Stay routed — stay dangerous.

— H.Y.P.R.

