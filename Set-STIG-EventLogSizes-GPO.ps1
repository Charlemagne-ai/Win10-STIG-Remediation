<#
.SYNOPSIS
  Sets minimum event log sizes for DISA Windows 10 STIG v3r2 using the Group Policy registry path:
    WN10-AU-000500 (Application >= 32768 KB)
    WN10-AU-000505 (Security >= 1024000 KB)
    WN10-AU-000510 (System >= 32768 KB)

.DESCRIPTION
  Creates and configures the "MaxSize" DWORD under:
    HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\<LogName>

  to meet STIG minimum sizes:
    - Application: 32768
    - Security: 1024000
    - System: 32768

.NOTES
  Author          : [Charlemagne]
  LinkedIn        : [https://linkedin.com/in/charlemagned/]
  GitHub          : [https://github.com/charlemagne-ai]
  Date Created    : [03-04-2025]
  Last Modified   : [03-04-2025]
  CVEs            : N/A
  Plugin IDs      : N/A
  STIG-ID         : WN10-AU-000500, WN10-AU-000505, WN10-AU-000510

.TESTED ON
  Date(s) Tested  : [03-04-2025]
  Tested By       : [Charlemagne]
  Systems Tested  : Windows 10 (Version 10.0.19045.5487)

.USAGE
  Example usage:
    PS C:\> .\Set-STIG-EventLogSizes-GPO.ps1
    (Run as Administrator, then do "gpupdate /force" if needed)
#>

# Define the log names and their required sizes:
$LogRequirements = @(
    @{ Name = 'Application'; Size = 32768   }, # WN10-AU-000500
    @{ Name = 'Security';    Size = 1024000 }, # WN10-AU-000505
    @{ Name = 'System';      Size = 32768   }  # WN10-AU-000510
)

# Base registry path for GPO-based settings:
$BasePath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog'

foreach ($log in $LogRequirements) {
    $logPath  = Join-Path $BasePath $log.Name
    $logSize  = $log.Size
    $propName = 'MaxSize'

    Write-Host "Processing $($log.Name) log under $logPath..."

    try {
        # Ensure the subkey exists; Create it if not present.
        if (!(Test-Path $logPath)) {
            New-Item -Path $logPath -Force | Out-Null
            Write-Host "  Created subkey for $($log.Name)."
        }

        # Set or update the MaxSize property.
        New-ItemProperty -Path $logPath `
                         -Name $propName `
                         -PropertyType DWORD `
                         -Value $logSize `
                         -Force | Out-Null

        Write-Host "  Set 'MaxSize' to $logSize KB for $($log.Name)."
    }
    catch {
        Write-Error "  Failed to configure $($log.Name) log size. Error: $_"
    }
}

Write-Host "`nAll desired event log sizes have been set under Policies. If needed, run 'gpupdate /force' or reboot to ensure policy is applied."
