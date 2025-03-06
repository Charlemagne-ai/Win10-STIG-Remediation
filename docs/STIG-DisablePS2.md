# Disable Windows PowerShell 2.0
**STIG ID**: WN10-00-000155

---

## 1. Problem Statement / Vulnerability

### Issue
- **Windows PowerShell 2.0** is an older version of PowerShell that lacks modern security enhancements and detailed logging.
- Attackers can attempt to **downgrade** scripts to PS 2.0 to avoid advanced script block logging in later versions.

### Risk
- Leaving PowerShell 2.0 enabled creates a gap in audit trails and potentially allows attackers to run malicious code in a more stealthy fashion.

---

## 2. Baseline (Initial State)

**Before** remediation: WN10-00-000155 Failed Nessus/STIG scan
![02-WN10-00-000155](https://github.com/user-attachments/assets/46712e0f-c6be-4ab2-a7fb-4437a7152833)

Figure 1. “Disable PowerShell 2.0” was not set properly.

![PS2](https://github.com/user-attachments/assets/c56bfc48-ccfa-46ec-918b-b9a9b1e958de)

## 3. Remediation Steps

### A. Manual Remediation (GUI / OptionalFeatures.exe)

1. **Open Windows Features**  
   - Press **Win + R**, type `OptionalFeatures.exe`, and press **Enter**.  
   - Scroll to **“Windows PowerShell 2.0”**, uncheck it if present, then click **OK**.

2. **(Alternative) Turn Windows features on or off**  
   - Launch **Control Panel → Programs → Turn Windows features on or off**.  
   - Locate **Windows PowerShell 2.0** (sometimes shown as “Windows PowerShell 2.0 Engine”).  
   - Uncheck it, then **OK**.  
   - Let Windows apply changes; a reboot may be prompted or recommended.

### B. Automated Remediation (PowerShell Script)

See [`scripts/Disable-PowerShell2.ps1`](../scripts/Disable-PowerShell2.ps1).

![PS2-Script](https://github.com/user-attachments/assets/9503630a-2d34-425e-bd3d-47d9558bc657)

## 4. Testing / Verification

1. **Check DISM / Features for disabled state**  
  ![PS2-Check](https://github.com/user-attachments/assets/f0a17e2a-5927-4e01-afc0-f3ae10833c73)


2. **Nessus / STIG Scan Pass**  
  ![02-WN10-00-000155- PASS](https://github.com/user-attachments/assets/04fa5d43-43c4-4a2c-a346-4ceb653789e5)

---

## 5. Rollback Instructions

If you need to **re-enable** PowerShell 2.0 (not recommended in production):

1. **Windows Features**  
   - Re-check **PowerShell 2.0** in **“Turn Windows features on or off.”**

2. **PowerShell** (command):
   ```powershell
   Enable-WindowsOptionalFeature -Online -FeatureName "MicrosoftWindowsPowerShellV2Root"
   ```

A reboot may be required to restore all components.

---

## 6. Final Results

- By removing the legacy PowerShell 2.0 engine, you minimize the risk of attackers bypassing advanced logging and script protections in modern PowerShell versions.
- This satisfies **WN10-00-000155** per DISA Windows 10 STIG v3r2.
- Your Nessus or STIG Viewer scan should now show this control as **Passed**.

---
