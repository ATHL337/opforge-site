---
title: "Windows 10 Template Setup for OPFORGE"
date: 2025-05-25
tags: ["windows", "template", "opforge", "sysmon", "winlogbeat"]
---

This post documents the process of building and finalizing the **Windows 10 Pro 22H2** template for use in the OPFORGE cyber lab environment.

## 🛠️ Version & Baseline

- **OS**: Windows 10 Pro 22H2 (fully patched as of 2025-05-25)
- **Build Source**: Clean ISO install (22H2), upgraded from legacy 10240
- **Purpose**: Golden template for domain-joined endpoint clones (`opf-mbr01`, future victim hosts)

## 📦 Tool Installation via Script

After installation and patching, the following tools were installed using the custom script:

```powershell
Install-OPFORGE-WindowsTools.ps1
```

### Tools Installed:
- [x] Sysmon
- [x] Winlogbeat
- [x] 7zip
- [x] VSCode
- [x] Notepad++
- [x] Sysinternals Suite
- [x] Wireshark
- [x] Autoruns
- [x] Process Explorer

## 🔐 System Hardening

Included in the setup:
- Removal of bloatware and telemetry
- Disabling Cortana, Xbox services, OneDrive
- Clean Start Menu layout
- Chocolatey configured for repeat installs

## 🧽 Final Cleanup & Snapshot

Prior to cloning or Sysprep:
```powershell
cleanmgr /sagerun:1
powercfg -h off
```

Snapshot taken:
> `base-windows10-template - win10_22H2_tools_installed`

## ✅ Status

This image is **ready to be cloned** into production boxes like:
- `opf-mbr01`
- Future detection test targets
- Domain-joined Windows clients

---

For installation automation, refer to:
[`Install-OPFORGE-WindowsTools.ps1`](https://github.com/YOUR-REPO/Install-OPFORGE-WindowsTools.ps1)
