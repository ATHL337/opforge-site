---
title: "Exporting Winlogbeat Logs to SOF-ELK"
date: 2025-05-10
draft: false
---

## 🔍 Purpose
Enable structured Windows event logs to flow from OPFORGE's Windows Member VM to SOF-ELK using Winlogbeat, a JSON exporter, and PowerShell automation.

---

## ✅ Prerequisites

- Windows 10/11 host joined to domain (e.g., `OPF-MBR01`)
- Winlogbeat installed and configured
- SSH access to SOF-ELK (e.g., `elk_user@192.168.77.40`)
- Valid PuTTY key pair (`.ppk`) for SCP transfers (if using PSCP)
- Target folder on SOF-ELK writable by `elk_user` (e.g., `/logstash/kape/`)

---

## 🔧 Check–Do–Check Workflow

### 🔍 Check
- Confirm Winlogbeat is writing `.ndjson` files locally:
  ```powershell
  Get-ChildItem -Path 'C:\ProgramData\winlogbeat\opforge-export' -Filter *.ndjson
  ```

### ✅ Do
#### 1. Configure Winlogbeat to output JSON
Edit `winlogbeat.yml`:
```yaml
output.file:
  path: "C:/ProgramData/winlogbeat/opforge-export"
  filename: "winlogbeat.json"
  rotate_every_kb: 10000
  number_of_files: 5
  codec.format:
    string: '%{[message]}'
```
Restart the Winlogbeat service:
```powershell
Restart-Service winlogbeat
```

#### 2. Create Export Script
File: `Export-WinlogbeatToSOFELK.ps1`

```powershell
$sourceFolder = "C:\ProgramData\winlogbeat\opforge-export"
$tempOutput = "C:\Temp\opforge-winlogbeat-cleaned.json"
$sofElkUser = "elk_user"
$sofElkHost = "192.168.77.40"
$sofElkDest = "/logstash/kape/"
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$finalFile = "opforge-winlogbeat-$timestamp.json"

Get-ChildItem -Path $sourceFolder -Filter "winlogbeat.json-*.ndjson" | ForEach-Object {
    Get-Content $_.FullName | ForEach-Object {
        try {
            $event = $_ | ConvertFrom-Json

            if ($event.event.code -eq 4624) {
                $event | Add-Member -MemberType NoteProperty -Name mitre_technique_id -Value "T1078"
            }

            $event | ConvertTo-Json -Depth 10 -Compress
        } catch {}
    } | Out-File -Encoding utf8 -Append -FilePath $tempOutput
}

& "C:\Program Files\PuTTY\pscp.exe" -i "C:\Users\Administrator\Documents\id_rsa.ppk" $tempOutput "${sofElkUser}@${sofElkHost}:${sofElkDest}${finalFile}"

# Clean up
Remove-Item -Path $tempOutput -Force
```

Run it:
```powershell
C:\Scripts\Export-WinlogbeatToSOFELK.ps1
```

### 🔍 Check
On SOF-ELK:
```bash
ls /logstash/kape/opforge-winlogbeat-*.json
```
Then tail `/var/log/logstash/logstash-plain.log` and watch for ingestion activity.

---

## 🧠 Notes
- Logs are enriched with MITRE mapping (4624 → T1078)
- Export can be cron’d or scheduled
- Logs land in `kape` pipeline but are standalone JSON

---

Next step: configure Kibana index pattern + Data View to visualize ingest. → `/docs/kibana-setup/`
