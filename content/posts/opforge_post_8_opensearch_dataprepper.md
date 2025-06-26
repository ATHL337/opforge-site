---
title: "Post 8: Migrating to OpenSearch with Data Prepper for Log Ingestion"
date: 2025-06-26T22:00:00Z
tags: ["opforge", "OpenSearch", "Data Prepper", "log_ingestion", "SIEM"]
categories: ["log_ingestion", "detection_stack", "future_lab"]
related_cert: ["CISSP", "OSCP", "GCFA", "GCFR", "GREM", "GXPN", "GPYC"]
tooling: ["opensearch", "data-prepper", "docker"]
artifact_type: ["lab_log", "integration_note"]
---

> "In the middle of every difficulty lies opportunity." — Albert Einstein

# 🧠 Migrating to OpenSearch with Data Prepper for Log Ingestion

This post chronicles the replacement of Filebeat OSS with OpenSearch Data Prepper in the segmented OPFORGE lab. It captures troubleshooting, configuration, and validation processes that highlight modern, modular ingestion practices suited for a realistic Blue Team SIEM environment.

---

## 📌 Abstract

**Problem:** Filebeat OSS 7.12.x caused ingestion failures with OpenSearch 2.13.0 due to unsupported `_type` metadata in bulk events.

**Approach:** Replace Filebeat with OpenSearch Data Prepper and rewire ingestion pipelines using declarative YAML configs and mounted volumes.

**Alignment:** Aligns with GCFA and GCFR (forensic ingestion), GPYC (log analysis), and GREM (log-based malware traces). Also relevant for CISSP/OSCP foundations on secure system design and detection control validation.

**Outcome:** Successful ingestion into `log-pipeline-*` indices using Data Prepper, enabling log parsing and future ML-driven detection correlation.

---

## 📚 Prerequisites

- OpenSearch 2.13.0 running in Docker Compose
- Basic Linux + Docker knowledge
- Segmented OPFORGE lab with `opf-log01` node
- Prior failed attempts to use Filebeat OSS

---

## ✅ Tasks This Phase

- Remove legacy Filebeat configuration
- Create Data Prepper pipeline and config files
- Mount them into container via `docker-compose.yml`
- Generate test logs and verify end-to-end ingestion

---

## 🔧 Configuration Summary

### 🧹 Purge Filebeat

```bash
# Stop services
cd ~/Logstack
docker compose down

# Clean up legacy beats
rm -rf filebeat.yml logs/ /usr/share/filebeat
```

> 📸 *Screenshot: Filebeat logs with `_type` rejection error*

---

### 🧬 Data Prepper Pipeline (pipelines/log-pipeline.yaml)

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

---

### ⚙️ Data Prepper Config (data-prepper-config.yaml)

```yaml
ssl: false
log-pipeline-default-target: stdout
```

> 📸 *Screenshot: data-prepper config directory with pipeline and logs mount visible*

---

### 🐳 Compose Add-on (docker-compose.yml snippet)

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

---

### 🧪 Test Log Injection

```bash
mkdir -p logs
echo "🚀 Hello OPFORGE from Data Prepper - $(date)" >> logs/test.log
```

> 📸 *Screenshot: OPFORGE message in test.log*

---

### 🔍 Validate Index Creation

```bash
curl -u admin:AdminAdminqwer123! -k \
  "https://localhost:9200/log-pipeline-*/_search?q=message:OPFORGE&pretty"
```

If empty:

```bash
docker logs -f data-prepper
```

> 📸 *Screenshot: successful `log-pipeline-*` index in `_cat/indices`*

---

## 🚨 Troubleshooting: Disk Space & Permissions

```bash
df -h
sudo du -sh /* 2>/dev/null | sort -hr | head -n 15
sudo journalctl --vacuum-time=2d
sudo apt clean
sudo docker system prune -a
```

> 📸 *Screenshot: flood watermark warning from OpenSearch logs*

---

## 🌟 Key Takeaways

- Filebeat OSS is no longer viable for OpenSearch 2.13.x due to `_type` incompatibility
- Data Prepper offers a drop-in file source pipeline with better error visibility
- This lays the groundwork for parsing, enrichment, and ECS normalization

---

## 🧭 On Deck

- Add Sysmon + Zeek logs into the Data Prepper stream
- Use Jupyter to correlate detections with OPFORGE Red Team triggers
- Replace raw logs with parsed ECS format for dashboards

OPFORGE's detection fabric is now ingesting structured logs—ready for enrichment, analytics, and red-vs-blue scenarios.

—H.Y.P.R.
