---
title: "Forging the Core: Building OPFORGE's Domain Controller"
date: 2025-05-10T10:00:00-05:00
draft: false
tags: ["active directory", "windows server", "domain controller", "ad ds"]
summary: "In this post, we configure OPFORGE's foundational infrastructure by building the domain controller `opf-dc01`. We'll define our network structure, stand up Active Directory, and prepare the environment for workstation and log server integration."
---

## ✅ Check

- Define static IP plan (e.g., 192.168.77.10/24 for `opf-dc01`)
- Decide on a domain name (e.g., `opforge.local`)
- Draft realistic Organizational Unit (OU) structure
- Determine initial user/group and DNS configuration

## ⚙️ Do

- Install Windows Server 2019 (Standard Core)
- Set static IP, DNS (self-referential), and hostname
- Use `Server Manager` or `sconfig` to install AD DS role
- Promote to Domain Controller using `dcpromo` GUI or PowerShell:

```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "opforge.local" -InstallDNS -Force
```

- Create initial OU tree:
  - `OPFORGE\Computers\Servers`
  - `OPFORGE\Users\RedTeam`, `BlueTeam`, `ServiceAccounts`

## 🔍 Check

- Log in via domain admin to ensure proper promotion
- Validate `nslookup` returns local DNS
- Confirm `Active Directory Users and Computers` (ADUC) shows correct structure
- Document credentials and snapshot before member server joins
