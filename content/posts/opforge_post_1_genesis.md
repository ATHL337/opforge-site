---
title: "Post 1: Genesis of OPFORGE" 
date: 2025-06-16T08:00:00-05:00 
read_time: 5 
technical_difficulty: "Beginner" 
tags: ["opforge", "lab_setup", "vmware", "planning"] 
categories: ["infrastructure", "foundations"] 
related_cert: ["CISSP", "OSCP"] 
tooling: ["vmware"] 
artifact_type: ["project_kickoff", "lab_log"]
---

> "First say to yourself what you would be; and then do what you have to do." — Epictetus

# 🚀 Genesis of OPFORGE

The launch of OPFORGE marks the deliberate beginning of a long-range effort to build a portfolio-driven, enterprise-grade cyber operations lab. This post documents the rationale, guiding principles, and initial actions to set up the OPFORGE lab environment using VMware Workstation Pro.

---

## 📌 Abstract

**Problem Statement:** Many cyber professionals lack a personalized, practical testbed to validate tools, emulate adversaries, and showcase capabilities. OPFORGE fills that gap through structured lab design.

**Methodology:** This phase established foundational infrastructure: created core VM folders, downloaded initial VM images, and structured network segmentation to support growth.

**Certifications & Academic Link:** This project supports CISSP (security architecture), OSCP (hands-on exploitation testbed), and forms the environment for future GCFA/GCFR forensics testing.

**Expected Outcomes:** Establish base VM structure, logical folder organization, and prepare for segmentation and routing in follow-on phases.

---

## 📚 Prerequisites

- VMware Workstation Pro (or equivalent hypervisor)
- Host system with at least 64GB RAM and 1TB storage
- Basic familiarity with virtual machine deployment
- Target VMs downloaded: Windows 10, Kali Linux, pfSense, Ubuntu Server

---

## ✅ Tasks This Phase

- Define OPFORGE project structure: `E:/OPFORGE/VMs/` with subfolders by role
- Download and validate OS images from trusted sources
- Deploy base VMs:
  - `opf-mbr01` (Windows endpoint)
  - `opf-blue01` (SIFT workstation)
  - `opf-red01` (Kali Linux)
  - `opf-fw-dmz` (pfSense firewall)
  - `opf-dc01` (Domain Controller)
- Plan logical subnets for future segmentation
- Design base lab network using VMware custom VMnets

---

## 🔧 Configuration Highlights

### VM Folder Structure

```text
E:/OPFORGE/VMs/
├── Endpoints/
│   ├── OPF-MBR01
│   └── OPF-BLUE01
├── Infrastructure/
│   ├── OPF-DC01
│   └── OPF-FW-DMZ
├── Attack/
│   └── OPF-RED01
```

### VM Network Plan (Initial Draft)

| VM         | Role            | IP Range        | VMnet Assigned |
| ---------- | --------------- | --------------- | -------------- |
| OPF-MBR01  | Workstation     | 192.168.60.0/24 | VMnet6         |
| OPF-BLUE01 | Blue Team Tools | 192.168.60.0/24 | VMnet6         |
| OPF-RED01  | Attack Platform | 192.168.10.0/24 | VMnet2         |
| OPF-FW-DMZ | Firewall        | Multi-Zone      | VMnet4, VMnet5 |
| OPF-DC01   | Domain Services | 192.168.30.0/24 | VMnet3         |

---

## 🌟 Key Takeaways

- A clear file and folder structure supports long-term lab sustainability
- Early VM deployment sets the stage for future segmentation and attack simulation
- Planning subnets early simplifies routing and firewall implementation later

---

## 🧭 On Deck

- Implement routing via VyOS to enable inter-subnet communication
- Configure pfSense interfaces and NAT rules
- Begin testing DNS and AD join for `opf-mbr01`

From the first VM clone to the final lateral movement, OPFORGE begins with purpose.

- H.Y.P.R.

