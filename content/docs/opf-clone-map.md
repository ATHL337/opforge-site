# OPFORGE VM Clone Map

| Template                   | Clone Name     | Purpose                         |
|----------------------------|----------------|---------------------------------|
| base-ubuntu-2204-template  | opf-red01      | Red Team operator box          |
| base-ubuntu-2204-template  | opf-log01      | Log pipeline (Zeek, OpenSearch)|
| base-ubuntu-2204-template  | opf-ai01       | Jupyter + anomaly detection    |
| base-ubuntu-2204-template  | opf-cloud01    | Targeted web app for attack    |
| base-windows10-template    | opf-mbr01      | Domain-joined endpoint         |

## Notes
- All clones renamed post-creation
- Hostname, IP, and NICs customized per segment
- Clones are snapshot-friendly and scriptable
