---
title: "Post 7: VLAN Foundations and DMZ Segmentation" 
date: 2025-06-19T20:45:00-05:00 
tags: ["opforge", "segmentation", "vlan", "dmz", "firewall", "routing"] 
categories: ["infrastructure", "networking", "future_lab"] 
related_cert: ["GCIA", "GCIH", "GCTI"] 
tooling: ["vyos", "pfsense", "vmware"] 
artifact_type: ["lab_log", "design_note"]
---

> “The impediment to action advances action. What stands in the way becomes the way.”\
> — Marcus Aurelius

# 🧱 VLAN Testing and Future Segmentation

This phase introduced tagged VLAN interfaces between `opf-fw-dmz` and `opf-rt-ext`, laying critical groundwork for 802.1Q-based segmentation. The configuration was validated using VMware virtual switches, enabling intra-zone traffic control before we scale into endpoint VLAN tagging.

This marks a major milestone in OPFORGE’s design maturity by implementing early segmentation practices, shaping how simulated traffic crosses red-to-blue domains.

---

## 📌 Abstract

**Problem Statement:** The OPFORGE lab must evolve to represent segmented enterprise networks to reflect realistic detection conditions for adversary emulation.

**Methodology:** Introduce VLAN tagging using 802.1Q between critical routers and pfSense firewall, simulate the DMZ, and update NAT/firewall policies to reflect this segmentation.

**Certifications & Academic Link:** This post aligns with GCIA, GCIH, and GCTI by emphasizing perimeter segmentation, NAT traversal, and protocol visibility for detection engineering. It also reinforces OSI layering and architectural thinking central to graduate coursework.

**Expected Outcomes:** A segmented path between RED\_NET and INT via DMZ with VLAN logic fully implemented and supporting continued emulation and detection fidelity.

---

## ✅ Tasks This Phase

- Created VLAN 41 on `opf-fw-dmz` and `opf-rt-ext` with tag `41`
- Assigned `192.168.41.1/24` and `192.168.41.2/24` to `eth1.41` and `em0.41`, respectively
- Migrated all rules and NAT configuration from WAN to the new VLAN interface in pfSense
- Updated DNS resolver and gateway settings
- Validated static routes in `opf-rt-ext` and `opf-rt-inet`
- Preserved connectivity while introducing 802.1Q tagging and scoped routing

---

## 📚 Prerequisites

- Familiarity with pfSense and VyOS routing
- Understanding of NAT and firewall rules
- Basics of 802.1Q VLAN tagging
- Prior completion of OPFORGE Post 5 (Routing and DNS)

---

## 🔧 Updated Configuration and Migration Steps

### IP Assignments

| Device        | Interface | IP Address      | Connected To          |
| ------------- | --------- | --------------- | --------------------- |
| `opf-rt-red`  | `eth0`    | 192.168.10.1/24 | RED\_NET              |
| `opf-rt-red`  | `eth1`    | 192.168.20.1/24 | `opf-rt-inet`         |
| `opf-rt-inet` | `eth0`    | 192.168.20.2/24 | `opf-rt-red`          |
| `opf-rt-inet` | `eth1`    | 192.168.30.1/24 | `opf-rt-ext`          |
| `opf-rt-ext`  | `eth0`    | 192.168.30.2/24 | `opf-rt-inet`         |
| `opf-rt-ext`  | `eth1.41` | 192.168.41.1/24 | `opf-fw-dmz` (em0.41) |
| `opf-fw-dmz`  | `em0.41`  | 192.168.41.2/24 | `opf-rt-ext`          |
| `opf-fw-dmz`  | `em1`     | 192.168.50.1/24 | `opf-rt-int`          |
| `opf-rt-int`  | `eth0`    | 192.168.50.2/24 | `opf-fw-dmz`          |
| `opf-rt-int`  | `eth1`    | 192.168.60.1/24 | INTERNAL\_NET         |

### pfSense VLAN Adjustments

- Created VLAN `DMZ_TRANSIT_VLAN41` on parent `em0`, tag `41`
- Assigned interface and enabled it with static IP `192.168.41.2/24`
- Set **EXT\_VLAN41** as the IPv4 upstream gateway under **Interfaces > DMZ\_TRANSIT\_VLAN41**
- In **System > Routing > Gateways**, defined and set EXT\_VLAN41 as default IPv4 gateway
- Moved NAT and firewall rules from WAN to DMZ\_TRANSIT\_VLAN41
- Updated **Firewall > NAT > Outbound**:
  - Interface: `DMZ_TRANSIT_VLAN41`
  - Source: `192.168.41.0/24`
  - NAT Address: Interface Address
- Under **Services > DNS Resolver > General Settings**:
  - Network Interfaces: WAN, LAN, DMZ\_TRANSIT\_VLAN41
  - Outgoing Interfaces: DMZ\_TRANSIT\_VLAN41
- Verified routes under **Diagnostics > Routes**

### VyOS (opf-rt-ext)

```bash
configure
delete interfaces ethernet eth1 address 192.168.40.1/24
set interfaces ethernet eth1 vif 41 address 192.168.41.1/24
set interfaces ethernet eth1 vif 41 description 'DMZ_TRANSIT_VLAN41'
set nat source rule 100 outbound-interface eth1.41
set nat source rule 100 source address 192.168.41.0/24
set nat source rule 100 translation address masquerade
set protocols static route 192.168.50.0/24 next-hop 192.168.41.2
set protocols static route 192.168.60.0/24 next-hop 192.168.41.2
commit ; save
```

### VyOS (opf-rt-inet)

```bash
configure
set protocols static route 192.168.41.0/24 next-hop 192.168.30.2
commit ; save
```

---

## 🎯 Key Takeaways

- VLAN tagging via 802.1Q is now integrated across pfSense and VyOS
- End-to-end reachability was preserved through precise NAT and routing updates
- OPFORGE now has a DMZ segment that mirrors modern enterprise segmentation logic

---

## 🧭 On Deck

- VLAN interface tagging at the endpoint level for `opf-lnx01` and `opf-red01`
- Begin lateral movement simulation from RED\_NET → DMZ → INT
- Integrate Zeek and Winlogbeat with DNS over HTTPS tracking to analyze visibility gaps

The OPFORGE lab continues to grow into a realistic cyber terrain environment where detection, emulation, and validation are not just tested—they’re trusted.

- H.Y.P.R.

