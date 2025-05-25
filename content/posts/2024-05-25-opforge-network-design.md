---
title: "Designing a Segmented Cyber Lab: OPFORGE Network Architecture"
date: 2025-05-25
tags: ["network", "architecture", "cyber lab", "opforge"]
---

## Segments

- **CSOCINFRA (192.168.20.0/24)**: Houses `opf-log01` (SIEM) and `opf-ai01` (ML detection)
- **LANWORKSTATIONS (192.168.30.0/24)**: Contains `opf-mbr01` and future endpoints
- **DMZRED (192.168.22.0/24)**: Hosts attacker targets like `opf-cloud01`
- **ADINFRA (192.168.40.0/24)**: Supports `opf-dc01` and GPO testing

## Example Host Assignments

| Host           | IP Address         | Segment         |
|----------------|--------------------|-----------------|
| opf-fw01       | 192.168.1.24 (WAN) | pfSense router  |
| opf-dc01       | 192.168.40.100     | ADINFRA         |
| opf-mbr01      | 192.168.30.101     | LANWORKSTATIONS |
| opf-red01      | 192.168.22.50      | DMZRED          |
| opf-log01      | 192.168.20.12      | CSOCINFRA       |
