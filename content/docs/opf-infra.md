# OPFORGE Infrastructure Overview

## Overview
OPFORGE began as a minimal cyber range with SOF-ELK and basic telemetry ingest, and has evolved into a segmented, multi-role portfolio lab for red team emulation, detection engineering, and AI-enhanced threat analysis.

## Evolution Timeline

### Phase 1: Initial Sandbox
- Single VM (SOF-ELK)
- Flat network, no segmentation
- Manual log ingestion

### Phase 2: Tactical Expansion
- Added pfSense (`opf-fw01`)
- Introduced segmentation: `CSOCINFRA`, `DMZRED`, `LANWORKSTATIONS`, `ADINFRA`
- First red team emulation with `opf-red01`
- Winlogbeat and Sysmon on endpoints

### Phase 3: Professionalization
- Cloned base templates (`base-ubuntu-2204-template`, `base-windows10-template`)
- VM-specific roles: `opf-ai01`, `opf-log01`, `opf-mbr01`, etc.
- AI and ML integration via Jupyter (`opf-ai01`)
- Multi-tiered ingest pipeline (Zeek → Logstash → OpenSearch)

## Lessons Learned
- Legacy OS images break modern tools
- Cloning base templates improves consistency
- Network segmentation is essential for realistic detection engineering
