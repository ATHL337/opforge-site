---
title: "Kibana Data View Setup"
date: 2025-05-10T21:15:00-05:00
draft: false
tags: ["kibana", "data view", "sof-elk", "log visualization"]
summary: "Set up a Kibana data view in SOF-ELK to visualize Winlogbeat event data and enable efficient threat hunting in OPFORGE."
---

In this post, we configure a **Kibana Data View** within SOF-ELK to start visualizing log data from `opf-mbr01`. This step is critical for enabling dashboards, visualizations, and practical triage in OPFORGE.

## ✅ Check

- Confirm Winlogbeat JSON files are arriving on `opf-log01`
- Logstash is processing input without parse errors
- Events such as 4624 and 4688 appear in the `winlogbeat-*` index
- Kibana is reachable at `http://opf-log01:5601`

## ⚙️ Do

1. Navigate to **Kibana → Stack Management → Data Views**
2. Click **Create Data View**
3. Use the following configuration:

   - **Data view name:** `winlogbeat-*`
   - **Time field:** `@timestamp`

4. Save and confirm the new data view.
5. Navigate to **Discover** and ensure events populate in timeline view.

## 🔍 Check

- Search for `event.code:4624` and confirm results
- Validate timeline accuracy using filters like `host.name`, `user.name`
- Save the view for future use in dashboards or alerts
- Tag the saved object as `opforge` in Kibana for organization

> **Tip:** You can also explore creating dashboards for high-fidelity events like `1102` (Log Clear) or `4688` (Process Creation).

