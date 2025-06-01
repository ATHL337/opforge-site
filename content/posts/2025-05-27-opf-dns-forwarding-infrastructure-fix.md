---
title: "Fixing DNS Resolution in OPFORGE: Domain Forwarding via pfSense"
date: 2025-05-27
draft: false
tags: ["opf-mbr01", "opf-dc01", "dns", "pfsense", "forwarders"]
---

## 🧩 Problem Summary

After placing `OPF-DC01` into the `ADINFRA` subnet (192.168.40.0/24), `OPF-MBR01` was unable to resolve public domains such as `google.com`. DNS requests to `192.168.40.100` (the DC) failed to resolve, even though routing to the firewall was functional.

---

## 🔍 Root Cause

By default, `OPF-DC01` was not forwarding DNS queries to a working upstream resolver. Attempted use of public DNS forwarders like `8.8.8.8` and `1.1.1.1` failed because `OPF-DC01` had **no internet access** in the segmented lab setup.

---

## ✅ Solution Summary

We aligned the DNS architecture with best practice by:

1. **Keeping OPF-DC01 isolated** to ADINFRA (no internet).
2. **Forwarding external DNS requests to pfSense** at `192.168.40.5`.

---

## 🔧 Step-by-Step Fix

### 1. Update DNS Forwarders on `OPF-DC01`

- Open **DNS Manager**
- Right-click the server → **Properties**
- Go to **Forwarders** tab
- Remove any entries for `8.8.8.8` or `1.1.1.1`
- Add: `192.168.40.5`

Then open PowerShell and run:

```powershell
dnscmd /clearcache
```

### 2. Ensure DNS Resolver is Active on pfSense

- Navigate to **Services > DNS Resolver**
- Ensure it is **enabled** and **listens on all interfaces**

Optional:
- Add `8.8.8.8` and `1.1.1.1` under **System > General Setup > DNS Servers** (for pfSense to reach the internet).

### 3. Verify from Domain Clients

From `OPF-MBR01`:

```powershell
nslookup google.com 192.168.40.100
Test-NetConnection google.com -Port 443
```

Expected output:

- DNS resolved to public IP
- HTTPS port is reachable

---

## 📌 Result

Domain-joined workstations now use the domain controller for internal resolution, and the domain controller relies on the **pfSense firewall for external resolution**, mirroring realistic enterprise segmentation.

