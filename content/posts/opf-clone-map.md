---
title: "OPFORGE VM Clone Map"
date: 2025-05-25
tags: ["vm cloning", "vmware", "lab design", "opforge"]
---

## 🔁 Cloned VMs in the OPFORGE Lab

The following VMs are derived from the base templates and customized for their operational roles.

| Template                  | Clone         | Role Description                  |
|---------------------------|---------------|-----------------------------------|
| base-ubuntu-2204-template | `opf-red01`   | Red Team operator + C2 lab        |
| base-ubuntu-2204-template | `opf-log01`   | Log ingestion + OpenSearch stack  |
| base-ubuntu-2204-template | `opf-ai01`    | ML/AI detection modeling          |
| base-ubuntu-2204-template | `opf-cloud01` | Web app target in DMZRED          |
| base-windows10-template   | `opf-mbr01`   | Domain-joined endpoint (Win10)    |

## 🧠 Notes
- Hostnames and static IPs are applied per segment
- Each VM is configured with dedicated virtual NICs
- Cloning process preserves snapshot state and configuration integrity
