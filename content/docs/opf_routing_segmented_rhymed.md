---

title: "OPFORGE Routing Plan: Rhymed Segmented Flow" 
date: 2025-06-17 
tags: ["opforge", "routing", "segmentation", "ip-schema", "lab-design"] 
categories: ["infrastructure", "redteam", "blueteam"] 
related_cert: ["OSCP", "GPEN", "GCFA"] 
tooling: ["vyos", "pfsense", "vmware"] 
artifact_type: ["routing_plan", "network_design"]

---

## 🎯 Goal

Enforce logical traffic flow through each security zone in OPFORGE using a clearly segmented and rhymed IP scheme.

```
RED_NET → RTR_RED → RTR_INET → RTR_EXT → FW_DMZ → RTR_INT → INTERNAL_NET
```

---

## 🔐 Subnet Allocation by Zone

| Zone/Link              | Subnet            | Mnemonic          |
| ---------------------- | ----------------- | ----------------- |
| External Internet      | `192.168.1.0/24`  | `1 = Origin`      |
| RED\_NET               | `192.168.10.0/24` | `10 = Tension`    |
| RED ↔ INET Transit     | `192.168.20.0/24` | `20 = Handoff`    |
| INET ↔ EXT Transit     | `192.168.30.0/24` | `30 = Throttle`   |
| EXT ↔ DMZ Transit      | `192.168.40.0/24` | `40 = Border`     |
| DMZ ↔ INTERNAL Transit | `192.168.50.0/24` | `50 = Core Door`  |
| INTERNAL\_NET          | `192.168.60.0/24` | `60 = Fix-it Net` |

---

## 🚦 Expected IP Assignments

| Device        | Interface | IP Address      | Connected To       |
| ------------- | --------- | --------------- | ------------------ |
| `opf-rt-red`  | `eth0`    | 192.168.10.1/24 | RED\_NET           |
| `opf-rt-red`  | `eth1`    | 192.168.20.1/24 | `opf-rt-inet`      |
| `opf-rt-inet` | `eth0`    | 192.168.20.2/24 | `opf-rt-red`       |
| `opf-rt-inet` | `eth1`    | 192.168.30.1/24 | `opf-rt-ext`       |
| `opf-rt-ext`  | `eth0`    | 192.168.30.2/24 | `opf-rt-inet`      |
| `opf-rt-ext`  | `eth1`    | 192.168.40.1/24 | `opf-fw-dmz` (em0) |
| `opf-fw-dmz`  | `em0`     | 192.168.40.2/24 | `opf-rt-ext`       |
| `opf-fw-dmz`  | `em1`     | 192.168.50.1/24 | `opf-rt-int`       |
| `opf-rt-int`  | `eth0`    | 192.168.50.2/24 | `opf-fw-dmz`       |
| `opf-rt-int`  | `eth1`    | 192.168.60.1/24 | INTERNAL\_NET      |

---

## 🧭 Route Propagation (Examples)

### On `opf-rt-red`

```bash
set protocols static route 192.168.60.0/24 next-hop 192.168.20.2
```

### On `opf-rt-inet`

```bash
set protocols static route 192.168.60.0/24 next-hop 192.168.30.2
```

### On `opf-rt-ext`

```bash
set protocols static route 192.168.60.0/24 next-hop 192.168.40.2
```

### On `opf-fw-dmz` (pfSense CLI)

```sh
route add -net 192.168.60.0/24 192.168.50.2
```

To persist:

```sh
echo 'static_routes="internalnet"' >> /etc/rc.conf
echo 'route_internalnet="-net 192.168.60.0/24 192.168.50.2"' >> /etc/rc.conf.local
```

---

## ✅ Benefits of This Design

- **Memorable**: Each subnet aligns with a “rhyme” for mission role
- **Traceable**: Routes are easy to follow and describe
- **Segmented**: Forces all traffic through correct inspection points
- **Scalable**: Easily extend with `70.x`, `80.x`, etc for future zones

Next: ASCII diagram update to visualize this clean segmented flow.

