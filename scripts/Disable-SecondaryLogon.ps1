<#
.SYNOPSIS
    Disables the Secondary Logon service (seclogon) to satisfy STIG WN10-00-000175.

.DESCRIPTION
    Stops and disables the Secondary Logon (seclogon) service, preventing 
    privilege escalation in standard user sessions. Some Windows editions or 
    Nessus plugins strictly check the registry Start=4 for complete compliance.

.NOTES
    Author          : Charlemagne  
    Date Created    : 03-09-2025
    Last Modified   : 03-09-2025
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-00-000175

.TESTED ON
    Date(s) Tested  : 03-09-2025
    Tested By       : Charlemagne
    Systems Tested  : Windows 10 (Version 10.0.19045.5487)
    PowerShell Ver. : 5.1

.USAGE
    PS C:\\> .\Disable-SecondaryLogon.ps1
    (Must be run as Administrator)

.NOTES
    IMPORTANT:
    - Even if you set StartupType to 'Disabled' via services.msc, on some systems 
      or GPO configurations the registry can remain Start=3 (Manual).
    - The code below explicitly sets Start=4, ensuring Nessus sees the service 
      as Disabled and passes WN10-00-000175.
#>

[CmdletBinding()]
param()

Write-Host "Disabling the Secondary Logon service (seclogon)..." -ForegroundColor Cyan

try {
    # 1) Stop the service if running
    Stop-Service -Name 'seclogon' -Force -ErrorAction SilentlyContinue

    # 2) Mark it Disabled in Service Control Manager
    Set-Service -Name 'seclogon' -StartupType Disabled

    # 3) Force registry 'Start' = 4 to ensure full compliance
    Set-ItemProperty -Path 'HKLM:SYSTEM\\CurrentControlSet\\Services\\seclogon' -Name 'Start' -Value 4

    Write-Host "Secondary Logon service disabled and registry updated (Start=4)." -ForegroundColor Green
}
catch {
    Write-Warning "Failed to disable Secondary Logon: $($_.Exception.Message)"
}
