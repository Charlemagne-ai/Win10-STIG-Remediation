# Event Log Size Remediation
**STIG IDs**:  
- **WN10-AU-000500** (Application event log ≥ 32768 KB)  
- **WN10-AU-000505** (Security event log ≥ 1024000 KB)  
- **WN10-AU-000510** (System event log ≥ 32768 KB)  

---

## 1. Problem Statement / Vulnerability

### Issue
- By default, Windows event logs can be configured with smaller sizes. If logs are too small, critical events could be overwritten, preventing forensic analysis or detection of malicious activity.

### Risk
- Failing these STIG items means your environment may not maintain sufficient audit records for security incidents.

---

## 2. Before Remediation (Initial State)

**Before** remediation: No `EventLog` in `HKEY_LOCAL_MACHINE/SOFTWARE\Policies\Microsoft\Windows` filepath
![Before-Script-EventLog](https://github.com/user-attachments/assets/4f83c42e-09bb-4256-9999-c79468c68763)


## Manual Remediation (Registry Editor)

1. **Open Registry Editor**  
   - Press `Win + R`, type `regedit`, and press **Enter**.  
   - Click **Yes** when prompted by User Account Control.

2. **Navigate to the Policy Keys**  
   - In the left pane, browse to:
     ```
     HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows
     ```
   - Right-click **Windows** → **New** → **Key** and name it **EventLog** (if it doesn’t already exist).

3. **Create Subkeys for Each Log**  
   - Inside **EventLog**, create three new subkeys:
     - **Application**
     - **Security**
     - **System**  
   If any of these subkeys already exist, skip creating them.

4. **Add or Edit “MaxSize” DWORD**  
   - Select each subkey (e.g., **Application**) in turn.
   - Right-click in the right pane → **New** → **DWORD (32-bit) Value** → name it **MaxSize**.  
     If **MaxSize** already exists, just double-click it.
   - Change **Base** to **Decimal**, then enter:
     - **32768** (KB) for **Application**  
     - **1024000** (KB) for **Security**  
     - **32768** (KB) for **System**  
   - Click **OK** to save.

5. **Confirm Entries**  
   - For **Application**: `MaxSize` = **32768**  
   - For **Security**: `MaxSize` = **1024000**  
   - For **System**: `MaxSize` = **32768**  

   - Close `regedit.exe` and reboot if desired. (A reboot isn’t strictly required, but can help ensure everything is fully recognized.)

**Screenshot References**  
![WN10-AU-000500-01](https://github.com/user-attachments/assets/b5b292c5-63c8-456f-bc4c-a47ad726f7a1)

![WN10-AU-000500-03](https://github.com/user-attachments/assets/9f480c01-3c9c-4bb8-b79e-a2e9d7f3524e)

![WN10-AU-000500-05](https://github.com/user-attachments/assets/98d24fba-2853-43df-85af-594a73ad73fc)


### B. Automated Remediation (PowerShell Script)

See [`scripts/Set-STIG-EventLogSizes-GPO.ps1`](../scripts/Set-STIG-EventLogSizes-GPO.ps1).  

![EventLog-ISE](https://github.com/user-attachments/assets/efa6d59c-d0c8-4426-9938-08b92a0474bc)

---

## 4. Testing / Verification

1. **Run the following commands in command prompt to verify new MaxSize values**  

```
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application /v MaxSize
```
```
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\EventLog\System /v MaxSize
```
```
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security /v MaxSize
```

![EventLog-MaxSize-AfterScript](https://github.com/user-attachments/assets/43d12b83-97e2-482d-a797-9c554fce00e2)

2. **Re-run Nessus**  
- Confirm WN10-AU-000500, WN10-AU-000505, and WN10-AU-000510 now pass.

![WN10-AU-000500-PASS](https://github.com/user-attachments/assets/df8cb0f5-cf07-4d38-9b52-e67aae32164a)
![WN10-AU-000505-PASS](https://github.com/user-attachments/assets/835e6b3c-09a5-47ae-a556-e03d3733a283)
![WN10-AU-000510-PASS](https://github.com/user-attachments/assets/038af54a-5121-4dad-b610-e8a9af0f11d9)

---

## 5. Rollback Instructions (If Needed)

If you want to completely **remove** all policy-based event log size settings that were added, you have two options:

1. **Delete the Entire `EventLog` Key**  
   - **Only do this if** you are certain no other policy settings or subkeys were stored there.  
   - In `regedit`:
     1. Navigate to `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows`.
     2. Right-click the `EventLog` folder and select **Delete**.
     3. Confirm when prompted.  
   - This will restore the system to the original state (where `EventLog` did not exist), causing Windows to revert to the defaults in `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog`.

2. **Remove Only the Subkeys/Values**  
   - If the `EventLog` key holds other settings you need to preserve, simply remove the subkeys for **Application**, **Security**, and **System**, or the `MaxSize` values:
     ```powershell
     # Example PowerShell snippet to remove just the MaxSize properties:
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application" -Name "MaxSize" -ErrorAction SilentlyContinue
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security"   -Name "MaxSize" -ErrorAction SilentlyContinue
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System"     -Name "MaxSize" -ErrorAction SilentlyContinue
     ```
   - This way, you only remove the pieces you created and keep any other policy subkeys intact.

---

## 6. Final Results

After applying the fix and rescanning, the system logs now meet or exceed the minimum STIG size. This ensures important audit events aren’t overwritten prematurely.

---

**End of Document**





