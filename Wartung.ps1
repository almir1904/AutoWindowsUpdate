$domain = $env:USERDNSDOMAIN
$hostname = $env:computername
$Upf = "C:\Scripts\UpdateService\Logs\Uptime.log"
$HashFile = "C:\Scripts\UpdateService\SHA256.hash"
$HashFile2 = "C:\Scripts\UpdateService\Temp.hash"
$Hash = Get-filehash C:\Scripts\UpdateService\Install.ps1 | Select-Object Hash
$OldHash = ""
$OldHash = Get-Content $HashFile
#Create Log Folder
if (Test-Path -Path C:\Scripts\UpdateService\Logs) {(Write-Host "Logs Ordner vorhanden" -ForegroundColor Green)} 
else {Write-Host "Logs Ordner nicht vorhanden" -ForegroundColor Red; (New-Item C:\Scripts\UpdateService\Logs -ItemType directory > $null) ; (Write-Host "Ordner erstellt" -ForegroundColor Green)}

#WSUS Skript
if ((Get-WindowsFeature UpdateServices).InstallState -eq "Installed") {
    Write-Host "WSUS Skript wird ausgeführt"
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
#Check Uptime
$Up = Get-CimInstance -ClassName win32_OperatingSystem | Select lastbootuptime > $Upf
$Content = Get-content $Upf | select-object -skip 3 
$Uptime = $Content[0].Split($empFileDelimiter) | select-object -first 1


If ($Hash.hash -ne $OldHash)
{
Remove-Item $HashFile
$SaveHash = $Hash | Format-Table -HideTableHeaders  > $HashFile2
$UpdateHash = Get-content $HashFile2 | select-object -skip 1  | Select -SkipLast 3 | Set-Content $HashFile
Remove-Item $HashFile2
.\Install.ps1
} else 
{Write-Host "No new Schedulerscript found"}