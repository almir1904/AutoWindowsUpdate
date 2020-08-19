Import-Module PSWindowsUpdate
$Logfile = "C:\Scripts\UpdateService\Logs\WindowsUpdate.log"
cd C:\Scripts\UpdateService\
if (Test-Path "C:\Scripts\UpdateService\Settings.ps1") {
  .\Settings.ps1}
#Update Script
.\Update-Scripts.ps1
#Start Service
set-service wuauserv -startup manual
start-service wuauserv
.\Wartung.ps1
New-EventLog –LogName Application –Source "UpdateService"
if ($Autoreboot -eq $false)
{Get-WindowsUpdate -install -acceptall -IgnoreReboot -verbose  *> $Logfile}
Else {Get-WindowsUpdate -install -acceptall -autoreboot -verbose  *> $Logfile}
$Log = Get-Content $Logfile 
Write-EventLog -LogName "Application" -Source "UpdateService" -EventID 1 -EntryType Information -Message ($Log | Format-List | Out-String) -Category 1 
