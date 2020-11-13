#Requires -RunAsAdministrator
Set-Executionpolicy RemoteSigned
$days=0
$IISLogPath="C:\inetpub\logs\LogFiles\"
$TargetFolder="C:\Program Files\Microsoft\Exchange Server\V15\Logging"
$ExchangeLoggingPath="C:\Program Files\Microsoft\Exchange Server\V15\Logging\"
$HTTPProxyPath="C:\Program Files\Microsoft\Exchange Server\V15\Logging\HttpProxy\Mapi\"
$ETLLoggingPath="C:\Program Files\Microsoft\Exchange Server\V15\Bin\Search\Ceres\Diagnostics\ETLTraces\"
$ETLLoggingPath2="C:\Program Files\Microsoft\Exchange Server\V15\Bin\Search\Ceres\Diagnostics\Logs\"
$MapiHTTP="C:\Program Files\Microsoft\Exchange Server\V15\Logging\MapiHttp\Mailbox"
$EAS="C:\Program Files\Microsoft\Exchange Server\V15\Logging\HttpProxy\Eas"
$PWSHLog="C:\Program Files\Microsoft\Exchange Server\V15\Logging\HttpProxy\PowerShell"
$Authz="C:\Program Files\Microsoft\Exchange Server\V15\Logging\CmdletInfra\Powershell-Proxy\AuthZ"
$PWHTTP="C:\Program Files\Microsoft\Exchange Server\V15\Logging\CmdletInfra\Powershell-Proxy\Http"
$EWSLog="C:\Program Files\Microsoft\Exchange Server\V15\Logging\HttpProxy\Ews"
$ActiveMonitoringTraceLogs="C:\Program Files\Microsoft\Exchange Server\V15\Logging\Monitoring\Monitoring\MSExchangeHMWorker\ActiveMonitoringTraceLogs"

#takeown /A /F "C:\Program Files\Microsoft\Exchange Server\V15\Logging" /R
Function CleanLogfiles($TargetFolder)
{
  write-host -debug -ForegroundColor Yellow -BackgroundColor Cyan $TargetFolder

    if (Test-Path $TargetFolder) {
        $Now = Get-Date
        $LastWrite = $Now.AddDays(-$days)
        $Files = Get-ChildItem $TargetFolder -Include *.log,*.blg, *.etl,*.LOG -Recurse | Where {$_.LastWriteTime -le "$LastWrite"}
     #   $Files = Get-ChildItem "C:\Program Files\Microsoft\Exchange Server\V15\Logging\"  -Recurse | Where-Object {$_.Name -like "*.log" -or $_.Name -like "*.blg" -or $_.Name -like "*.etl"}  | where {$_.lastWriteTime -le "$lastwrite"} | Select-Object FullName  
        foreach ($File in $Files)
            {
               $FullFileName = $File.FullName  
               Write-Host "Deleting file $FullFileName" -ForegroundColor "yellow"; 
                Remove-Item $FullFileName -ErrorAction SilentlyContinue | out-null
            }
       }
Else {
    Write-Host "The folder $TargetFolder doesn't exist! Check the folder path!" -ForegroundColor "red"
    }
}
CleanLogfiles($IISLogPath)
CleanLogfiles($TargetFolder)
CleanLogfiles($ExchangeLoggingPath)
CleanLogfiles($ETLLoggingPath)
CleanLogfiles($ETLLoggingPath2)
CleanLogfiles($HTTPProxyPath)
CleanLogfiles($MapiHTTP)
CleanLogfiles($EAS)
CleanLogfiles($PWSHLog)
CleanLogfiles($Authz)
CleanLogfiles($PWHTTP)
CleanLogfiles($EWSLog)
CleanLogfiles($ActiveMonitoringTraceLogs)

Function CleanLogfiles2($TargetFolder)
{
  write-host -debug -ForegroundColor Yellow -BackgroundColor Cyan $TargetFolder

    if (Test-Path $TargetFolder) {
        $Now = Get-Date
        $LastWrite = $Now.AddDays(-$days)
        #$Files = Get-ChildItem $TargetFolder -Include *.log,*.blg, *.etl,*.LOG -Recurse | Where {$_.LastWriteTime -le "$LastWrite"}
        $Files = Get-ChildItem "C:\Program Files\Microsoft\Exchange Server\V15\Logging\"  -Recurse | Where-Object {$_.Name -like "*.log" -or $_.Name -like "*.blg" -or $_.Name -like "*.etl"}  | where {$_.lastWriteTime -le "$lastwrite"} | Select-Object FullName  
        foreach ($File in $Files)
            {
               $FullFileName = $File.FullName  
               Write-Host "Deleting file $FullFileName" -ForegroundColor "yellow"; 
                Remove-Item $FullFileName -ErrorAction SilentlyContinue | out-null
            }
       }
Else {
    Write-Host "The folder $TargetFolder doesn't exist! Check the folder path!" -ForegroundColor "red"
    }
}