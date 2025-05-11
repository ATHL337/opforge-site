---
title: "Precision Logging: Exporting Winlogbeat Data from OPFORGE"
date: 2025-05-08T11:30:00-05:00
draft: false
tags: ["winlogbeat", "windows logs", "ingestion", "filebeat", "SOF-ELK"]
summary: "We configure Winlogbeat on `opf-mbr01` to export JSON-formatted logs to disk. This allows enriched post-processing before ingesting into SOF-ELK."
---

## ✅ Check

- Winlogbeat service is running
- Security logs present in Event Viewer
- Static export path created (e.g., `C:\ProgramData\winlogbeat\opforge-export\`)
- SOF-ELK reachable via IP (e.g., `192.168.77.40`)

## ⚙️ Do

Modify `winlogbeat.yml`:

```yaml
output.file:
  path: "C:/ProgramData/winlogbeat/opforge-export"
  filename: "winlogbeat.json"
  rotate_every_kb: 10000
  number_of_files: 5
  codec.format:
    string: '%{[message]}'
```

Restart Winlogbeat:

```powershell
Restart-Service winlogbeat
```

## 🔍 Check

- `.ndjson` files appear in the export directory
- Each entry is valid line-separated JSON
- Key events (e.g., 4624, 4688, 1102) are present
