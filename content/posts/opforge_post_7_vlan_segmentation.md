---
title: "Post 7: VLAN Foundations and DMZ Segmentation" 
date: 2025-06-19T18:45:00-05:00 
tags: ["opforge", "segmentation", "vlan", "dmz", "firewall", "routing"] 
categories: ["infrastructure", "networking", "future_lab"] 
related_cert: ["CISSP", "OSCP", "GCFA", "GCFR", "GREM", "GXPN"] 
tooling: ["vyos", "pfsense", "vmware"] 
artifact_type: ["lab_log", "design_note"]
---

> "Divide and rule, the politician cries; unite and lead, is watchword of the wise." — Johann Wolfgang von Goethe

# ✨ VLAN Foundations and DMZ Segmentation

This post documents the foundational setup of VLAN-based segmentation in the OPFORGE lab, focusing on the transition from flat subnets to trunked interfaces and routed VLANs. It marks a major step in the network maturity of the lab, preparing for more realistic Red Team lateral movement simulations and Blue Team detection scenarios.

---

## 📌 Abstract

**Problem:** Flat subnets constrained emulation fidelity and detection depth in the OPFORGE lab.

**Approach:** Implement 802.1Q VLAN tagging between pfSense and VyOS to route traffic across a dedicated DMZ transit network. Reassign NAT, DNS, and firewall rules to support segmentation.

**Alignment:** This phase reinforces domain knowledge across CISSP (architecture), OSCP (pivoting), GCFA (network boundaries), and GXPN (attack paths).

**Outcome:** A trunked VLAN transit network now supports east-west segmentation, setting the stage for endpoint tagging and future visibility validation.

---

## 📚 Prerequisites

- VMware Workstation Pro with bridged and internal VMnets
- `opf-fw-dmz` as pfSense 2.7.2
- `opf-rt-ext` and `opf-rt-inet` running VyOS
- Prior completion of Post 5: DNS + Routing end-to-end
- Comfortable with CLI-based firewall and router config

---

## ✅ Tasks This Phase

- Tag VLAN 41 on pfSense and VyOS
- Assign 192.168.41.x/24 to em0.41 and eth1.41
- Refactor routing, NAT, and DNS settings to use the new VLAN
- Transition firewall rules from WAN to VLAN interface

---

## 🔧 Configuration Summary

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

### pfSense (opf-fw-dmz)

- Add VLAN 41 on `em0` → `em0.41`
- Set static IP: `192.168.41.2/24`
- Set upstream gateway: `EXT_VLAN41`
- Move firewall rules from WAN to VLAN interface
- NAT: Source = `192.168.41.0/24`, Interface NAT
- DNS Resolver: Listen + Outgoing = VLAN41

### Routing Update (opf-rt-inet)

```bash
configure
set protocols static route 192.168.41.0/24 next-hop 192.168.30.2
commit ; save
```

---

## 🌟 Key Takeaways

- VLAN tagging via 802.1Q is now integrated across pfSense and VyOS
- End-to-end reachability was preserved through precise NAT and routing updates
- OPFORGE now has a DMZ segment that mirrors modern enterprise segmentation logic

---

## 🧭 On Deck

- VLAN interface tagging at the endpoint level for `opf-lnx01` and `opf-red01`
- Begin lateral movement simulation from RED\_NET → DMZ → INT
- Integrate Zeek and Winlogbeat with DNS over HTTPS tracking to analyze visibility gaps

The OPFORGE lab continues to evolve into a trusted, validated cyber operations training ground where every emulation leaves a detection trail—by design.

- H.Y.P.R.

