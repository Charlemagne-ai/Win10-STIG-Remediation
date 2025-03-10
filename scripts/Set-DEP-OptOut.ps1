<#
.SYNOPSIS
    Sets Windows Data Execution Prevention (DEP) to OptOut for STIG WN10-00-000145.

.DESCRIPTION
    Uses bcdedit to configure DEP to 'OptOut'. 
    This ensures all processes use DEP except those explicitly opted out by an administrator.

.NOTES
    Author          : Charlemagne
    Date Created    : 03-09-2025
    Last Modified   : 03-09-2025
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-00-000145

.TESTED ON
    Date(s) Tested  : 03-09-2025
    Tested By       : Charlemagne
    Systems Tested  : Windows 10 (Version 10.0.19045.5487)
    PowerShell Ver. : 5.1

.USAGE
    PS C:\\> .\Set-DEP-OptOut.ps1
    (Must be run as Administrator)
#>

[CmdletBinding()]
param()

Write-Host "Configuring DEP to 'OptOut'..." -ForegroundColor Cyan

try {
    # Set DEP to OptOut
    # Use single quotes around {current} to avoid escape issues
    bcdedit /set '{current}' nx OptOut

    Write-Host "DEP successfully set to 'OptOut'. Please reboot now." -ForegroundColor Green
}
catch {
    Write-Warning "Failed to set DEP: $($_.Exception.Message)"
}
