---
title: "OPFORGE Lab v2.0: Realistic Network Segmentation and Detection Design"
date: 2025-05-22
tags: ["opforge", "lab-architecture", "detection", "redteam", "blueteam"]
description: "A complete network upgrade to support realistic cyber operations, detection engineering, and AI/ML analysis across segmented Red/Blue lanes."
draft: false
---

## 🧠 Why the Upgrade?

The initial OPFORGE lab design served well for early Winlogbeat ingestion and Red Team inject testing, but lacked realistic network boundaries. As the project evolved into a threat emulation and explainable detection platform, the need for **segmented lanes**, **realistic routing**, and **better telemetry visibility** became clear.

---

## 🧱 New Subnet Architecture

| Subnet Name        | CIDR              | Purpose                                       |
|--------------------|-------------------|-----------------------------------------------|
| `MGMT`             | 192.168.10.0/24   | Firewall and jump host access (OOB)           |
| `CSOCINFRA`        | 192.168.20.0/24   | Logstash, OpenSearch, Jupyter, ML pipelines   |
| `ADINFRA`          | 192.168.21.0/24   | Domain controllers, core IT services          |
| `DMZRED`           | 192.168.22.0/24   | Red Team attacker infrastructure              |
| `DMZWEB`           | 192.168.23.0/24   | Decoy web servers, phishing targets           |
| `LANWORKSTATIONS`  | 192.168.30.0/24   | User systems and analyst boxes                |
| `ISOLAB`           | 192.168.40.0/24   | Malware sandbox, REMnux, FLARE workstation    |

Each subnet represents a security boundary, making traffic control and logging cleaner and more realistic.

---

## 🔐 Firewall Routing Logic (opf-fw01)

| Source → Destination     | Default Policy         |
|--------------------------|------------------------|
| `DMZRED` → `ADINFRA`     | Block (unless testing) |
| `DMZRED` → `LANWORKSTATIONS` | Allow (inject scope)    |
| `LANWORKSTATIONS` → `CSOCINFRA` | Allow             |
| `ISOLAB` → Any           | Block all              |
| `MGMT` → All             | Allow (admin access)   |
| `CSOCINFRA` → All        | Allow (read-only/logs) |

This separation is critical for OPFORGE’s Blue Team learning, detection engineering, and Red Team emulation paths.

---

## 🖥️ Updated VM Deployment Model

| Hostname        | Subnet             | Role                                      | IP Address        |
|------------------|--------------------|-------------------------------------------|-------------------|
| `opf-fw01`       | All                | pfSense firewall/router                   | Varies per iface  |
| `opf-dc01`       | `ADINFRA`          | Domain controller                         | 192.168.21.100    |
| `opf-mbr01`      | `LANWORKSTATIONS`  | Test workstation (user target)            | 192.168.30.101    |
| `opf-blue01`     | `LANWORKSTATIONS`  | Winlogbeat/Sysmon sensor                  | 192.168.30.10     |
| `opf-blue02`     | `LANWORKSTATIONS`  | Alternate sensor (e.g. Slingshot)         | 192.168.30.11     |
| `opf-red01`      | `DMZRED`           | Kali/Parrot Red Team box                  | 192.168.22.10     |
| `opf-red02`      | `DMZRED`           | Commando VM                               | 192.168.22.11     |
| `opf-c2-01`      | `DMZRED`           | Sliver or Mythic C2 server                | 192.168.22.100    |
| `opf-detect01`   | `CSOCINFRA`        | Logstash + OpenSearch                     | 192.168.20.20     |
| `opf-log01`      | `CSOCINFRA`        | Winlogbeat forwarder ingest endpoint      | 192.168.20.12     |
| `opf-research01` | `CSOCINFRA`        | Jupyter/ML model development              | 192.168.20.25     |
| `opf-re01`       | `ISOLAB`           | Malware analysis (REMnux/FLARE)           | 192.168.40.21     |
| `opf-triage01`   | `ISOLAB`           | Triage (SOF-ELK/KAPE viewer)              | 192.168.40.30     |
| `opf-web01`      | `DMZWEB`           | Web server for Red Team phishing targets  | 192.168.23.50     |

---

## 📍 What's Next?

- [ ] Deploy and test each VM with correct subnet and firewall access
- [ ] Validate Winlogbeat/Sysmon output to `opf-detect01`
- [ ] Add Zeek sensors to monitor `DMZRED` and `LANWORKSTATIONS`
- [ ] Publish detection engineering rules for injected TTPs
- [ ] Build visual diagrams for full lab and include in GitHub

---

This upgrade brings OPFORGE in line with professional-grade detection labs and research environments like MITRE CALDERA, CCDC red/blue exercises, and APT emulation studies. It sets the stage for structured playbook development and explainable ML detection pipelines.

---

Want to see a diagram of this setup? It’s in the works.
