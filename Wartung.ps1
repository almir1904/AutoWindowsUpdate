$Global:domain = $env:USERDNSDOMAIN
$Global:hostname = $env:computername
$Upf = "C:\Scripts\UpdateService\Logs\Uptime.log"
$HashFile = "C:\Scripts\UpdateService\SHA256.hash"
$HashFile2 = "C:\Scripts\UpdateService\Temp.hash"
$Hash = Get-filehash C:\Scripts\UpdateService\Install.ps1 | Select-Object Hash
$OldHash = ""
$OldHash = Get-Content $HashFile -ErrorAction SilentlyContinue
#Create Log Folder
if (Test-Path -Path C:\Scripts\UpdateService\Logs) {(Write-Host "Logs Ordner vorhanden" -ForegroundColor Green)} 
else {Write-Host "Logs Ordner nicht vorhanden" -ForegroundColor Red; (New-Item C:\Scripts\UpdateService\Logs -ItemType directory > $null) ; (Write-Host "Ordner erstellt" -ForegroundColor Green)}

#WSUS Skript
if ((Get-WindowsFeature UpdateServices).InstallState -eq "Installed") {
    Write-Host "WSUS Script wird ausgeführt"
	.\Tools\WSUS.exe -FirstRun
	.\Tools\Clean-WSUS.ps1
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
#Deduplication
if ((Get-WindowsFeature FS-Data-Deduplication).InstallState -eq "Installed"){
	Write-Host "Deduplication is active"
	.\Tools\Deduplication.ps1
}
Deduplizierung aktiv
#Check Uptime
$Up = Get-CimInstance -ClassName win32_OperatingSystem | Select lastbootuptime > $Upf
$Content = Get-content $Upf | select-object -skip 3 
$Uptime = $Content[0].Split($empFileDelimiter) | select-object -first 1


If ($Hash.hash -ne $OldHash)
{
$HashFile = "C:\Scripts\UpdateService\SHA256.hash"
$Hash = Get-filehash C:\Scripts\UpdateService\Install.ps1 | Select-Object Hash
$OldHash = Get-Content $HashFile -ErrorAction SilentlyContinue

Write-Host "Update Hash File"
Remove-Item $HashFile -ErrorAction SilentlyContinue
$Hash = Get-filehash C:\Scripts\UpdateService\Install.ps1 | Select-Object Hash

$SaveHash = $Hash.hash | Set-Content $HashFile
#.\Install.ps1
} else 
{Write-Host "No new Schedulerscript found"}