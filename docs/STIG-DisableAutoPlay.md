# Disable AutoPlay/AutoRun
**STIG IDs**:  
- **WN10-CC-000180** (Turn off Autoplay for non-volume devices)  
- **WN10-CC-000185** (Default autorun behavior must prevent autorun commands)  
- **WN10-CC-000190** (Autoplay must be disabled for all drives)

---

## 1. Problem Statement / Vulnerability

### Issue
- **AutoPlay** and **AutoRun** can automatically execute code from inserted media (USB, optical drives) or connected devices (camera, MTP). Attackers may craft malicious “autorun.inf” to spread malware or run unauthorized code.

### Risk
- If AutoPlay/AutoRun remain enabled, **malicious code** could launch the moment removable media is connected, bypassing user caution and leading to infections or data breaches.

---

## 2. Baseline (Initial State)

**Before** remediation: Fail Status
![06-1-WN10-CC-000180](https://github.com/user-attachments/assets/4f767de1-d3a9-438d-a53b-b8f35dc55432)
![06-2-WN10-CC-000185](https://github.com/user-attachments/assets/60d059e8-9256-454f-8348-21f77151baeb)
![06-3-WN10-CC-000190](https://github.com/user-attachments/assets/5a751c8c-4a6e-4fd8-9581-bdd3841804a6)

---

## 3. Remediation Steps

### A. Manual Remediation (Local Group Policy)

1. **Open Local Group Policy Editor**  
   - Press **Win + R**, type `gpedit.msc`, press **Enter**.
2. **Navigate to “AutoPlay Policies”**  
   - **Computer Configuration** → **Administrative Templates** → **Windows Components** → **AutoPlay Policies**.

3. **Turn Off AutoPlay for Non-volume Devices (WN10-CC-000180)**  
   - Double-click **“Disallow Autoplay for non-volume devices”**.  
   - Set to **Enabled** → **OK**.

4. **Configure Default Autorun Behavior to “Do not execute any autorun commands” (WN10-CC-000185)**  
   - Double-click **“Set the default behavior for AutoRun”**.  
   - **Enabled**.  
   - Choose **“Do not execute any autorun commands”** in the dropdown → **OK**.

5. **Disable AutoPlay for All Drives (WN10-CC-000190)**  
   - Double-click **“Turn off AutoPlay”**.  
   - **Enabled**; select **“All drives”** in the dropdown → **OK**.

6. **Close GPO Editor**  
   - Run `gpupdate /force` or reboot if necessary.  
   - AutoPlay is now disabled across all devices and volumes.

### B. Automated Remediation (PowerShell Script)

See [`scripts/Disable-AutoPlay.ps1`](../scripts/Disable-AutoPlay.ps1).

```powershell
<#
.SYNOPSIS
  Disables AutoPlay/AutoRun for STIG WN10-CC-000180, -000185, -000190.

.DESCRIPTION
  Configures policy-based registry settings under:
    HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer
  to disable AutoPlay for all drives, disallow non-volume device Autoplay,
  and set default autorun behavior to “do not execute any commands.”

.NOTES
  Author          : Charlemagne
  LinkedIn        : https://linkedin.com/in/charlemagned/
  GitHub          : https://github.com/charlemagne-ai
  Date Created    : 03-05-2025
  Last Modified   : 03-05-2025
  CVEs            : N/A
  Plugin IDs      : N/A
  STIG-ID         : WN10-CC-000180, WN10-CC-000185, WN10-CC-000190

.TESTED ON
  Date(s) Tested  : 03-05-2025
  Tested By       : Charlemagne
  Systems Tested  : Windows 10 (Version 10.0.19045.5487)

.USAGE
  PS C:\> .\Disable-AutoPlay.ps1
#>

Write-Host "Disabling AutoPlay/AutoRun (WN10-CC-000180, -000185, -000190)..." -ForegroundColor Cyan

$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer'

if (!(Test-Path $regPath)) {
    New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows' -Name 'Explorer' -Force | Out-Null
}

try {
    # Turn off autoplay for non-volume devices
    New-ItemProperty -Path $regPath -Name 'NoAutoplayfornonVolume' -PropertyType DWORD -Value 1 -Force | Out-Null

    # Set default autorun behavior to "do not execute"
    New-ItemProperty -Path $regPath -Name 'NoAutorun' -PropertyType DWORD -Value 1 -Force | Out-Null

    # Disable autoplay on all drives (0xFF = 255 decimal)
    New-ItemProperty -Path $regPath -Name 'NoDriveTypeAutoRun' -PropertyType DWORD -Value 255 -Force | Out-Null

    Write-Host "AutoPlay/AutoRun policies set. Run 'gpupdate /force' or reboot."
}
catch {
    Write-Error "Error configuring AutoPlay/AutoRun settings: $_"
}

Write-Host "AutoPlay/AutoRun disabled. Run 'gpupdate /force' or reboot to finalize changes." -ForegroundColor Yellow
```

#### Explanation

- **NoAutoplayfornonVolume** = 1 → Disables Autoplay for non-volume devices (WN10-CC-000180).  
- **NoAutorun** = 1 → “Do not execute” any autorun commands (WN10-CC-000185).  
- **NoDriveTypeAutoRun** = 255 (decimal) → Disables AutoPlay on all drives (WN10-CC-000190).  
- These keys reflect policy-based registry settings under `HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer`, matching local GPO changes.

---

## 4. Testing / Verification

1. **Registry Check**  
   ![AutoRun_Regedit](https://github.com/user-attachments/assets/df085bc2-5506-4a99-8841-91440ba82c1a)


2. **Nessus / STIG Scan Pass**  

   ![WN10-CC-000180-PASS](https://github.com/user-attachments/assets/762f1730-4279-4e17-9b9d-c1959aa60052)

   ![WN10-CC-000185-PASS](https://github.com/user-attachments/assets/2d7f71dd-b1e8-4ded-a4e6-6f62f9e2d178)

   ![WN10-CC-000190-PASS](https://github.com/user-attachments/assets/56a79f6c-99ed-4663-b5ad-dcbc7620abb2)



   > **Note**  
   > While configuring registry values via script is usually sufficient, some STIG scanning tools (including certain Nessus plugins) explicitly check whether the Local Group Policy Editor (gpedit.msc) has the relevant policies set to “Enabled” rather than “Not Configured.”  
   > Therefore, **if your scan still fails** despite the correct registry keys, **manually enabling** these settings in gpedit ensures both the registry and GPO state align with the scanner’s expectations.

---

## 5. Rollback Instructions

To **re-enable** AutoPlay/AutoRun (not recommended):

1. **Registry**  
   - Delete or set these values to 0:
     - `NoAutoplayfornonVolume`  
     - `NoAutorun`  
     - `NoDriveTypeAutoRun`  
   - Example PowerShell:
     ```powershell
     Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'NoAutoplayfornonVolume'
     Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'NoAutorun'
     Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'NoDriveTypeAutoRun'
     ```

2. **Run gpupdate /force or reboot** to restore default AutoPlay behavior.

---

## 6. Final Results

By disabling AutoPlay/AutoRun:

- **You** eliminate the risk of malicious code automatically running from inserted media or connected devices.
- **WN10-CC-000180**, **WN10-CC-000185**, and **WN10-CC-000190** will pass in DISA Windows 10 STIG v3r2.
- This small convenience trade-off significantly boosts security against removable-media–based threats.

---

### Additional Notes

- If your environment is domain-joined, you might prefer setting these via **Group Policy** for consistency. This script configures the equivalent local policy registry keys.
- Modern software distribution has mostly moved away from AutoPlay reliance, so disabling it rarely hinders typical workflows.
