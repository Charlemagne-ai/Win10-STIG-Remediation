<#
.SYNOPSIS
  Disables AutoPlay/AutoRun for STIG WN10-CC-000180, -000185, -000190.

.DESCRIPTION
  Configures policy-based registry settings under:
    HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer
  to disable AutoPlay for all drives, disallow non-volume device Autoplay,
  and set default autorun behavior to “do not execute any commands.”

.NOTES
  Author          : Charlemagne
  LinkedIn        : https://linkedin.com/in/charlemagned/
  GitHub          : https://github.com/charlemagne-ai
  Date Created    : 03-05-2025
  Last Modified   : 03-05-2025
  CVEs            : N/A
  Plugin IDs      : N/A
  STIG-ID         : WN10-CC-000180, WN10-CC-000185, WN10-CC-000190

.TESTED ON
  Date(s) Tested  : 03-05-2025
  Tested By       : Charlemagne
  Systems Tested  : Windows 10 (Version 10.0.19045.5487)

.USAGE
  PS C:\> .\Disable-AutoPlay.ps1
#>

Write-Host "Disabling AutoPlay/AutoRun (WN10-CC-000180, -000185, -000190)..." -ForegroundColor Cyan

$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer'

if (!(Test-Path $regPath)) {
    New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows' -Name 'Explorer' -Force | Out-Null
}

try {
    # Turn off autoplay for non-volume devices
    New-ItemProperty -Path $regPath -Name 'NoAutoplayfornonVolume' -PropertyType DWORD -Value 1 -Force | Out-Null

    # Set default autorun behavior to "do not execute"
    New-ItemProperty -Path $regPath -Name 'NoAutorun' -PropertyType DWORD -Value 1 -Force | Out-Null

    # Disable autoplay on all drives (0xFF = 255 decimal)
    New-ItemProperty -Path $regPath -Name 'NoDriveTypeAutoRun' -PropertyType DWORD -Value 255 -Force | Out-Null

    Write-Host "AutoPlay/AutoRun policies set. Run 'gpupdate /force' or reboot."
}
catch {
    Write-Error "Error configuring AutoPlay/AutoRun settings: $_"
}

Write-Host "AutoPlay/AutoRun disabled. Run 'gpupdate /force' or reboot to finalize changes." -ForegroundColor Yellow
