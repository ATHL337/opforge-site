---
title: "OPF-RED01 Sliver Server Setup"
date: 2025-05-26
draft: false
tags: ["opf-red01", "sliver", "redteam", "c2"]
---

## Sliver Build & Launch

After cloning the Sliver repository and resolving build prerequisites (notably `zip`), the server was compiled successfully using:

```bash
cd /opt/opforge/tools/sliver
make
```

The Sliver server was then launched:

```bash
./sliver-server
```

---

## Screenshot of Successful Launch

![Sliver Server Launch](/images/posts/sliver-server-launch.png)

This confirms the Sliver C2 is operational and ready to receive implants or generate payloads.

---

## Next Steps

- Launch `sliver-client` and test C2 communication
- Generate staged and unstaged payloads
- Begin Red Team activity with Sliver in DMZRED
- Monitor OPF-BLUE01/AI01 for correlated events
