# WN10-00-000145 – Enable Data Execution Prevention (DEP) at least OptOut

## 1. Problem Statement / Vulnerability

### Issue
Attackers are constantly looking for memory-based exploits, such as buffer overflows. **Data Execution Prevention (DEP)** marks memory as non-executable, blocking malicious code from running in those memory segments. 

### Risk
If DEP is not properly configured (e.g., set to “OptIn” or turned off), attackers can exploit memory vulnerabilities in both the OS and applications. By setting DEP to at least **OptOut**, you ensure that all processes are protected except those specifically opted out by the administrator.

---

## 2. Baseline (Initial State)

![ConfigureDep_Before](https://github.com/user-attachments/assets/8fc4a99f-de65-4e02-a2b6-44b549df9a98)

![07-WN10-00-000145](https://github.com/user-attachments/assets/e6b1f9ef-27d6-4d9d-b36c-7d0ef92f757e)

---

## 3. Manual Remediation

### A) PowerShell (Elevated)
1. **Check current DEP setting**:
   ```powershell
   bcdedit /enum '{current}'
   ```
   - If it shows `nx  OptIn`, it’s not meeting the STIG’s **OptOut** (or higher) requirement.

2. **Set DEP to OptOut**:
   ```powershell
   bcdedit /set '{current}' nx OptOut
   ```
3. **Reboot** for changes to apply.

#### Alternate Setting
- **AlwaysOn** is more restrictive than **OptOut**. However, if certain applications do not function properly under AlwaysOn, you may need to revert to OptOut.  

---

### B) System GUI (not always recommended)
1. **Right-Click “This PC”** → **Properties** → **Advanced system settings** → **Performance** → **Settings**  
2. Go to **Data Execution Prevention** tab.  
3. Select **“Turn on DEP for all programs and services except those I select”**.  
4. Click **OK** → Reboot.

> **Note**: Setting it via the GUI does not always override BCDEdit if the OS or environment has special configurations. The bcdedit approach is more direct and ensures the kernel uses the setting from boot.

---

## 4. Automated Remediation

See [`scripts/Set-DEP-OptOut.ps1`](../scripts/Set-DEP-OptOut.ps1).

```powershell
Write-Host \"Setting DEP to 'OptOut'...\"
bcdedit /set '{current}' nx OptOut
Write-Host \"DEP set to OptOut. A reboot is required.\"
```

![DEP-script](https://github.com/user-attachments/assets/a6a5fae8-5d1c-4606-ab9e-a354944cabd8)


**Run as Administrator**, then reboot.

> **Note**:  If an application fails under OptOut, you can add that app to the DEP exclusion list in **System Properties** → **DEP** tab, or set the OS to **AlwaysOn** if your environment can handle the more restrictive setting.

---

## 5. Testing / Verification

1. **Check**:
   ```powershell
   bcdedit /enum | findstr /i "nx"
   ```
   - Should read `nx               OptOut` or possibly `AlwaysOn` if you set it more restrictively.
     ![DEP_After](https://github.com/user-attachments/assets/5e697237-2e0a-4487-995b-35e6e97f373f)

2. **Reboot** if you haven’t already.
3. **Nessus / STIG Scan Pass**:

   ![WN10-00-000145-PASS](https://github.com/user-attachments/assets/4f09cd42-f1e8-4309-9214-76f81fcd1f81)


---

## 6. Rollback Instructions

To revert to **OptIn** (less secure, default):
```powershell
bcdedit /set '{current}' nx OptIn
```
Then reboot.

---

## 7. Final Results

With DEP set to **OptOut** (or higher), you close off a broad class of memory-based exploits and comply with **WN10-00-000145** in the Windows 10 STIG.
