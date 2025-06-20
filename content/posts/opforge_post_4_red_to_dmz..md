---
title: "Post 4: Initial Connectivity – Red to DMZ Validation"
date: 2025-06-17T23:02:00-05:00 
tags: ["opforge", "connectivity", "dmz", "ping", "routing"] 
categories: ["infrastructure", "networking"] 
related_cert: ["CISSP", "OSCP"] 
tooling: ["vyos", "vmware"] 
artifact_type: ["checkpoint", "sanity_test"]
---

> "In the midst of chaos, there is also opportunity." — Sun Tzu

# ✨ Initial Connectivity – Red to DMZ Validation

This post captures the preliminary test to confirm routed communication between the Red Team subnet and the DMZ prior to full lab routing. It served as a necessary checkpoint to ensure that the segmented network was behaving as expected before DNS, NAT, and VLAN tagging were added.

---

## 📌 Abstract

**Problem:** With the new segmented topology in OPFORGE, we needed to verify that basic IP connectivity from RED → DMZ was functional before layering on DNS and full routing.

**Approach:** Use ICMP (ping), static routes, and interface-level validation to confirm reachability between `opf-rt-red` and `opf-fw-dmz`.

**Certifications Link:** Supports CISSP domain on network architecture validation and OSCP red team tradecraft (initial foothold testing).

**Outcome:** Red Team subnet confirmed to route to DMZ. Config validated and paved the way for full DNS and NAT implementation (see Post 5).

---

## 📚 Prerequisites

- VyOS routers `opf-rt-red`, `opf-rt-inet` in place with basic IP addressing
- pfSense (`opf-fw-dmz`) online and reachable
- Interfaces assigned to VMnets:
  - RED\_NET (192.168.10.0/24)
  - DMZ\_NET (192.168.50.0/24)
- Static IPs assigned, firewall rules open for ICMP

---

## ✅ Tasks This Phase

- Validate IP configuration on `opf-rt-red`, `opf-rt-inet`, and `opf-fw-dmz`
- Add temporary static routes to allow RED → DMZ traversal
- Test ICMP traffic (ping) from RED subnet VM to DMZ interface
- Document any asymmetrical behavior or drop conditions

---

## 🔧 Configuration & Validation

### Temporary VyOS Static Route (opf-rt-red)

```bash
configure
set protocols static route 192.168.50.0/24 next-hop 192.168.20.2
commit ; save
```

### Firewall Rule (pfSense – DMZ)

- Allow ICMP (IPv4) from 192.168.10.0/24 to 192.168.50.1

### Test

```bash
ping 192.168.50.1
```

---

## 🌟 Key Takeaways

- Early connectivity testing prevents deeper troubleshooting pain later
- Small-scope tests build confidence before introducing NAT, DNS, or VLANs
- Observed ICMP traffic confirmed routes and firewall rules were properly aligned

---

## 🧭 On Deck

- Expand from single hop routing to full RED → INT reachability
- Implement DNS Resolver and verify name resolution across segments (see Post 5)
- Migrate to tagged VLAN segmentation to reflect enterprise-grade architecture

Every solid build starts with a solid handshake. One ping at a time.

- H.Y.P.R.

