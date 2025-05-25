---
title: "Building Hardened Base Templates for Red, Blue, and AI VMs in OPFORGE"
date: 2025-05-25
tags: ["templates", "vmware", "ubuntu", "windows", "opforge"]
---

## base-ubuntu-2204-template

- OS: Ubuntu 22.04 LTS Minimal
- Uses: Cloning source for `opf-red01`, `opf-log01`, `opf-ai01`, `opf-cloud01`
- Hardened baseline with:
  - UFW firewall
  - SSH key-based auth
  - Git, Python, pip pre-installed
- Snapshot name: `Clean Install – Ready for Clone`

## base-windows10-template

- OS: Windows 10 Pro 22H2 (fully patched)
- Uses: Cloning source for `opf-mbr01`, future victims
- Tools installed via Chocolatey:
  - Sysmon, Winlogbeat, VSCode, Wireshark, Sysinternals
- Pre-Sysprep and snapshot-ready
