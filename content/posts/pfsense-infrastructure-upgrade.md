---
title: "Hardening OPFORGE: Introducing pfSense for Realistic Network Segmentation and Ingestion Control"
description: "The OPFORGE lab just got an infrastructure upgrade. With pfSense now in place, we're embracing more realistic routing, access control, and visibility boundaries."
date: 2025-05-20
tags: ["OPFORGE", "pfSense", "lab architecture", "SIEM", "SOF-ELK", "network segmentation"]
---

### 🎯 Why the Change?

OPFORGE started as a standalone lab stack running on bridged VMware interfaces. While effective for prototyping, it lacked the **network realism needed to validate detection engineering workflows at scale**.

So, we leveled up.

---

### 🔐 What’s New?

We’ve now integrated **pfSense as the central gateway and firewall**, enabling:

- 🔀 **True Layer 3 segmentation** between subnets:
  - `192.168.20.0/24` — CSOC infrastructure (SOF-ELK, Domain Controller)
  - `192.168.30.0/24` — LAN workstations (MBR01, RED01)
  - `192.168.22.0/24` — DMZ for threat emulation
  - `192.168.1.0/24` — WAN uplink with internet access
- 🎯 **Controlled routing** with testable firewall rules
- 🧱 **Policy zones** mapped to pfSense firewall aliases: CSOCINFRA, LANWORKSTATIONS, DMZRED
- 🧪 Realistic paths for log ingestion, threat emulation, and adversary simulation

---

### 📐 Architecture Overview

```plaintext
[OPF-MBR01] ---+
               |       +-------------------------------+
[OPF-RED01] ---+------>|        opf-fw01 (pfSense)     |------> [OPF-LOG01 / SOF-ELK]
               |       |                               |         [OPF-DC01, OPF-FW01]
               |       | em1: 192.168.30.5 (LANWORKSTATIONS)
               |       | em2: 192.168.22.100 (DMZRED)
               |       | em3: 192.168.20.5 (CSOCINFRA)
               |       | em0: 192.168.1.24 (WAN - Internet)
               +------>|        Realistic ACL zones     |
                       +-------------------------------+
```

---

### ✅ Benefits

- 🧠 **Operator realism**: Windows boxes now live in a LAN, not on a flat bridge
- 🔎 **Inbound/Outbound ACLs** mirror real-world trust boundaries
- 🧪 **Detection scenarios** like beaconing, pivoting, and log manipulation can be tested across routed segments
- 🚧 **Air-gapped environment with controlled WAN access**

---

### 🧩 Current Logflow Snapshot

- Winlogbeat exports `.evtx`-derived logs from LANWORKSTATIONS to SOF-ELK over port `5044`
- SCP is restricted via firewall rules and managed SSH key exchange
- Only systems in `192.168.30.0/24` are allowed to interact with Logstash (CSOCINFRA)

---

### 🧠 Next Up

- 🔁 Full DMZ logging for red team emulation in `192.168.22.0/24`
- 🌐 Add Zeek or Suricata to tap and inspect DMZRED
- 🧰 Set up IDS/IPS alert pipelines and visualizations in Kibana
- 🛠️ Trigger event-based enrichment from firewall logs

---

The network just got smarter. The detections will have to keep up.

*Ride the storm.*
