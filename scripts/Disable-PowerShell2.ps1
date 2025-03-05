<#
.SYNOPSIS
  Disables Windows PowerShell 2.0 for STIG WN10-00-000155.

.DESCRIPTION
  Uses the 'Disable-WindowsOptionalFeature' cmdlet to remove PowerShell 2.0 from Windows 10.

.NOTES
  Author          : Charlemagne
  LinkedIn        : https://linkedin.com/in/charlemagned/
  GitHub          : https://github.com/charlemagne-ai
  Date Created    : 03-04-2025
  Last Modified   : 03-04-2025
  CVEs            : N/A
  Plugin IDs      : N/A
  STIG-ID         : WN10-00-000155

.TESTED ON
  Date(s) Tested  : 03-04-2025
  Tested By       : Charlemagne
  Systems Tested  : Windows 10 (Version 10.0.19045.5487)

.USAGE
  Example:
    PS C:\> .\Disable-PowerShell2.ps1
#>

Write-Host "Disabling Windows PowerShell 2.0 (WN10-00-000155)..."

try {
    Disable-WindowsOptionalFeature -Online -FeatureName "MicrosoftWindowsPowerShellV2Root" -NoRestart -ErrorAction Stop
    Write-Host "Successfully disabled PowerShell 2.0."
}
catch {
    Write-Error "Error disabling PowerShell 2.0. $_"
}

Write-Host "Done. A reboot may be required to fully remove legacy components."
