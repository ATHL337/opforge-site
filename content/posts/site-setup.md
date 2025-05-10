---
title: "Building the OPFORGE Website"
date: 2025-05-10
tags: ["opforge", "hugo", "github-pages", "devlog"]
categories: ["Project Log"]
draft: false
---

This post documents the process of building the official website for **OPFORGE**, a cybersecurity lab project focused on detection engineering, threat emulation, and explainable AI.

## 🔧 Tooling Stack

- **Hugo** – Static site generator (v0.147.1)
- **PaperMod** – Lightweight, responsive Hugo theme
- **GitHub Pages** – CI/CD-backed static hosting
- **Cloudflare DNS** – Domain and HTTPS management
- **Custom Domain** – `https://opforge.dev`

## 🧱 Build Process

1. Created site:
```bash
   hugo new site opforge-site --format yaml
```

2. Installed theme:

```bash 
git submodule add https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
```

3. Configured `hugo.yaml` with menus, theme, and metadata

4. Created first post and tested site locally:
```bash 
hugo server
```

5. Set up GitHub Actions for CI/CD:
- peaceiris/actions-hugo@v2 for building
- peaceiris/actions-gh-pages@v3 for deployment

6. Set baseURL for GitHub Pages:
```yaml 
baseURL: "https://ATHL337.github.io/opforge-site/"
```
7. Set GitHub Pages source branch to gh-pages in repository settings

8. Updated DNS via Cloudflare:
- A records for root domain pointing to GitHub Pages IPs
- CNAME for www pointing to ATHL337.github.io
- HTTPS enforced

## 🌐 Outcome
With minimal effort and a clean Hugo theme, the OPFORGE site is:
- Easy to write and publish to
- Fully version-controlled
- Built for scaling into documentation, blog posts, and operator guides

## 🧠 Lessons Learned
- Always configure baseURL properly for Hugo builds
- Don’t push the `public/` directory—let CI/CD handle it
- GitHub Actions + Hugo + Cloudflare = elegant, scalable, and secure

More blog posts coming soon on the build-out of the lab, including SOF-ELK setup, Winlogbeat JSON export, and ingestion pipelines.
