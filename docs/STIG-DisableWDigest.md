# Disable WDigest Authentication
**STIG ID**: WN10-CC-000038

---

## 1. Problem Statement / Vulnerability

### Issue
- **WDigest** is an older Windows authentication protocol that can store credentials in memory in **plaintext**.  
- By default, Windows 10 should have WDigest disabled, but if re-enabled or misconfigured, it could expose credentials, allowing attackers who obtain local SYSTEM-level access to retrieve cleartext passwords.

### Risk
- If WDigest is left enabled, **cleartext credentials** remain in LSASS memory. Attackers could dump these credentials and move laterally across the environment. Disabling WDigest ensures credentials are never stored in plaintext this way.

---

## 2. Baseline (Initial State)

**Before** remediation:
![09-WN10-CC-000038](https://github.com/user-attachments/assets/3716398e-127f-4e32-9531-5fd63a775386)
  
*Figure 1.* WDigest setting flagged as failed.
  
---

## 3. Remediation Steps

### A. Manual Remediation (Registry Editor)

1. **Open Registry Editor**  
   - Press **Win + R**, type `regedit`, and press **Enter**.
   - If prompted by UAC, select **Yes**.

2. **Navigate to the WDigest Key**  
   ```
   HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest
   ```
   - If the **WDigest** subkey does not exist, create it under **SecurityProviders**.

3. **Create or Update the `UseLogonCredential` DWORD**  
   - In the right pane, right-click → **New → DWORD (32-bit) Value** and name it: **UseLogonCredential**  
     *(If it already exists, just edit it.)*
   - Double-click **UseLogonCredential**.  
     - Set **Base** to **Decimal**.  
     - Enter **0** (zero) as the **Value Data**.  
   - Click **OK** to save.

4. **Close `regedit.exe`**  
   - A reboot is recommended to ensure the setting is fully applied, although changes typically take effect immediately for new logon sessions.

### B. Automated Remediation (PowerShell Script)

See [`scripts/Disable-WDigest.ps1`](../scripts/Disable-WDigest.ps1).

![WDigest-RunScript](https://github.com/user-attachments/assets/0d9549f6-a4fd-4b6d-a55f-7fb571542bd4)
---

## 4. Testing / Verification

1. **Registry Check**  
   - Reopen `regedit` and confirm:
     ```
     HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest\UseLogonCredential
     ```
     has a **Value Data** of **0**.

2. **Nessus / STIG Scan Pass**  

   ![WN10-CC-000038-PASS](https://github.com/user-attachments/assets/1cb2df62-7d73-4c32-811a-ec6f87704b91)

---

## 5. Rollback Instructions

To **re-enable** WDigest (not recommended):

1. **Edit the Registry**:
   - Navigate back to `HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest`.
   - Set **UseLogonCredential** to **1** (Decimal) instead of **0**, or remove the DWORD entirely.

2. **Reboot**:
   - If you want the system to accept WDigest authentication again, a reboot ensures LSASS reloads the new setting.

---

## 6. Final Results

- By disabling WDigest, you eliminate the **plaintext password** storage risk in LSASS for this legacy protocol.
- This **satisfies WN10-CC-000038** in the Windows 10 STIG v3r2.
