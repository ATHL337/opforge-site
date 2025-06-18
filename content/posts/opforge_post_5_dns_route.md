---
title: "Post 5: End-to-End Routing from RED_NET to INTERNAL_NET" 
date: 2025-06-17 
tags: ["opforge", "routing", "dns", "network-debug", "segmentation"] 
categories: ["infrastructure", "redteam", "blueteam"] 
related_cert: ["GCIA", "GCFA", "GCIH"] 
tooling: ["vyos", "pfsense", "vmware", "windows", "linux"] 
artifact_type: ["lab_log", "troubleshooting_notes"]
---

> "The network is like a novel. Every route a sentence, every packet a word, and every dropped reply a plot twist." — Unknown

## 🧠 Summary

This milestone focused on resolving the final stretch of segmented routing in OPFORGE: achieving stable, validated connectivity from the RED\_NET enclave to hosts inside INTERNAL\_NET. After prior success establishing DMZ reachability from RED\_NET, we diagnosed and corrected final edge-case routing issues.

## ✅ Key Achievements

- 🔄 **All routers (opf-rt-\*) and pfSense firewall configured with consistent, valid static routes**
- 📈 **ICMP and traceroute tests confirmed full reachability from RED\_NET to INTERNAL\_NET**
- 🔧 **Corrected misleading or missing gateway definitions in pfSense and VyOS routers**
- 🖥️ **Validated that Windows host **`OPF-DC01`** inside INTERNAL\_NET can reach gateway and nearby routers**

## 🧩 Network Topology Recap

All devices now adhere to the segmented routing plan defined in [Post 4](opforge_post_4_routing_rednet_dmz.md). This includes rhymed IP subnets for traceability:

```
RED_NET     -> 192.168.10.0/24
INET Transit-> 192.168.20.0/24
EXT Transit -> 192.168.30.0/24
DMZ Transit -> 192.168.40.0/24
DMZ ↔ INT    -> 192.168.50.0/24
INTERNAL_NET-> 192.168.60.0/24
```

Latest route tests confirm all hops traverse this path cleanly:

```
opf-lnx01 (10.10)
-> opf-rt-red (10.1/20.1)
--> opf-rt-inet (20.2/30.1)
---> opf-rt-ext (30.2/40.1)
----> opf-fw-dmz (40.2/50.1)
-----> opf-rt-int (50.2/60.1)
------> INTERNAL_NET endpoint (60.100)
```

## 🔍 Observed Issues and Fixes

| Problem                                                                | Resolution                                                                            |
| ---------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| 🔁 TTL exceeded on pings from RED\_NET to INTERNAL\_NET                | Static route from pfSense to 192.168.60.0/24 was missing or mispointed                |
| 🔀 `opf-rt-red` routing table contained incorrect or duplicate entries | Cleaned up conflicting default routes; committed properly                             |
| ❌ `OPF-DC01` could not reach 192.168.50.1                              | Likely blocked by pfSense rules; access verified via traceroute and validated routing |

## 🗂️ Artifacts Created

- Static routes defined on all VyOS routers and pfSense via `/etc/rc.conf.local`
- Screenshots of `ping`, `traceroute`, and `route -v` outputs
- Updated diagram and ASCII network maps in previous post

## 🚧 Next Steps: DNS Enablement & Resolver Strategy

The next evolution in the OPFORGE network will enable:

- DNS query resolution for all enclaves (RED, DMZ, INT)
- Integration of local domain resolution via `OPF-DC01`
- Optional DNS forwarding through pfSense or VyOS to upstream (Cloudflare or Google)
- Visibility and detection alignment using DNS logs

> **Coming Next:** Post 6 will focus on DNS Resolver & Forwarder Architecture for OPFORGE, establishing end-to-end name resolution that supports emulation tooling, updates, and domain-aware logging.

We will also begin to examine how DNS telemetry feeds detection pipelines in enterprise environments.