<#
                                                          ....                                                          
                                                        ........                                                        
                                                      ............                                                      
                                                   .................                                                    
                                                  ....................                                                  
                                                   ..................                                                   
                                             ..      ..............      ..                                             
                                            .....      ..........      .....                                            
                                          .........     ........     .........                                          
                                        .............     ....     .............                                        
                                      .................          .................                                      
                                    .....................      .....................                                    
                                  ........................    ........................                                  
                                ..........................    ..........................                                
                              ............................    ............................                              
                            ..............................    ..............................                            
                          ................................    ................................   
	        		   	 .................................    .................................	  
						 
											Wartungskript für Server ab WS2k12
						  

#>
$UpdateTime="22:00"
$MaintenanceTime="23:00"

Write-Host "Setup Powershell SSL" -ForegroundColor Yellow
$AllProtocols = [System.Net.SecurityProtocolType]'Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols





$host.ui.RawUI.WindowTitle = "Maintaince Script installing"
if (Get-PackageProvider -ListAvailable -Name NuGet) {
    Write-Host "Nuget Repo bereits installiert" -ForegroundColor Green
} 
else {
    Write-Host "NuGet Repo nicht installiert"
	Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
}


if (Get-Module -ListAvailable -Name PSWindowsUpdate) {
    Write-Host "PSWindowsUpdate Modul bereits installiert" -ForegroundColor Green
} 
else {
    Write-Host "PSWindowsUpdate Modul nicht installiert" -ForegroundColor Yellow
	Install-Module -Name PSWindowsUpdate -Force
}

if (Get-Module -ListAvailable -Name posh-git) {
    Write-Host "posh-git Modul bereits installiert" -ForegroundColor Green
} 
else {
    Write-Host "posh-git Modul nicht installiert" -ForegroundColor Yellow
	Install-Module -Name posh-git -Force
}
if (Get-Module -ListAvailable -Name SqlServer) {
    Write-Host "posh-git Modul bereits installiert" -ForegroundColor Green
} 
else {
    Write-Host "SQLServerClient Modul nicht installiert" -ForegroundColor Yellow
	Install-Module -Name SqlServer -Force
}

if (Test-Path -Path C:\Scripts) {(Write-Host "Ordner Vorhanden" -ForegroundColor Green)} else {Write-Host "Ordner nicht Vorhanden" -ForegroundColor Red; (New-Item C:\Scripts -ItemType directory > $null) ; (Write-Host "Ordner erstellt" -ForegroundColor Green)}

if (!(Test-Path -Path "C:\Program Files\Git")) 
	{(Write-Host "Git nicht vorhanden" -ForegroundColor Green)
	if (!(Test-Path -Path C:\Temp\Git.exe))
	{
	Write-Host "Downloading Git" -ForegroundColor Yellow
	$url = "https://github.com/git-for-windows/git/releases/download/v2.23.0.windows.1/Git-2.23.0-64-bit.exe"
	$path = "C:\Temp\Git.exe"
	if (Test-Path -Path c:\Temp) {(Write-Host "Ordner Vorhanden" -ForegroundColor Green)} else {Write-Host "Ordner nicht Vorhanden" -ForegroundColor Red; (New-Item C:\Temp -ItemType directory > $null) ; (Write-Host "Ordner erstellt" -ForegroundColor Green)}
	$client = New-Object System.Net.WebClient
	$client.DownloadFile($url, $path)
	}
	Write-Host "Installing Git" -ForegroundColor Yellow
	.\Git.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /FORCECLOSEAPPLICATIONS
    new-item -path alias:git -value 'C:\Program Files\Git\bin\git.exe'
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")}
	else {Write-Host "Git bereits installiert" -ForegroundColor Green}

if (Test-Path -Path "C:\Program Files\PowerShell\6") 
	{(Write-Host "Powershell 6 vorhanden" -ForegroundColor Green)
	 $PWSH = "%SystemRoot%\Program Files\PowerShell\6\pwsh.exe"} 
else {Write-Host "Powershell 6 nicht Vorhanden Fallback zu Default Powershell" -ForegroundColor Yellow;
     $PWSH = "%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe"}




if (Get-ScheduledTask -Taskpath "\" -TaskName "Windows Update*" -ErrorAction SilentlyContinue) {
    Write-Host "Vorhandener Task wird entfernt" -ForegroundColor Yellow
	Get-ScheduledTask -Taskpath "\" -TaskName "Windows Update*" | Unregister-ScheduledTask -confirm:$false
} 
else {
    Write-Host "WartungsTask nicht installiert"
	
}


Write-Host "Downloading Scripts from Github Repo" -ForegroundColor Green
start-process powershell "git clone https://github.com/almir1904/AutoWindowsUpdate.git C:\Scripts\UpdateService"
while (!(Test-Path "C:\Scripts\UpdateService\Install-Updates.ps1")) { Start-Sleep 10 }
Write-Host "Please edit the Settings.ps1 File if needed and press enter"
[void][System.Console]::ReadKey($FALSE)
if ((Test-Path -Path "C:\Scripts\UpdateService\Settings.ps1")) 
	{Write-Host "Settings File vorhanden" -ForegroundColor Green
	.\Settings.ps1}


Write-Host "Install Update Task" -ForegroundColor Yellow
$argument = '-NonInteractive -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\UpdateService\Install-Updates.ps1"'
$action = New-ScheduledTaskAction -Execute $PWSH -Argument $argument
$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$trigger = New-ScheduledTaskTrigger -Weekly -At $MaintenanceTime -DaysOfWeek Saturday
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger
Register-ScheduledTask "Windows Update Maintenance Script" -InputObject $task -Force


$taskName = "Wartung"
$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName }

if($taskExists) {
   Disable-ScheduledTask -Taskname "Wartung"
   Write-Host "Disabled old Wartung Task" -ForegroundColor Yellow
} else {
   Write-Host "No old Wartung Task" -ForegroundColor Yellow
}

$taskName = "start wuauserv"
$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName }

if($taskExists) {
   Disable-ScheduledTask -Taskname "Wartung"
   Write-Host "Disabled old start wuauserv Task" -ForegroundColor Yellow
} else {
   Write-Host "No old start wuauserv Task" -ForegroundColor Yellow
}

$taskName = "stop wuauserv"
$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName }

if($taskExists) {
	Disable-ScheduledTask -Taskname "stop wuauserv"
	Write-Host "Disabled old stop wuauserv Task" -ForegroundColor Yellow   
} else {
	Write-Host "No old stop wuauserv Task" -ForegroundColor Yellow
}

if (Get-ScheduledTask -Taskpath "\" -TaskName "UpdateService*" -ErrorAction SilentlyContinue) {
    Write-Host "Vorhandener Task wird entfernt" -ForegroundColor Yellow
	Get-ScheduledTask -Taskpath "\" -TaskName "UpdateService*" | Unregister-ScheduledTask -confirm:$false
} 
else {
    Write-Host "UpdateTask nicht installiert"
	
}


Write-Host "Install Script Upgrade Task" -ForegroundColor Green
$argument = '-NonInteractive -NoLogo -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\UpdateService\Update-Scripts.ps1"'
$action = New-ScheduledTaskAction -Execute $PWSH -Argument $argument -WorkingDirectory "C:\Scripts\UpdateService"
$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$trigger = New-ScheduledTaskTrigger -Daily -At $UpdateTime
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger
Register-ScheduledTask "UpdateService Script " -InputObject $task -Force


