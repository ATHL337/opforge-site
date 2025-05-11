---
title: "OPFORGE Overview"
date: 2025-05-04T08:00:00-05:00
draft: false
tags: [overview, opforge, lab-setup, project]
summary: "Introducing the OPFORGE project—a purpose-built cyber operations lab focused on threat emulation, detection engineering, and explainable AI."
---

Welcome to **OPFORGE**: the _Operational Forge_ for modern cyber capabilities. This blog series documents the buildout of a flexible, high-fidelity lab designed to support:
- Threat emulation using tools like Atomic Red Team and custom adversary simulations
- Detection engineering against MITRE ATT&CK TTPs
- Ingestion and correlation using SOF-ELK and custom pipelines
- AI/ML-assisted triage and explainable decision pipelines

The infrastructure is powered by a set of virtual machines hosted in VMware Workstation Pro, starting with:

- `opf-dc01`: Windows Server Domain Controller for Active Directory
- `opf-log01`: SOF-ELK-based ingestion server
- `opf-mbr01`: Windows 10 Member Workstation (target for attack + log source)
- `opf-red01`: Threat emulation box (C2 + Atomic)
- `opf-blue01`: Analyst jumpbox (Kibana, Sigma, notebooks)

The lab is logically segmented using a `192.168.77.0/24` network and tracks realistic OU and host deployment for flexibility.

Stay tuned for detailed Check–Do–Check style walkthroughs.
