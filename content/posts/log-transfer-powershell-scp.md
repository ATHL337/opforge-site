---
title: "From Host to Hive: Transferring Logs with PowerShell + SCP"
date: 2025-05-09T14:00:00-05:00
draft: false
tags: ["powershell", "automation", "scp", "winlogbeat"]
summary: "This post describes how to automate the conversion and transfer of Winlogbeat logs from `opf-mbr01` to `opf-log01` using PowerShell and SCP."
---

## ✅ Check

- SCP tool (e.g., `pscp.exe`) installed
- SSH keypair created and trusted by SOF-ELK
- Export directory contains `.ndjson` files
- Target path on SOF-ELK exists and is writable

## ⚙️ Do

Create a PowerShell script:

```powershell
$sourceFolder = "C:\ProgramData\winlogbeat\opforge-export"
$tempOutput = "C:\Temp\opforge-winlogbeat-cleaned.json"
$sofElkUser = "elk_user"
$sofElkHost = "192.168.77.40"
$sofElkDest = "/logstash/kape/"
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$finalFile = "opforge-winlogbeat-$timestamp.json"

# Process and transfer
Get-ChildItem $sourceFolder -Filter "winlogbeat.json-*.ndjson" | ForEach-Object {
    Get-Content $_.FullName | ForEach-Object {
        try {
            $event = $_ | ConvertFrom-Json
            $event | ConvertTo-Json -Depth 10 -Compress
        } catch {}
    } | Out-File -Encoding utf8 -FilePath $tempOutput

    & 'C:\Program Files\PuTTY\pscp.exe' -i "C:\Users\Administrator\Documents\id_rsa.ppk" `
        $tempOutput "$sofElkUser@$sofElkHost:$sofElkDest$finalFile"

    Remove-Item $_.FullName -Force
}
```

## 🔍 Check

- JSON files arrive in `/logstash/kape/` on `opf-log01`
- Files are parseable with `jq` or `cat | head`
- SCP transfer succeeds without errors
