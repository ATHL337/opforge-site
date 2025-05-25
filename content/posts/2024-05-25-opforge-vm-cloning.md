---
title: "Scaling OPFORGE: How I Clone and Manage Cyber Range VMs"
date: 2025-05-25
tags: ["vmware", "cloning", "automation", "opforge"]
---

## Clone Map

| Template                   | Clone Name     | Purpose                         |
|----------------------------|----------------|---------------------------------|
| base-ubuntu-2204-template  | opf-red01      | Red Team operator box          |
| base-ubuntu-2204-template  | opf-log01      | Log pipeline (Zeek, OpenSearch)|
| base-ubuntu-2204-template  | opf-ai01       | Jupyter + anomaly detection    |
| base-ubuntu-2204-template  | opf-cloud01    | Targeted web app for attack    |
| base-windows10-template    | opf-mbr01      | Domain-joined endpoint          |

## Lessons Learned
- Clone from snapshot, then personalize (hostname, NIC, IP)
- Use base templates with all dependencies pre-installed
- Maintain consistency across VM builds using scripting and snapshots
