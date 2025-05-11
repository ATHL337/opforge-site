---
title: "Windows VM Setup for OPFORGE"
date: 2025-05-06T19:00:00-05:00
draft: false
---

This guide walks through the creation of the Windows VMs used in OPFORGE, including the Domain Controller (`opf-dc01`) and the Member Workstation (`opf-mbr01`), using VMware Workstation Pro.

---

## 🛠️ Prerequisites

- VMware Workstation Pro (or Player)
- Windows Server 2019 ISO
- Windows 10/11 ISO
- Sufficient RAM (8–16 GB minimum)
- Disk space: At least 100GB free

---

## 📁 VM Folder Structure

Organize your lab directory:

```
OPFORGE-VMs/
├── opf-dc01/
└── opf-mbr01/
```

---

## 🧱 VM 1: Domain Controller (`opf-dc01`)

1. Create a new VM from the Windows Server 2019 ISO.
2. Configure:
   - **RAM**: 4096 MB
   - **Processors**: 2
   - **NIC**: NAT or Custom VMnet (e.g., `VMnet2`)
   - **Disk**: 60 GB (preallocated optional)
3. Install Windows and set hostname: `opf-dc01`
4. Set static IP (e.g., `192.168.77.10`)
5. Rename Ethernet to `LAN` (optional)
6. Promote to Domain Controller:
   ```powershell
   Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
   Install-ADDSForest -DomainName "opforge.local" -InstallDNS -Force
   ```

---

## 🖥️ VM 2: Member Workstation (`opf-mbr01`)

1. Create a new VM from the Windows 10 or 11 ISO.
2. Configure:
   - **RAM**: 4096 MB
   - **Processors**: 2
   - **NIC**: Same network as `opf-dc01`
   - **Disk**: 60 GB
3. Install Windows and set hostname: `opf-mbr01`
4. Set static IP (e.g., `192.168.77.20`) with DNS pointing to `opf-dc01`
5. Join the domain:
   ```powershell
   Add-Computer -DomainName opforge.local -Restart
   ```

---

## 🔍 Check

- Both VMs should ping each other
- Domain join successful
- Static IP and DNS validated via `ipconfig /all`
- Snapshots created after each critical stage

---

## 🔗 Related Pages

- [opf-dc01 Domain Setup](/posts/opf-dc01-domain-controller/)
- [Winlogbeat Export](/posts/winlogbeat-export-opf-mbr01/)
