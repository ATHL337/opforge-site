
---
title: "OPFORGE Rebrand Checklist for Mimikatz"
date: 2025-05-31
draft: false
tags: ["threat emulation", "detection engineering", "mimikatz", "rebrand", "xai"]
---

# OPFORGE Rebrand Checklist for Mimikatz

_This step-by-step guide simplifies the process of rebranding Mimikatz under the OPFORGE project. Use it to create a portfolio-grade build aligned with Threat Emulation, Detection Engineering, and Explainable AI objectives._

**Maintainer**: Alfredo Pelaez  
**Date**: 2025-05-31  
**Project Alignment**: [OPFORGE](https://opforge.dev) | High-Yield Performance & Results (H.Y.P.R.) Mindset

---

## ✅ Phase 1: Clone and Prepare the Repo

1. [ ] Clone the Mimikatz repository:
   ```bash
   git clone --recursive https://github.com/gentilkiwi/mimikatz.git Tools/mimikatz
   ```

2. [ ] Create a backup copy:
   ```bash
   cp -r Tools/mimikatz Tools/mimikatz-original
   ```

3. [ ] Prepare script path and workspace:
   ```powershell
   New-Item -Path "C:\OPFORGE\Scripts" -ItemType Directory -Force
   ```

---

## ✅ Phase 2: Automated Rebranding via PowerShell

1. [ ] Run the global text replacement:
   ```powershell
   $root = "C:\OPFORGE\Tools\mimikatz"
   Get-ChildItem -Path $root -Recurse -File | ForEach-Object {
       (Get-Content $_.FullName) `
           -replace "mimikatz", "opforge" `
           -replace "Mimikatz", "OPFORGE" `
           -replace "MIMIKATZ", "OPFORGE" `
           -replace "gentilkiwi", "opforge" `
           -replace "Benjamin", "Alfredo" `
           -replace "Delpy", "Pelaez" `
           -replace "benjamin@gentilkiwi.com", "alfredo@opforge.dev" `
           | Set-Content $_.FullName
   }
   ```

2. [ ] Rename key project files/folders:
   ```powershell
   Rename-Item "$root\mimikatz.sln" "opforge.sln"
   Rename-Item "$root\mimikatz" "opforge"
   ```

3. [ ] Patch the solution file:
   ```powershell
   (Get-Content "$root\opforge.sln") `
       -replace "mimikatz.vcxproj", "opforge.vcxproj" `
       | Set-Content "$root\opforge.sln"
   ```

---

## ✅ Phase 3: Branding Customization

1. [ ] Update terminal banner in `opforge.c`:
   ```c
   kprintf(L"\n  OPFORGE Toolkit v1.0 | Threat Emulation | Detection Engineering | XAI\n");
   kprintf(L"  H.Y.P.R. Mindset | https://opforge.dev | Maintainer: Alfredo Pelaez\n\n");
   ```

2. [ ] Modify the shell prompt:
   ```c
   kprintf(L"\nopforge # ");
   ```

3. [ ] Optionally update:
   - Version macros
   - `about` module text
   - License headers

---

## ✅ Phase 4: Build and Debug

1. [ ] Open the solution in **Visual Studio 2022**.

2. [ ] Retarget the solution:
   - Right-click the solution → **Retarget Projects** → Select your installed toolset

3. [ ] Set the startup project to `opforge`, build for `x64 | Release`.

4. [ ] Troubleshoot build errors:
   - Resolve missing exports like `kdbg_mimikatz`
   - Patch unresolved symbols
   - Update the `.def` file to match your rebranded entry points

---

## ✅ Phase 5: Validation and Use

1. [ ] Run the final binary:
   ```powershell
   .\x64\opforge.exe
   ```

2. [ ] Confirm output:
   - ASCII art and terminal header are updated
   - Interactive prompt shows `opforge #`
   - All commands execute without errors

3. [ ] Version control:
   ```bash
   git add .
   git commit -m "Apply OPFORGE rebranding to Mimikatz base"
   git push origin opforge-main
   ```

---

## 🧠 Future Improvements

- [ ] Rename command strings via macro (`L"sekurlsa"` → `OPF_SEKURLSA`) and refactor source
- [ ] Customize internal module help text
- [ ] Build `.msi` or `.zip` for OPFORGE deployment
- [ ] Integrate telemetry or logging for operator feedback (in lab only)

---

**End of Checklist**  
_This post is part of the [OPFORGE](https://opforge.dev) project series on Threat Emulation and AI-Enhanced Detection Engineering._
