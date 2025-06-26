---
title: "Migrating to OpenSearch with Data Prepper for Log Ingestion"
date: 2025-06-26T22:00:00Z
description: "Replacing Filebeat with OpenSearch Data Prepper in a segmented OPFORGE lab."
tags: ["OPFORGE", "OpenSearch", "Data Prepper", "Log Ingestion", "SIEM"]
author: "Alfredo Pelaez"
categories: ["Infrastructure", "Detection Engineering", "SIEM"]
draft: false
---

## Overview

This post documents the transition from using Filebeat to [OpenSearch Data Prepper](https://opensearch.org/docs/latest/data-prepper/) as a log ingestion mechanism in the OPFORGE lab. It covers incompatibilities with Filebeat OSS 7.12.x, issues faced during ingestion to OpenSearch 2.13.0, and a successful reconfiguration using Data Prepper. The environment is a segmented network with distinct routing layers simulating enterprise conditions.

## Motivation

While Filebeat OSS 7.12.x is [the last supported version](https://opensearch.org/docs/latest/tools/compatibility/) compatible with OpenSearch 2.x, its ingestion failed due to deprecated `_type` metadata fields:

```plaintext
failed to publish events: 400 Bad Request: {"error":{"root_cause":[{"type":"illegal_argument_exception","reason":"Action/metadata line [1] contains an unknown parameter [_type]"}]}}
```

Attempts to override this behavior using index templates and suppress the `_type` field were unsuccessful, and Filebeat container logs confirmed repeat failures. The decision was made to migrate to Data Prepper.

## Step 1: Purging Legacy Components

```bash
# Stop services
cd ~/Logstack
sudo docker compose down

# Remove Filebeat and old log directories
sudo rm -rf filebeat.yml logs/ /usr/share/filebeat
```

> 📸 *Screenshot: Filebeat failing with **`_type`** error in logs (insert image)*

## Step 2: Add Data Prepper Configuration

### pipelines/log-pipeline.yaml

```yaml
version: "2"
pipeline:
  source:
    file:
      path: "/usr/share/data-prepper/logs/*.log"
      scan_interval: "5s"
      encoding: "utf-8"
      format: "plain_text"
  sink:
    - opensearch:
        hosts: ["https://opensearch:9200"]
        username: "admin"
        password: "AdminAdminqwer123!"
        index: "log-pipeline-%{+yyyy.MM.dd}"
        insecure: true
```

### data-prepper-config.yaml

```yaml
ssl: false
log-pipeline-default-target: stdout
```

> 📸 *Screenshot: Directory structure of **`pipelines/`** and **`data-prepper-config.yaml`** mounted into container*

## Step 3: Modify docker-compose.yml

```yaml
data-prepper:
  image: opensearchproject/data-prepper:2.3.0
  container_name: data-prepper
  volumes:
    - ./pipelines:/usr/share/data-prepper/pipelines
    - ./data-prepper-config.yaml:/usr/share/data-prepper/data-prepper-config.yaml
    - ./logs:/usr/share/data-prepper/logs
  environment:
    - DATA_PREPPER_LOGS_STDOUT=true
  ports:
    - "4900:4900"
    - "21890:21890"
  networks:
    - logstack_net
  depends_on:
    - opensearch
  restart: unless-stopped
```

## Step 4: Trigger a Test Log Event

```bash
mkdir -p logs
echo "🚀 Hello OPFORGE from Data Prepper - $(date)" >> logs/test.log
```

> 📸 *Screenshot: **`logs/test.log`** contents with timestamped message*

## Step 5: Verify Ingestion in OpenSearch

After restarting with:

```bash
docker compose up -d --force-recreate
```

Query OpenSearch:

```bash
curl -u admin:AdminAdminqwer123! -k \
  "https://localhost:9200/log-pipeline-*/_search?q=message:OPFORGE&pretty"
```

If you see 0 hits, check container logs:

```bash
docker logs -f data-prepper
```

Common errors:

- `NoSuchFileException` → logs directory not mounted or empty
- YAML parse error → indentation or syntax issue in `pipeline.yaml`

> 📸 *Screenshot: OpenSearch _cat indices showing **`log-pipeline-*`** index*
> 📸 *Screenshot: Successful ingestion seen in Data Prepper container logs*

## Troubleshooting: Disk Space Issues

OpenSearch threw `Too Many Requests` errors caused by exceeding the flood stage watermark (95% disk usage):

```bash
df -h
sudo du -sh /* 2>/dev/null | sort -hr | head -n 15
```

Cleanup commands:

```bash
sudo journalctl --vacuum-time=2d
sudo apt clean
sudo docker system prune -a
```

## Final Notes

At the time of writing, this approach offers a clean, modular, and compatible ingestion pipeline for OpenSearch 2.13.x. Data Prepper’s declarative syntax and direct support for TLS and file sources makes it a suitable replacement for older Elastic-native Beats agents.

Future efforts will focus on:

- ingesting Sysmon via OTLP
- parsing logs into ECS-compliant fields
- integrating OpenSearch Dashboards visualizations

---

> 🧪 *Next up: Use Jupyter to build explainable detection rules on log-pipeline indices.*

---

👤 **Certifications & Credentials**: This work builds on experience and expertise gained through certifications including **GCFA**, **GCFR**, **CISSP**, **GREM**, and graduate-level coursework in AI/ML as part of **WGU’s MS in Computer Science, AI & ML** program.
