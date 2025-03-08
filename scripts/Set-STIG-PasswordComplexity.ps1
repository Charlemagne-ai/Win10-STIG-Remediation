<#
.SYNOPSIS
  Enforces password length ≥14 and complexity, aligning with STIG WN10-AC-000035, WN10-AC-000040.

.DESCRIPTION
  Exports the current local policy with 'secedit', modifies MinimumPasswordLength
  and PasswordComplexity entries, then re-imports the updated policy.
  This ensures users must have at least 14 characters and use multiple character types.

.NOTES
  Author          : Charlemagne
  LinkedIn        : https://linkedin.com/in/charlemagned/
  GitHub          : https://github.com/charlemagne-ai
  Date Created    : 03-08-2025
  Last Modified   : 03-08-2025
  CVEs            : N/A
  Plugin IDs      : N/A
  STIG-ID         : WN10-AC-000035, WN10-AC-000040

.TESTED ON
  Date(s) Tested  : 03-08-2025
  Tested By       : Charlemagne
  Systems Tested  : Windows 10 (Version 10.0.19045.5487)

.USAGE
  PS C:\> .\Set-STIG-PasswordComplexity.ps1
#>

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
