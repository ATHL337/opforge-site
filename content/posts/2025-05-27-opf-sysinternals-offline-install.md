---
title: "Installing Sysinternals Suite Offline in OPFORGE"
date: 2025-05-27
draft: false
tags: ["opf-mbr01", "sysinternals", "tools", "offline", "windows"]
---

## 🎯 Purpose

In the OPFORGE lab, Chocolatey may not be reliable due to segmented DNS or network control. Here's how to install the full [Sysinternals Suite](https://learn.microsoft.com/en-us/sysinternals/) offline to a standard lab path.

---

## 🗂️ Installation Directory

All tools are installed to:

```
C:\OPFORGE\Tools\Sysinternals
```

This ensures consistent, reproducible builds and clean environment variables.

---

## 🛠️ Installation Steps

### 1. Download

From a system with internet access:

```powershell
Invoke-WebRequest -Uri "https://download.sysinternals.com/files/SysinternalsSuite.zip" -OutFile "SysinternalsSuite.zip"
```

### 2. Transfer and Install

Copy the zip to `C:\OPFORGE\SysinternalsSuite.zip`, then run:

```powershell
$toolsPath = "C:\OPFORGE\Tools\Sysinternals"
New-Item -Path $toolsPath -ItemType Directory -Force
Move-Item -Path "C:\OPFORGE\SysinternalsSuite.zip" -Destination "$toolsPath\SysinternalsSuite.zip"
Expand-Archive -Path "$toolsPath\SysinternalsSuite.zip" -DestinationPath $toolsPath -Force
```

### 3. Update System Path

```powershell
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$toolsPath", [EnvironmentVariableTarget]::Machine)
```

---

## ✅ Result

You can now run Sysinternals tools (like `tcpview`, `autoruns`, `procmon`) from any command line on the system. This method avoids Chocolatey errors and supports air-gapped deployment.

