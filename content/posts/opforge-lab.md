---
title: "OPFORGE Lab Infrastructure Overview"
date: 2025-05-22
draft: false
tags: ["infrastructure", "vmware", "network", "winlogbeat", "detection", "elk"]
categories: ["Documentation"]
---

# OPFORGE Lab Infrastructure

The OPFORGE lab is a purpose-built environment for **Detection Engineering** and **Threat Emulation**. It supports training, research, and portfolio alignment with strategic post-military goals, such as cyber-AI integration at national labs.

---

## 🎯 Lab Objectives

- Validate and develop Windows/Linux detections
- Integrate threat emulation and enrichment pipelines
- Serve as backend for AI-driven triage (via **OPFORIA**)
- Support SkillBridge and civilian career transition

---

## 🧱 Virtual Machines (VMs)

All systems are hosted in **VMware Workstation Pro**, following the `OPF-*` naming convention:

| VM Name       | Role                    | IP / Network           | Notes                                 |
|---------------|-------------------------|------------------------|----------------------------------------|
| `OPF-DC01`    | Domain Controller       | `192.168.20.100`       | Windows AD + DNS server                |
| `OPF-MBR01`   | Workstation             | `192.168.30.101`       | Winlogbeat + KAPE staging              |
| `OPF-LOG01`   | SOF-ELK (Ubuntu-based)  | `192.168.20.12`        | Ingest endpoint for Winlogbeat + JSON |
| `OPF-BLUE01`  | DFIR Workstation (SIFT) | —                      | Analysis, timeline creation, triage    |
| `OPF-RED01`   | Threat Emulation        | —                      | Atomic Red Team, emulation scripts     |
| `OPF-FW01`    | pfSense Firewall        | Multi-homed            | Segments and controls all traffic      |

---

## 🌐 Network Architecture

| Interface | Name            | IP               | Subnet             | Purpose                        |
|----------:|-----------------|------------------|--------------------|--------------------------------|
| `em0`     | WAN             | `192.168.1.24`   | `192.168.1.0/24`   | Internet uplink                |
| `em1`     | LANWORKSTATIONS| `192.168.30.5`   | `192.168.30.0/24`  | End-user endpoints             |
| `em2`     | DMZRED          | `192.168.22.100` | `192.168.22.0/24`  | Red team operations            |
| `em3`     | CSOCINFRA       | `192.168.20.5`   | `192.168.20.0/24`  | Logging, domain, core systems  |

---

## 📝 Logging & Ingestion Pipeline

### **Winlogbeat Setup**
- Host: `OPF-MBR01`
- Collects: `Security` logs (Event ID 4624 confirmed)
- Permissions: `NT SERVICE\Winlogbeat` in **Event Log Readers**
- Destination: `OPF-LOG01:5044` via `ens36`

### **SOF-ELK (OPF-LOG01)**
- OS: Ubuntu (latest SOF-ELK)
- Ingest port: TCP `5044`
- Alternate pipeline:
  - Path: `/logstash/kape/`
  - Config: `5000-opforge-kape-file.conf`
  - Used for KAPE-exported JSON/EVTX data

---

## 🔄 Automation & Tooling

### **Winlogbeat Transfer Script**
- Scripted export, enrichment, and SCP transfer:
  - Converts `.evtx` → JSON via `EvtxECmd`
  - Bundled tools:
    - `KAPE` in `C:\OPFORGE\bin\KAPE\`
    - `PuTTY/pscp.exe` in `C:\OPFORGE\bin\PuTTY\`
  - Output: `opforge-winlogbeat-YYYYMMDDHHMMSS.json`

### **Future Enhancements**
- Remove internet from `ens33` on `OPF-LOG01`
- Hardened east-west segmentation via pfSense
- CI-driven asset generation and detection validation
- Host `OPFORIA` ML agent on `opforia.com`

---

## 🛠 Tooling & Integrations

- **Atomic Red Team**: Deployed on `OPF-RED01`
- **KAPE + EvtxECmd**: For forensic exports
- **SIFT Workstation**: Investigation and triage
- **SOF-ELK**: Central SIEM for ingestion, detection tuning
- **Stream Deck** (Host): Available for macro-driven control tasks

---

## 📌 Roadmap

- 🔐 Harden access controls and isolate interfaces
- 📈 Build detection analytics into `OPFORIA`
- 📄 Publish detection results and walkthroughs via blog
- 🧪 Integrate ATT&CK-mapped emulation campaigns
- 🔧 Establish tiered detection pipelines (atomic → analytic → AI)

---

For additional walkthroughs, visit the [OPFORGE Series](/tags/opforge/) or check out related GitHub repositories.
