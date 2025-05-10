---
title: "SOF-ELK Setup & Ingestion"
date: 2025-05-10
draft: false
---

## 🔍 Purpose
Deploy and configure the SOF-ELK stack for ingestion of structured JSON logs from Winlogbeat and other sources inside the OPFORGE lab.

---

## ✅ Prerequisites

- VMware Workstation Pro VM: `OPF-LOG01`
- Latest SOF-ELK Ubuntu-based image deployed
- Static IP assignment (e.g., `192.168.77.40`)
- Inbound SSH/SCP and port 5044 (Beats input) allowed
- JSON-formatted Winlogbeat files structured for ingest

---

## 🔧 Check–Do–Check Workflow

### 🔍 Check
- Confirm network interface and IP:
  ```bash
  ip a
  ip route
  ping -c 3 8.8.8.8
  ```
- Confirm Logstash is running:
  ```bash
  sudo systemctl status logstash
  ```

---

### ✅ Do

#### 1. Assign Static IP with Netplan
File: `/etc/netplan/01-netcfg.yaml`
```yaml
network:
  version: 2
  ethernets:
    ens33:
      addresses:
        - 192.168.77.40/24
      nameservers:
        addresses: [1.1.1.1, 8.8.8.8]
      routes:
        - to: default
          via: 192.168.77.1
```
Apply it:
```bash
sudo netplan apply
```

#### 2. Ensure `/logstash/kape/` exists and is writable
```bash
sudo mkdir -p /logstash/kape
sudo chown elk_user:elk_user /logstash/kape
```

#### 3. Verify SOF-ELK Beats Listener
```bash
grep 5044 /etc/logstash/conf.d/*
```
If not active:
```bash
echo "input { beats { port => 5044 } } output { stdout { codec => rubydebug } }" | sudo tee /etc/logstash/conf.d/test-beats.conf
```
Restart Logstash:
```bash
sudo systemctl restart logstash
```

#### 4. Ingest a Test File
```bash
scp test.json elk_user@192.168.77.40:/logstash/kape/
```
Tail the Logstash log:
```bash
sudo tail -f /var/log/logstash/logstash-plain.log
```

---

### 🔍 Check
- Verify document count in Elasticsearch:
  ```bash
  curl -XGET 'localhost:9200/_cat/indices?v'
  ```
- Check Kibana at `http://192.168.77.40`
  - Navigate to **Stack Management → Data Views**
  - Create a new index pattern for `winlogbeat-*`

---

## 🧠 Notes
- SOF-ELK includes prebuilt parsers but may require tuning
- Custom `.conf` files can be added to `/etc/logstash/conf.d/`
- Use `/tmp/*.json` outputs during troubleshooting

---
Next step: visualize logs with Kibana → `/docs/kibana-setup/
