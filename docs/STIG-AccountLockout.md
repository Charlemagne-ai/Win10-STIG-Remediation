# Account Lockout Policy Remediation
**STIG IDs**:  
- **WN10-AC-000005** (Account lockout duration ≥ 15 minutes)  
- **WN10-AC-000010** (Number of allowed bad logon attempts ≤ 3)  
- **WN10-AC-000015** (Reset account lockout counter after ≥ 15 minutes)

---

## 1. Problem Statement / Vulnerability

### Issue
- If too many failed login attempts are allowed or the lockout duration is too short, attackers can brute-force passwords with little consequences. This increases the risk of unauthorized access.

### Risk
- Failing these STIG items greatly increases exposure to **brute-force attacks** on user accounts. Attackers can systematically guess or attempt weak passwords with minimal risk of detection or lockout.

---

## 2. Before Remediation (Initial State)

**Before** remediation:

![AccountLockout_Before](https://github.com/user-attachments/assets/18e4a971-fa61-43ad-a34b-6aa68b3ed407)

![04-1-WN10-AC-000005](https://github.com/user-attachments/assets/8ec5b8fa-bd50-410f-b839-0924245f5c9d)

![04-2-WN10-AC--000010](https://github.com/user-attachments/assets/7f54567e-4dac-4d0a-8759-3245573ef95a)

![04-2-WN10-AC--000015](https://github.com/user-attachments/assets/6b2e2e37-4b0f-4099-97e8-8ab8edac4c1e)

---

## 3. Manual Remediation (Local Security Policy)

1. **Open Local Security Policy**
   - Press **Win + R**, type `secpol.msc`, and press **Enter**.
2. **Navigate to Account Lockout Policy**
   - Expand **Account Policies** → **Account Lockout Policy** in the left pane.
3. **Configure Each Setting**  
   - **Account lockout duration** (WN10-AC-000005)  
     - Set this to **15** minutes (or greater). 
     - Alternatively, **0** means “locked until an admin unlocks,” which also meets STIG.  
   - **Account lockout threshold** (WN10-AC-000010)  
     - Set to **3** (or fewer) invalid attempts before lockout.  
   - **Reset account lockout counter after** (WN10-AC-000015)  
     - Set to **15** minutes (or greater).  
4. **Confirm the Changes**
   - Check each policy’s “Effective Setting.”  
   - A reboot or `gpupdate /force` is generally not required for local security policy changes to apply, but a **restart** can help if the scanner still fails to recognize the changes.

---

## 4. Automated Remediation (PowerShell Script)

See [`scripts/Disable-AutoPlay.ps1`](../scripts/Set-STIG-AccountLockout.ps1).

```powershell
Write-Host "Configuring Account Lockout Policy (WN10-AC-000005, -000010, -000015)..." -ForegroundColor Cyan

try {
    # WN10-AC-000010: Allowed bad logon attempts ≤ 3
    net accounts /lockoutthreshold:3

    # WN10-AC-000005: Account lockout duration ≥ 15
    net accounts /lockoutduration:15

    # WN10-AC-000015: Reset lockout counter after ≥ 15
    net accounts /lockoutwindow:15

    Write-Host "Lockout policies configured successfully!"
}
catch {
    Write-Error "Failed to configure account lockout policies: $_"
}
```

**Reference**: [Official Microsoft net accounts documentation](https://learn.microsoft.com/en-us/troubleshoot/windows-server/networking/net-commands-on-operating-systems).

---

![AccountLockout_Script](https://github.com/user-attachments/assets/ec77f57b-a214-474e-ad72-55cc28f09b20)


## 5. Testing / Verification

1. **Check Local Security Policy**  

   ![AccountLockout_After](https://github.com/user-attachments/assets/7923eb16-d87c-462f-b095-785bbaca65f0)
  
2. **Nessus / STIG Scan Pass**
   
   ![WN10-AC-000005](https://github.com/user-attachments/assets/8753e8e1-0a3e-48e7-a85e-1cc2741c1cff)

   ![WN10-AC-000010](https://github.com/user-attachments/assets/9cd27ac6-7d4e-47e7-9980-e4ee38b53ae8)

   ![WN10-AC-000015](https://github.com/user-attachments/assets/bbd9c8b3-3aee-4805-be20-6d505874a05c)


---

## 6. Rollback Instructions (If Needed)

To remove or reduce the strictness the lockout policy:

1. **net accounts** approach:
   - `net accounts /lockoutthreshold:0` → Disables lockouts entirely (not STIG compliant).
   - `net accounts /lockoutduration:30` → Adjust the lockout length to 30 minutes, etc.
2. **secpol.msc** approach:
   - Return the “Account lockout threshold” to **0** or raise “Account lockout duration” or “Reset counter after” if you need different values.

> **Note**: Disabling lockout policies or making them less strict will revert you to a noncompliant state for these STIGs.

---

## 7. Final Results

By setting **lockout** threshold, duration, and reset counter properly:

- **You** mitigate brute-force attacks on local accounts.  
- **WN10-AC-000005**, **-000010**, and **-000015** will pass in **DISA Windows 10 STIG v3r2**.  
