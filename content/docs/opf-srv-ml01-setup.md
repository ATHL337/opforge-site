---
title: "OPF-SRV-ML01 Setup Guide"
description: "AI/ML detection node deployment in the segmented OPFORGE lab — enabling adversarial emulation, anomaly detection, and explainable AI workflows."
weight: 80
draft: false
tags: ["opf-srv-ml01", "opf-blue01", "machine learning", "anomaly detection", "jupyterlab", "pycaret", "mlops", "opensearch"]
categories: ["Lab Guides", "Detection Engineering"]
certifications:
  - "GCFA"
  - "GCFR"
  - "MSCS-AIML"
  - "FOR509"
education:
  - "WGU MSCS-AIML (D794, D795)"
  - "OPFORGE Portfolio Project"
version: "OPFORGE v1.0"
aliases: ["/docs/lab/ml01", "/opf/ml-node"]
---

# OPF-SRV-ML01 Setup Guide
_Last updated: 2025-06-28_

This guide documents the deployment and configuration of `opf-srv-ml01`, the machine learning and detection engineering node in the OPFORGE lab. This node supports AI-based threat detection, anomaly modeling, and visual explainability for Red Team emulation exercises.

---

## 🧠 Purpose

`opf-srv-ml01` enables the OPFORGE lab to:
- Run JupyterLab for ML prototyping
- Ingest structured logs from `opf-srv-log01` or enclave nodes
- Build and test anomaly detection models (e.g. PyCaret, scikit-learn)
- Visualize detection performance, event sequences, and feature importance
- Experiment with XAI techniques (e.g., SHAP, LIME)

---

## 📍 Network Placement

| Parameter     | Value               |
|---------------|---------------------|
| Hostname      | `opf-srv-ml01`      |
| IP Address    | `192.168.60.11`     |
| Subnet        | `192.168.60.0/24`   |
| Gateway       | `192.168.60.1`      |
| DNS           | `192.168.60.5`, `8.8.8.8` |

The VM resides in the `INTERNAL_NET` segment and should be able to reach both enclave nodes and the log collector (`opf-srv-log01`).

---

## 📦 Base Configuration

- OS: Ubuntu 22.04 LTS (base image)
- vCPU: 4 cores
- RAM: 8–16 GB
- Disk: 100+ GB
- NIC: `ens32`, statically assigned via Netplan

Netplan config (`/etc/netplan/00-opforgelab.yaml`):

```yaml
network:
  version: 2
  ethernets:
    ens32:
      addresses:
        - 192.168.60.11/24
      gateway4: 192.168.60.1
      nameservers:
        addresses: [192.168.60.5, 8.8.8.8]
```

---

## 🔐 Firewall and Routing

Add these rules to `opf-fw-dmz`:

| Source             | Destination      | Ports      | Purpose          |
|--------------------|------------------|------------|------------------|
| `INTERNAL_NET`     | `opf-srv-ml01`   | TCP 22     | SSH Access       |
| `INTERNAL_NET`     | `opf-srv-ml01`   | TCP 8888   | JupyterLab       |
| `opf-srv-log01`    | `opf-srv-ml01`   | TCP 9200+  | OpenSearch API   |
| `opf-srv-ml01`     | Internet (443)   | TCP 443    | Package updates  |

---

## ⚙️ Installation Steps

### Step 1: Download and Install Miniforge
```bash
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash Miniforge3-Linux-x86_64.sh -b -p $HOME/miniforge3
source ~/miniforge3/bin/activate
conda init
source ~/.bashrc
```

### Step 2: Create Conda Environment
```bash
conda create -n opforge-ml python=3.10 -y
conda activate opforge-ml
```

### Step 3: Install ML Packages
```bash
pip install jupyterlab pandas numpy scikit-learn pycaret matplotlib seaborn ipywidgets opensearch-py shap lime
```

### Step 4: Launch JupyterLab
```bash
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token='' --NotebookApp.password=''
```

Access via browser:  
`http://192.168.60.11:8888`

---

## 🔭 Future Work

- [ ] Add `opf-srv-ml01` to GitLab CI pipeline for detection-as-code integration
- [ ] Ingest Zeek & Winlogbeat logs for time-series modeling
- [ ] Develop detection notebooks for:
  - Beaconing anomalies
  - Credential theft detection
  - East-West privilege escalation

---

Return to [OPFORGE Lab Index](/docs/lab/) for more setup guides.
