---

title: "From 404 to Flawless: How OPFORGE Finally Deployed"
date: 2025-05-10T22:30:00-05:00
slug: "opforge-finally-deployed"
tags: \["deployment", "hugo", "github-pages", "papermod", "troubleshooting"]
draft: false
------------

# Blog Post: "From 404 to Flawless: How OPFORGE Finally Deployed"

## TL;DR

After wrestling with GitHub Pages, Hugo themes, broken submodules, and outdated Hugo versions, OPFORGE.dev is now live — built with Hugo + PaperMod and deployed through GitHub Actions. Here's how we pulled it off, step-by-step.

---

## 🛠️ Background

**Project:** OPFORGE — a portfolio-driven site documenting the creation of a cyber detection engineering and threat emulation lab.

**Goal:** Use [Hugo](https://gohugo.io/) + [PaperMod](https://github.com/adityatelange/hugo-PaperMod) + GitHub Pages to create a professional and performant static site for hosting blog-style documentation.

---

## 🚧 Problems We Encountered

### 1. **Theme not loading (missing layout warnings)**

* Cause: GitHub Actions couldn't find PaperMod theme files.
* Fix: Removed old submodule config, then re-added PaperMod as a regular folder.

### 2. **Outdated Hugo version**

* Error: `ERROR => hugo v0.146.0 or greater is required for hugo-PaperMod to build`
* Fix: Updated `deploy.yml` to use `hugo-version: '0.147.0'`

### 3. **GitHub Pages rendering XML or 404 errors**

* Cause: Deploying without theme + config, or to wrong branch.
* Fix: Ensured `gh-pages` is the deploy target, and public folder is Git-ignored but built by Actions.

---

## ✅ Working Setup

### Hugo Version

```yaml
with:
  hugo-version: '0.147.0'
  extended: true
```

### GitHub Actions Workflow

```yaml
name: Deploy Hugo site to GitHub Pages

on:
  push:
    branches:
      - main

permissions:
  contents: write

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout source with submodules
        uses: actions/checkout@v4
        with:
          submodules: true

      - name: Setup Hugo (extended)
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: '0.147.0'
          extended: true

      - name: Build Hugo site
        run: hugo --cleanDestinationDir --minify

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
          publish_branch: gh-pages
```

### Other Key Files

* `hugo.yaml`:

```yaml
baseURL: "https://opforge.dev/"
title: "OPFORGE"
theme: ["PaperMod"]
languageCode: "en-us"
```

* `.gitignore` includes:

```
public/
temp-theme/
```

---

## 🧠 Lessons Learned

* Don't fight Git submodules unless you have to — clone themes as regular folders.
* Always check the theme's **minimum required Hugo version**.
* Double-check your Pages config: set the correct branch (`gh-pages`) and verify CNAMEs for custom domains.

---

## 🎉 The Result

Visit the live site at: [https://opforge.dev](https://opforge.dev)

This milestone paves the way for publishing the full OPFORGE series, detailing each component of the detection and emulation lab from infrastructure to AI-driven triage.

Next up: documentation posts go live.
