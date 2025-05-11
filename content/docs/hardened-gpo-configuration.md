---
title: "Hardened GPO Configuration for OPFORGE"
date: 2025-05-11T09:00:00-05:00
draft: false
---

This document outlines the hardened Group Policy Object (GPO) configuration applied to `opf-dc01.opforge.local` within the `opforge.local` Active Directory domain. This GPO includes best-practice security settings tailored to the OPFORGE environment.

---

## 📁 GPO Overview

- **GPO Name**: Hardened Windows Baseline
- **GPO GUID**: `{5972D448-D77A-41DA-9820-E7F28FE7AFAE}`
- **Linked To**: Domain - `opforge.local`
- **Enforced**: No
- **Security Filtering**: Authenticated Users

---

## 🔐 Security Settings

These settings are managed via the Security Configuration Editor (`SecEdit\GptTmpl.inf`):

### Account Lockout Policy
- Lockout threshold: 5 invalid attempts
- Lockout duration: 15 minutes
- Reset count after: 15 minutes

### Password Policy
- Enforce password history: 24 passwords remembered
- Maximum password age: 60 days
- Minimum password length: 14 characters
- Complexity requirements: Enabled

### Audit Policy
Located in `Audit\audit.csv`:
- Audit logon events: Success and Failure
- Audit object access: Failure
- Audit process tracking: Success
- Audit system events: Success and Failure

---

## 🔍 File System & Registry Hardening

- NTFS permissions tightened for `%SystemRoot%`, `C:\Windows\System32`
- User rights assignments for shutdown, logon locally, remote access
- Registry keys locked down for critical services

---

## 🚫 Disabled Features

- Administrative shares disabled (e.g., `ADMIN$`, `C$`)
- SMBv1 disabled
- Guest account renamed and disabled
- Null sessions and anonymous enumeration disabled

---

## 🔄 Scripts & Automation

- No startup or logon scripts defined
- Can be extended with PowerShell deployment automation

---

## ✅ Verification Steps

1. Run `gpresult /h gpo-report.html` to validate application
2. Check Event Viewer for GroupPolicy Operational logs
3. Use `LGPO.exe` or `secedit /analyze` to test template enforcement
4. Export and version-control for reproducibility

---

> This configuration balances best-practice hardening with operational stability for a training and emulation environment.
