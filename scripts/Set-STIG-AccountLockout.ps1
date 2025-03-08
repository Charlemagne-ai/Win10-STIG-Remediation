<#
.SYNOPSIS
  Configures Account Lockout Policy for STIG WN10-AC-000005, WN10-AC-000010, and WN10-AC-000015.

.DESCRIPTION
  Uses net accounts commands to enforce:
    - /lockoutthreshold:3
    - /lockoutduration:15
    - /lockoutwindow:15
  Ensuring the account lockout threshold, duration, and reset window comply with STIG guidelines.

.NOTES
  Author          : Charlemagne
  LinkedIn        : https://linkedin.com/in/charlemagned/
  GitHub          : https://github.com/charlemagne-ai
  Date Created    : 03-08-2025
  Last Modified   : 03-08-2025
  CVEs            : N/A
  Plugin IDs      : N/A
  STIG-ID         : WN10-AC-000005, WN10-AC-000010, WN10-AC-000015

.TESTED ON
  Date(s) Tested  : 03-06-2025
  Tested By       : Charlemagne
  Systems Tested  : Windows 10 (Version 10.0.19045.5487)

.USAGE
  PS C:\> .\Set-STIG-AccountLockout.ps1
#>

Write-Host "Configuring Account Lockout Policy..."

try {
    # Lockout threshold <= 3
    net accounts /lockoutthreshold:3
    
    # Lockout duration >= 15
    net accounts /lockoutduration:15
    
    # Reset lockout counter after >= 15
    net accounts /lockoutwindow:15

    Write-Host "Lockout policies configured successfully!"
}
catch {
    Write-Error "Failed to configure account lockout policies: $_"
}
