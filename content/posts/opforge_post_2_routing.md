---
title: "First Route, First Blood: Standing Up RED\_NET"
date: 2025-06-16
draft: false
tags: ["opforge", "vyos", "redteam", "routing", "post-2"]
categories: ["infrastructure", "redteam", "routing"]
related_cert: ["OSCP", "GPEN", "PMP"]
tooling: ["vyos", "vmware", "tcpdump"]
artifact_type: ["routing_config", "traffic_capture", "validation_notes"]
---

> *"Before you can emulate an adversary, you must be able to reach the battlefield."*

### 🧭 Overview

In Post #1, we covered the initial design philosophy behind OPFORGE and the high-level segmentation plan. Now it’s time to get traffic moving. In this post, we focus on building and validating the first complete routing path from RED\_NET to the public internet.

This milestone enables offensive tooling on `opf-red01` and `opf-lnx01` to begin live-fire interaction with the outside world in a controlled and observable way. The setup also establishes our first artifact set: routed VyOS configs, packet captures, and validation logs.

---

### 🌐 Confirmed Network Map (Phase 1)

- `opf-red01`: 192.168.10.12
- `opf-lnx01`: 192.168.10.10
- `opf-rt-red` (eth0): 192.168.10.1 (gateway for RED\_NET)
- `opf-rt-red` (eth1): 192.168.10.2 (connects to opf-rt-inet)
- `opf-rt-inet` (eth0): 192.168.10.3 (receives from opf-rt-red)
- `opf-rt-inet` (eth1): 192.168.1.25 (bridged NIC w/ internet access)

> Static routes and NAT were configured in VyOS to allow NAT masquerading and routing between RED\_NET and the internet.

---

### 🔧 VyOS Routing Summary

**On **`opf-rt-red`**:**

```vyos
set interfaces ethernet eth0 address '192.168.10.1/24'
set interfaces ethernet eth1 address '192.168.10.2/30'
set protocols static route 0.0.0.0/0 next-hop 192.168.10.3
```

**On **`opf-rt-inet`**:**

```vyos
set interfaces ethernet eth0 address '192.168.10.3/30'
set interfaces ethernet eth1 address '192.168.1.25/24'
set nat source rule 100 outbound-interface 'eth1'
set nat source rule 100 source address '192.168.10.0/24'
set nat source rule 100 translation address 'masquerade'
set protocols static route 192.168.10.0/24 next-hop 192.168.10.2
```

---

### ✅ Routing Validation

1. Confirmed default gateway on both `opf-red01` and `opf-lnx01` is `192.168.10.1`
2. ICMP verified up the chain to `opf-rt-inet`
3. Outbound DNS resolution validated from `opf-red01`
4. Reached external IP (e.g. `curl ifconfig.me`) from RED\_NET
5. Captured outbound traffic on `opf-rt-inet` (eth1) with `tcpdump`

---

### 🧪 Artifacts Captured

- VyOS configs for `opf-rt-red` and `opf-rt-inet`
- TCP dump from outbound session (available in `/artifacts/rednet-routing/`)
- Markdown logs in Obsidian for each validation step

---

### 📌 Coming Next

In Post #3, we begin laying the groundwork for network segmentation beyond RED\_NET. We'll finalize interface assignments and static IP plans for `opf-rt-ext`, `opf-rt-dmz`, and `opf-rt-int`. This paves the way for introducing detection points, intrusion zones, and the DMZ firewall.

Stay online, stay offensive.

— H.Y.P.R.

