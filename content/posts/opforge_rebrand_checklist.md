\
# OPFORGE Rebrand Checklist for Mimikatz

_This step-by-step guide is intended to simplify rebranding future versions of Mimikatz under the OPFORGE project. Follow each stage to apply consistent changes and branding._

**Maintainer**: Alfredo Pelaez  
**Date**: 2025-05-31  
**Purpose**: Threat Emulation, Detection Engineering, and XAI Alignment

---

## ✅ Phase 1: Clone and Prepare

1. [ ] Clone the Mimikatz repository:
   ```bash
   git clone --recursive https://github.com/gentilkiwi/mimikatz.git tools/mimikatz
   ```

2. [ ] Create a backup or staging copy (optional but recommended):
   ```bash
   cp -r tools/mimikatz tools/mimikatz-original
   ```

3. [ ] Launch PowerShell and prepare your script path (e.g., `C:\OPFORGE\Scripts\rebrand.ps1`).

---

## ✅ Phase 2: Automated Rebranding via PowerShell

1. [ ] Replace all text references in files:
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

2. [ ] Rename project files and folders:
   ```powershell
   Rename-Item "$root\mimikatz" "opforge" -Force
   ```

3. [ ] Update the `.sln` file:
   ```powershell
   $slnPath = "$root\opforge.sln"
   (Get-Content $slnPath) `
       -replace "mimikatz.vcxproj", "opforge.vcxproj" `
       | Set-Content $slnPath
   ```

---

## ✅ Phase 3: Branding Customization

1. [ ] Edit `opforge.c` to update the ASCII art and terminal banner:
   - Insert colored or plain text banner:
     ```c
     kprintf(L"OPFORGE Toolkit v1.0 | Threat Emulation | Detection Engineering | XAI");
     kprintf(L"H.Y.P.R. Mindset | https://opforge.dev | Maintainer: Alfredo Pelaez");
     ```

2. [ ] Change the interactive prompt string:
   ```c
   kprintf(L"\nopforge # ");
   ```

3. [ ] Optionally update version macros, license info, and copyright.

---

## ✅ Phase 4: Build and Debug

1. [ ] Open the solution in Visual Studio.

2. [ ] Retarget the solution to your installed toolset (if needed):
   - Right-click solution → Retarget Projects

3. [ ] Set `opforge` as the startup project and build for `x64 → Release`.

4. [ ] Troubleshoot:
   - Fix missing symbols like `kdbg_mimikatz`
   - Add missing implementation stubs or rename the `.def` file entries

---

## ✅ Phase 5: Validate

1. [ ] Run the binary:
   ```bash
   .\x64\opforge.exe
   ```

2. [ ] Confirm:
   - ASCII art and header show properly
   - Shell prompt reads `opforge #`
   - Features work without crash

3. [ ] Push changes to GitHub (if appropriate):
   ```bash
   git add .
   git commit -m "Apply OPFORGE rebrand to mimikatz base"
   git push origin opforge-main
   ```

---

**End of Checklist**  
Document maintained under [opforge.dev](https://opforge.dev)
