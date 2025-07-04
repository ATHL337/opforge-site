---

title: "Post 9: TRAM Deployment and First Report Upload" 
date: 2025-07-04T04:05:00-05:00 
tags: ["opforge", "tram", "ai", "ml", "django", "deployment"] 
categories: ["ai_pipeline", "mlops", "future_lab"] 
related_cert: ["CISSP", "OSCP", "GCFA", "GCFR", "GREM", "GXPN"] 
tooling: ["tram", "django", "python", "ubuntu", "ufw"] 
artifact_type: ["lab_log", "deployment_note"]

---

> "In theory there is no difference between theory and practice. In practice, there is." — Yogi Berra

# 🎉 TRAM Deployment and First Report Upload

This post documents the successful standalone deployment of [TRAM](https://github.com/center-for-threat-informed-defense/tram) (Threat Report ATT&CK Mapper) on an isolated OPFORGE host, culminating in our first working ML-assisted ATT&CK report ingestion.

---

## 📌 Abstract

**Problem:** TRAM relies on Django, Python 3.10+, and a consistent static file pipeline. Errors during install (missing encodings, `STATICFILES_DIRS`, etc.) and UFW blocked access to the web UI.

**Approach:** We corrected environment inconsistencies, resolved package issues from partial installs, updated `STATICFILES_DIRS`, opened port 8000 via UFW, and adjusted `ALLOWED_HOSTS` for LAN access.

**Alignment:** This stage integrates Red/Blue-aligned AI/ML practices into OPFORGE. It supports automation, detection validation, and alignment with AI-focused courses and certs (GCFR, GREM, GXPN).

**Outcome:** TRAM is now accessible at `192.168.1.28:8000` and capable of ingesting reports (tested with `iranian-cyberattacks-2025.pdf`).

---

## 📆 Environment Snapshot

- Host: `opf-srv-cti01`
- OS: Ubuntu 24.04
- Python: 3.10 via system packages
- Virtualenv: `tramenv` in `~/tram/`
- TRAM source: cloned into `~/tram/src/tram/`
- Data path: `~/tram/data/`
- Static root: `~/tram/staticfiles/`

---

## 📅 Key Fixes

### 🔧 Python & Django

```bash
sudo apt install python3.10 python3.10-venv python3.10-dev
python3.10 -m venv tramenv
source tramenv/bin/activate
pip install -r requirements.txt
```

### 🛁 `settings.py` Fix

```python
STATIC_URL = "/static/"
STATICFILES_DIRS = [os.path.join(BASE_DIR, "static")]
STATIC_ROOT = os.path.join(PROJECT_ROOT, "staticfiles")
ALLOWED_HOSTS = ["localhost", "127.0.0.1", "192.168.1.28"]
```

### 🚪 UFW Access

```bash
sudo ufw allow 8000/tcp
sudo ufw enable
```

### 🚧 Static Files

```bash
python src/tram/manage.py collectstatic --noinput
```

> Avoid `src/tram/src/tram/static` references. Ensure you're pointing to the `~/tram/static/` source if that's where your CSS/JS/images live.

### 🚀 Launch

```bash
export PYTHONPATH=./src
export DJANGO_SETTINGS_MODULE=tram.settings
python src/tram/manage.py runserver 0.0.0.0:8000
```

---

## 🛎️ First Upload

The `Upload Report` button now works, allowing ingestion of a test PDF:

- **Filename:** `iranian-cyberattacks-2025.pdf`
- **Status:** Queued, then processed
- **Mapped Sentences:** Visible in the TRAM UI



---

## 🎓 Lessons Learned

- `ALLOWED_HOSTS` is mandatory when `DEBUG=False`, but even when `True` Django enforces valid `Host` headers
- UFW must be explicitly enabled, not just allowed
- Avoid path layering: multiple nested `src/tram/src/tram` can cause static lookup to fail
- `STATICFILES_DIRS` must match where your source JS/CSS/images actually are

---

## 🔢 Next Steps

-

The lab now supports ML-based ingestion of real-world reports. Every sentence can be evaluated, trained, and crosswalked to ATT&CK. TRAM is operational.

- H.Y.P.R.

