---
title: "Post 6: DNS and Routing Lock-in across OPFORGE Zones"
date: 2025-06-19
tags: ["opforge", "routing", "dns", "lab-network", "firewall", "troubleshooting"]
categories: ["infrastructure", "redteam", "blueteam"]
related_cert: ["GCFA", "GCFR"]
tooling: ["vyos", "pfsense", "vmware", "windows", "linux"]
artifact_type: ["lab_log", "config_guidance", "snapshot_milestone"]
---

# ✅ Phase Summary

We’ve reached a critical milestone: stable **end-to-end routing and DNS resolution across all OPFORGE zones**, including RED_NET, INTERNAL_NET, and DMZ. This post captures what it took to get there, the routing fixes, NAT updates, DNS handoffs, and the principle of least privilege in firewall policies.

---

## 🧠 Background

The OPFORGE lab was originally designed with segmentation across five main zones:

- **RED_NET** (Offensive tools and test payloads)
- **INTERNAL_NET** (Enterprise clients and DC)
- **EXT_NET** (Gateway between RED and DMZ)
- **DMZ_NET** (Public-facing infrastructure simulation)
- **InternetSim** (Outbound internet access)

The challenge was building **a realistic trust boundary** enforced by routers and firewalls—while ensuring systems could still route, resolve, and log across appropriate zones.

---

## 🔧 DNS Role Assignment

To enforce separation of concern and traceable DNS activity, we explicitly assigned roles for DNS resolution across the routers and firewalls:

| Router        | Interface Role         | Primary DNS    | Fallback DNS           | Notes                                           |
|---------------|------------------------|----------------|------------------------|-------------------------------------------------|
| `opf-rt-int`  | Internal network       | 192.168.60.5   | 1.1.1.1, 8.8.8.8       | AD DNS for internal name resolution             |
| `opf-rt-inet` | Internet gateway       | 1.1.1.1        | 8.8.8.8                | No internal resolution, strict egress DNS       |
| `opf-rt-red`  | Red Team network       | 192.168.50.1   | 1.1.1.1                | Uses pfSense DNS for monitoring/logging         |
| `opf-rt-ext`  | External/DMZ router    | 192.168.50.1   | 1.1.1.1                | Simulated public infra, isolated                |
| `opf-fw-dmz`  | DMZ Firewall           | 1.1.1.1        | 8.8.8.8                | Forwarding DNS, optionally recursive            |

This clean separation ensures traceability of DNS queries and allows simulation of **exfiltrating to external resolvers** versus resolving internal enterprise assets.

---

## 🔀 Routing Adjustments and NAT Observations

One of the key wins was troubleshooting a **lack of return traffic** from `opf-rt-int` to `opf-rt-inet`. The fix required:

- Adding a static route on `opf-rt-int`:  
  ```vyos
  set protocols static route 192.168.40.0/24 next-hop 192.168.60.1
  ```
- Verifying that NAT rules were applied **only** on routers at the edge of their zone.
- Cleaning up legacy `system name-server` entries with:  
  ```vyos
  delete system name-server <old_ip>
  ```

We then committed all changes and validated traffic flow **using ping, traceroute, nslookup, and curl** across the entire topology.

---

## 🔐 Firewall Lockdown

The next layer of hardening was done through `opf-fw-dmz` in pfSense. Initially, ICMP traffic from INTERNAL_NET to RED_NET was being **dropped silently** by the default deny rule.

We replaced the blanket “allow all” LAN rule with precision:

- ✅ Allow DNS (TCP/UDP 53) from INTERNAL to DC
- ✅ Allow NTP (UDP 123)
- ✅ Allow Web (TCP 80/443) only where needed
- ✅ Allow ICMP selectively
- ❌ Block all else with an explicit `DENY ALL` TCP rule at the bottom

Result: **Functional but auditable paths**, enabling future logging of malformed or suspicious packets.

---

## 🧪 Final Validations

From `OPF-DC01`:
- 🟢 Can ping all expected routers
- 🟢 `nslookup google.com` resolves via `opf-fw-dmz`
- 🟢 `tracert` validates return paths
- 🟢 Internal name resolution (`opf-dc01.opforge.local`) functions as intended

Captured logs in pfSense confirm that **denied packets now show proper rule association** and help trace misconfigurations faster.

---

## 📦 Snapshot Recommendation

After completing this, I took **snapshots of all active VMs** under the `OPFORGE Phase 1 - Routing + DNS Lock-in` milestone. Recommend tagging all systems now that:

- DNS is resolvable per trust boundary
- NAT is applied only where required
- Static routes cover all isolated subnets
- pfSense rule logic is layered, traceable, and minimal

---

## 📁 Next Up

In Post 7, I’ll introduce:
- 🧱 VLAN testing for future segmentation
- 🧪 Simulated lateral movement from RED_NET → DMZ → INT
- 🧠 DNS over HTTPS vs. internal detection via Zeek and Winlogbeat

> Each success builds resilience. We’re simulating the fog of war, but laying fiber-optic clarity beneath it.

Stay sharp.

—HYPR
