$domain = $env:USERDNSDOMAIN
$hostname = $env:computername
$Upf = "C:\Scripts\UpdateService\Logs\Uptime.log"
#Create Log Folder
if (Test-Path -Path C:\Scripts\UpdateService\Logs) {(Write-Host "Logs Ordner vorhanden" -ForegroundColor Green)} 
else {Write-Host "Logs Ordner nicht vorhanden" -ForegroundColor Red; (New-Item C:\Scripts\UpdateService\Logs -ItemType directory > $null) ; (Write-Host "Ordner erstellt" -ForegroundColor Green)}

#WSUS Skript
if ((Get-WindowsFeature UpdateServices).InstallState -eq "Installed") {
    Write-Host "WSUS Skript wird ausgeführt"
	.\Tools\Clean-WSUS.ps1 -FirstRun
} 
else {
    Write-Host "WSUS is not installed on $hostname" -ForegroundColor Yellow
}
#IIS Exchange CleanUp
if (Get-Service -name MSExchangeServiceHost -ErrorAction SilentlyContinue) {
    Write-Host "IIS Exchange Cleanup Skript wird ausgeführt"
	.\Tools\CleanLogs.PS1
} 
else {
    Write-Host "Exchange is not installed on $hostname" -ForegroundColor Yellow
}
#Check Uptime
$Up = Get-CimInstance -ClassName win32_OperatingSystem | Select lastbootuptime > $Upf
$Content = Get-content $Upf | select-object -skip 3 
$Uptime = $Content[0].Split($empFileDelimiter) | select-object -first 1
