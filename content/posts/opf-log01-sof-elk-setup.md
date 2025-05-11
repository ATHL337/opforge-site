---
title: "Ingest to Analyze: Bringing SOF-ELK Online"
date: 2025-05-07T10:00:00-05:00
draft: false
tags: ["elk stack", "sof-elk", "logstash", "kibana", "linux"]
summary: "This post walks through the deployment and configuration of `opf-log01`, the centralized logging VM for OPFORGE, powered by SOF-ELK. From network setup to confirming ELK stack services, this guide ensures a solid foundation for ingesting security-relevant data."
---

## ✅ Check

- Define static IP (e.g., 192.168.77.40/24)
- Verify existing DNS settings on `opf-dc01` for proper resolution
- Confirm latest Ubuntu-based version of SOF-ELK is available
- Snapshot VM prior to major config changes

## ⚙️ Do

1. Deploy SOF-ELK using the latest Ubuntu-based VM image
2. Configure netplan:

```yaml
network:
  version: 2
  ethernets:
    ens33:
      dhcp4: no
      addresses:
        - 192.168.77.40/24
      gateway4: 192.168.77.1
      nameservers:
        addresses:
          - 192.168.77.10
```

3. Apply config:

```bash
sudo netplan apply
```

4. Confirm services are running:

```bash
sudo systemctl status logstash
sudo systemctl status elasticsearch
sudo systemctl status kibana
```

## 🔍 Check

- Kibana loads at `http://opf-log01:5601`
- Logstash logs show listeners on key ports (5044, 5514)
- Elasticsearch responds at `localhost:9200`
