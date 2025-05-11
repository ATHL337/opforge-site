
---
title: "Kibana Data View Setup"
date: 2025-05-10T21:15:00-05:00
draft: false
summary: "This guide walks through setting up a custom Kibana data view for visualizing Winlogbeat and Sysmon data in OPFORGE."
tags: ["kibana", "elk stack", "visualization", "winlogbeat", "sysmon"]
---

# Kibana Data View Setup

Kibana is your visualization front-end for the Elasticsearch data collected by SOF-ELK. This guide walks through setting up a custom data view to track and analyze logs from Winlogbeat and Sysmon.

---

## ✅ Check

- Ensure SOF-ELK is accessible via `http://opf-log01:5601`
- Confirm that Winlogbeat logs have been ingested (use Dev Tools > `_cat/indices?v`)
- Verify the expected index patterns are present (e.g., `winlogbeat-*`)

---

## ⚙️ Do

1. **Login to Kibana**  
   Navigate to `http://opf-log01:5601` and click on “Kibana” > “Stack Management”.

2. **Create Data View**  
   - Go to **“Stack Management” > “Data Views”**
   - Click **“Create Data View”**
   - Name: `Winlogbeat Logs`
   - Index pattern: `winlogbeat-*`
   - Select a timestamp field: `@timestamp`

3. **Save & Explore**  
   - Save the data view.
   - Navigate to **Discover** and ensure logs populate correctly.

4. *(Optional)*: Repeat for `sysmon-*` or other sources

---

## 🔍 Check

- Use “Discover” to verify the logs load with proper fields (event.code, host.name, etc.)
- Confirm time filters allow viewing over various periods
- Consider creating saved searches or dashboards for future correlation

---

> 🧠 Tip: Bookmark this data view to quickly pivot into detection engineering or triage use cases.
