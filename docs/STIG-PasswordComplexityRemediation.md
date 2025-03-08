# Enforce Password Length & Complexity
**STIG IDs**:  
- **WN10-AC-000035** (Passwords must be ≥14 characters)  
- **WN10-AC-000040** (Enable password complexity)

---

## 1. Issue & Risk

### Issue
- Short or simple passwords are easily guessed or brute-forced.
- Without complexity (uppercase, lowercase, digits, symbols), attackers have an easier time cracking credentials.

### Risk
- If **WN10-AC-000035** and **WN10-AC-000040** are not enforced, you increase the likelihood of successful brute-force or dictionary attacks on user accounts.

---

## 2. Initial State (Before Remediation)

![Password_Before](https://github.com/user-attachments/assets/0e1d6ef8-f149-45f8-9cb0-d5de2c490f3f)

![05-1-WN10-AC-000035](https://github.com/user-attachments/assets/c7af34fe-5881-4ca6-8b36-04f5f0a7572f)

![05-2-WN10-AC-000040](https://github.com/user-attachments/assets/ccca9719-8b91-493d-87a9-a45fa5aea72c)

---

## 3. Manual Remediation

1. **Open Local Security Policy**  
   - Press **Win + R**, type `secpol.msc`, press Enter.
2. **Navigate to “Password Policy”**  
   - Under **Account Policies** → **Password Policy**.
3. **Set “Minimum password length”**  
   - Double-click **Minimum password length**.  
   - Enter **14** (or higher).  
   - Click **OK**.
4. **Enable “Password must meet complexity requirements”**  
   - Double-click **Password must meet complexity requirements**.  
   - Set to **Enabled**.  
   - Click **OK**.
5. **Close secpol.msc**  
   - No reboot needed typically.  
   - If your scanner still fails, run `gpupdate /force` or reboot.

---

## 4. Automated Remediation

See [`scripts/Set-STIG-PasswordComplexity.ps1`](../scripts/Set-STIG-PasswordComplexity.ps1).

```powershell
Write-Host "Enforcing minimum password length (≥14) and complexity..."

# Ensure C:\Temp exists
if (!(Test-Path 'C:\Temp')) {
    Write-Host "Creating C:\Temp directory..."
    New-Item -ItemType Directory -Path 'C:\Temp' -Force | Out-Null
}

# 1) Export current local security policy
secedit /export /cfg "C:\Temp\policy-old.ini" /areas SECURITYPOLICY

# 2) Replace or insert lines for min length = 14, complexity = 1
(gc "C:\Temp\policy-old.ini") `
    -replace 'MinimumPasswordLength = \d+', 'MinimumPasswordLength = 14' `
    -replace 'PasswordComplexity = \d+', 'PasswordComplexity = 1' `
    | Out-File "C:\Temp\policy-new.ini"

# 3) Re-import the updated policy
secedit /configure /db "C:\Windows\Security\Local.sdb" /cfg "C:\Temp\policy-new.ini" /areas SECURITYPOLICY

Write-Host "Password policy updated. Run gpupdate /force or reboot if needed."
```

> **Note**: This script uses **`secedit`** to export the existing policy, update it, and import the changes. Adjust file paths as needed.  

---

![Password_Script](https://github.com/user-attachments/assets/e277fc0a-f5aa-4bfb-a4b0-e4697048fc9d)


---

## 5. Testing / Verification

1. **Check Local Security Policy** (`secpol.msc`):
   - **Password Policy** → confirm **Minimum password length** is 14, **Password must meet complexity** is **Enabled**.
   ![Password_After](https://github.com/user-attachments/assets/79cb4234-1555-4865-a827-c04d3f28e949)

2. **Nessus / STIG Scan Pass**:
   - Confirm **WN10-AC-000035** (≥14 chars) and **WN10-AC-000040** (complexity) now pass.
     ![WN10-AC-000035](https://github.com/user-attachments/assets/1ad6e8fc-19a2-448b-a600-5e0eb493cb46)
     ![WN10-AC-000040](https://github.com/user-attachments/assets/5bf90cda-a311-42d4-a3f9-9fbf74255f16)

> **Note**  
> These updated password policies only apply to **future password changes**. Unless you explicitly configure “Change password at next logon” or have a password age forcing an update, **users with shorter or less complex existing passwords will not be forced to change them** immediately. They remain valid until the user (or a policy) initiates a password change.
---

## 6. Rollback Instructions

If you want to **reduce** or remove these policies (not recommended):

1. **secpol.msc**:
   - Set **Minimum password length** to a lower number or 0 (not STIG compliant).
   - Disable **Password must meet complexity requirements** or set to Not Configured.
2. **Script** approach:
   - Export again with secedit, revert `MinimumPasswordLength` to your desired value, and set `PasswordComplexity = 0`.  
   - Re-import with `secedit /configure`.

**Note**: Doing so makes your system fail WN10-AC-000035 and WN10-AC-000040 again.

---

## 7. Final Results

By enforcing **14+ character passwords** and **complexity**, you:

- Reduce brute-force or dictionary attacks on user accounts.
- Satisfy **WN10-AC-000035** and **WN10-AC-000040** per DISA Windows 10 STIG v3r2.
- Ensure each password contains multiple character types for stronger security.
