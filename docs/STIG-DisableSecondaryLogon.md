# Disable Secondary Logon Service
**STIG ID**: WN10-00-000175

---

## 1. Issue & Risk

### Issue
The **Secondary Logon** service (seclogon) allows users to launch processes under different credentials without logging off. In certain contexts, even a standard user session could run tasks with administrative privileges. 

### Risk
Attackers may leverage **Secondary Logon** to escalate privileges or steal credentials in a normal user context. Disabling the service removes a potential attack surface for unauthorized elevation.

---

## 2. Before Remediation (Initial State)

![Before_DisableSecondaryLogon](https://github.com/user-attachments/assets/707a9e19-ebf1-4640-a5c6-332562965371)

---

## 3. Manual Remediation

### A) Via Services Console
1. Press **Win + R**, type `services.msc`, and press **Enter**.
2. Locate **Secondary Logon** in the list.
3. Right-click → **Properties**.
4. **Stop** the service if it's running.
5. Set **Startup type** to **Disabled**.
6. Click **OK** to save.

### B) Via Local Group Policy
1. Press **Win + R**, type `gpedit.msc`, and press **Enter**.
2. Navigate to:
   ```
   Computer Configuration
    └─ Windows Settings
       └─ Security Settings
          └─ System Services
   ```
3. Double-click **Secondary Logon** in the right pane.
4. Select **Define this policy setting**, set **Startup** to **Disabled**.
5. **OK**, then run `gpupdate /force` or reboot if needed.

---

## 4. Automated Remediation

See [`scripts/Disable-SecondaryLogon.ps1`](../scripts/Disable-SecondaryLogon.ps1).

```powershell
# Disable Secondary Logon (seclogon)
Stop-Service -Name seclogon -Force -ErrorAction SilentlyContinue
Set-Service -Name seclogon -StartupType Disabled

# Force 'Start=4' in the registry so scanners see it as disabled
Set-ItemProperty -Path "HKLM:SYSTEM\\CurrentControlSet\\Services\\seclogon" -Name "Start" -Value 4

Write-Output "Secondary Logon (seclogon) is now fully disabled."
```
![Disable Secondary Logon_Script](https://github.com/user-attachments/assets/b2ea438c-a6d8-4dd8-8a83-516bee2f22f1)

---



## 5. Testing / Verification

1. **Check Services.msc**  
   - Ensure **Secondary Logon** shows as Disabled. If it’s stopped but set to Manual in the registry, some scans may still fail.

2. **Check Registry Value**  
   ```powershell
   Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\seclogon" -Name "Start"
   ```
   ![After_DisableSecondaryLogon](https://github.com/user-attachments/assets/67309f3e-4d31-4d14-9772-1a286141c0ef)

   - If **Start** is **4**, it’s truly Disabled.  
   - If **Start** is **3**, it’s Manual.
     

  > **Note**  
  > On certain Windows editions, setting the Secondary Logon service to “Disabled” in Services.msc may leave the registry `Start` value at **3** (Manual). **Nessus/STIG** typically requires **Start=4** to consider the service fully disabled for WN10-00-000175. If your scan fails, explicitly set **Start=4** in the registry or use a script that does so.
   ---

4. **Nessus / STIG Scan Pass**:
   
   ![disable-secondary-logon-pass](https://github.com/user-attachments/assets/279a62e2-b128-48c6-abbe-8810fc6cc912)

---

## 6. Rollback (If Needed)

1. **Services.msc**:
   - Set **Secondary Logon** → **Startup Type** = **Manual** (default).
   - **Start** the service if needed.
2. **PowerShell**:
   ```powershell
   Set-Service -Name seclogon -StartupType Manual
   Start-Service -Name seclogon
   ```
3. **Local Group Policy**:
   - In **System Services**, change Secondary Logon back to **Manual**.

---

## 7. Final Results

By disabling **Secondary Logon** (seclogon), you reduce the risk of privilege escalation in normal user sessions. This satisfies **WN10-00-000175** in the Windows 10 STIG, improving overall system security.
