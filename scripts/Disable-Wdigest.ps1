<#
.SYNOPSIS
  Disables WDigest authentication for STIG WN10-CC-000038.

.DESCRIPTION
  Sets the UseLogonCredential DWORD to 0 under 
  HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest,
  preventing plaintext password storage in LSASS.

.NOTES
  Author          : Charlemagne
  LinkedIn        : [https://linkedin.com/in/charlemagned/]
  GitHub          : [https://github.com/charlemagne-ai]
  Date Created    : 03-05-2025
  Last Modified   : 03-05-2025
  CVEs            : N/A
  Plugin IDs      : N/A
  STIG-ID         : WN10-CC-000038

.TESTED ON
  Date(s) Tested  : 03-05-2025
  Tested By       : Charlemagne
  Systems Tested  : Windows 10 (Version 10.0.19045.5487)

.USAGE
  Save as "Disable-WDigest.ps1" and run in an elevated PowerShell session:
    PS C:\> .\Disable-WDigest.ps1
#>

Write-Host "Disabling WDigest authentication (STIG: WN10-CC-000038)..." -ForegroundColor Cyan

# Registry path for WDigest
$wdigestPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest'
$dwordName   = 'UseLogonCredential'
$dwordValue  = 0

try {
    # Ensure WDigest key exists
    if (!(Test-Path $wdigestPath)) {
        New-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders' -Name 'WDigest' -Force | Out-Null
        Write-Host "Created the WDigest registry key."
    }

    # Create/update UseLogonCredential = 0 (DWORD)
    New-ItemProperty -Path $wdigestPath -Name $dwordName -PropertyType DWORD -Value $dwordValue -Force | Out-Null
    Write-Host "Successfully set $dwordName to $dwordValue (disabled)."
}
catch {
    Write-Error "Failed to set $dwordName. Error: $_"
}

Write-Host "A reboot is recommended to fully apply the change." -ForegroundColor Yellow
