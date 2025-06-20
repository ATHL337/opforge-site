
---
title: "Post 7: VLAN Foundations and DMZ Segmentation"
date: 2025-06-19T20:45:00-05:00
time: 7:53pm
tags: ["opforge", "segmentation", "vlan", "dmz", "firewall", "routing"]
categories: ["infrastructure", "networking", "future_lab"]
related_cert: ["GCIA", "GCIH", "GCTI"]
tooling: ["vyos", "pfsense", "vmware"]
artifact_type: ["lab_log", "design_note"]
---

# 🧱 VLAN Testing and Future Segmentation

This phase introduces tagged VLAN interfaces between `opf-fw-dmz` and `opf-rt-ext`, laying groundwork for 802.1Q segmentation in the OPFORGE lab. We use VMware virtual switches to simulate VLAN isolation and test intra-zone controls before extending tagging to endpoints.

---

## 🛠️ Current IP Assignments

| Device        | Interface | IP Address      | Connected To          |
| ------------- | --------- | --------------- | --------------------- |
| `opf-rt-red`  | `eth0`    | 192.168.10.1/24 | RED_NET               |
| `opf-rt-red`  | `eth1`    | 192.168.20.1/24 | `opf-rt-inet`         |
| `opf-rt-inet` | `eth0`    | 192.168.20.2/24 | `opf-rt-red`          |
| `opf-rt-inet` | `eth1`    | 192.168.30.1/24 | `opf-rt-ext`          |
| `opf-rt-ext`  | `eth0`    | 192.168.30.2/24 | `opf-rt-inet`         |
| `opf-rt-ext`  | `eth1.41` | 192.168.41.1/24 | `opf-fw-dmz` (em0.41) |
| `opf-fw-dmz`  | `em0.41`  | 192.168.41.2/24 | `opf-rt-ext`          |
| `opf-fw-dmz`  | `em1`     | 192.168.50.1/24 | `opf-rt-int`          |
| `opf-rt-int`  | `eth0`    | 192.168.50.2/24 | `opf-fw-dmz`          |
| `opf-rt-int`  | `eth1`    | 192.168.60.1/24 | INTERNAL_NET          |

---

## 🔧 Updated Configuration and Migration Steps

### pfSense VLAN Adjustments
- Created VLAN `DMZ_TRANSIT_VLAN41` on parent `em0`, tag `41`
- Assigned interface and enabled it with static IP `192.168.41.2/24`
- Set **EXT_VLAN41** as the IPv4 upstream gateway under **Interfaces > DMZ_TRANSIT_VLAN41**
- In **System > Routing > Gateways**, defined and set EXT_VLAN41 as default IPv4 gateway
- Moved NAT and firewall rules from WAN to DMZ_TRANSIT_VLAN41
- Updated **Firewall > NAT > Outbound**:
  - Interface: `DMZ_TRANSIT_VLAN41`
  - Source: `192.168.41.0/24`
  - NAT Address: Interface Address
- Under **Services > DNS Resolver > General Settings**:
  - Network Interfaces: WAN, LAN, DMZ_TRANSIT_VLAN41
  - Outgoing Interfaces: DMZ_TRANSIT_VLAN41
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

This update ensures your VLAN41 transition doesn't disrupt existing connectivity. You've successfully promoted 802.1Q tagging and enforced controlled segmentation—positioning OPFORGE for deeper detection and policy experiments.
