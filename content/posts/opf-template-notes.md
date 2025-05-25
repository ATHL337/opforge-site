---
title: "OPFORGE Base Template Notes"
date: 2025-05-25
tags: ["templates", "vmware", "windows", "ubuntu", "opforge"]
---

## 🧱 Base Templates Used in OPFORGE

This post outlines the two core VM templates used to clone all OPFORGE lab components. Each template is hardened, snapshot-ready, and optimized for its role.

---

### 🐧 `base-ubuntu-2204-template`

- **OS**: Ubuntu 22.04 LTS (minimal ISO)
- **Usage**: Source image for all Linux-based OPFORGE components
- **Configured With**:
  - SSH key-based authentication
  - `ufw` firewall rules
  - Preinstalled: Git, Python3, pip, htop, curl, net-tools
- **Snapshot Label**: `ubuntu2204-clean-template`

### 🪟 `base-windows10-template`

- **OS**: Windows 10 Pro 22H2 (fully patched)
- **Usage**: Source image for domain-joined endpoints
- **Configured With**:
  - Tools installed via `Install-OPFORGE-WindowsTools.ps1`:
    - Sysmon, Winlogbeat, 7zip, VSCode, Sysinternals, Wireshark
  - Bloatware removal and telemetry disabled
  - Power settings and Start menu cleaned
- **Snapshot Label**: `win10_22H2_tools_installed`

---

Both templates are used to ensure consistency, repeatability, and portfolio-quality documentation across the OPFORGE environment.
