Import-Module PSWindowsUpdate
$PC = "$env:computername.$env:userdnsdomain"
$Logfile = "C:\Scripts\UpdateService\Logs\WindowsUpdate.log"
cd C:\Scripts\UpdateService\
if (Test-Path "C:\Scripts\UpdateService\Settings.ps1") {
  .\Settings.ps1}

if ($AllowReboot -eq $false)
{$Title = "$PC wurde aktualisiert"}
Else {$Title = "$PC wurde aktualisiert und startet gleich neu"}
#Update Script
.\Update-Scripts.ps1
#Start Service
set-service wuauserv -startup manual
start-service wuauserv
.\Wartung.ps1
$logFileExists = Get-EventLog –LogName Application | Where-Object {$_.Source -eq "UpdateService"} 
if (! $logFileExists) {
    New-EventLog –LogName Application –Source "UpdateService"
}
if ($AllowReboot -eq $false)
{Get-WindowsUpdate -install -acceptall -IgnoreReboot -verbose  *> $Logfile}
Else {Get-WindowsUpdate -install -acceptall -autoreboot -verbose  *> $Logfile}
$Log = Get-Content $Logfile 
Write-EventLog -LogName "Application" -Source "UpdateService" -EventID 1 -EntryType Information -Message ($Log | Format-List | Out-String) -Category 1 
.\Tools\Send-Pushover.ps1 $PushoverUserkey $PushoverApi -Title $Title -Message "Updates wurden installiert"
