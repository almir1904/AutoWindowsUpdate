$AllUpdates = Get-WsusUpdate -Approval AnyExceptDeclined -Classification All -Status Any

$UnAppUpdates = Get-WsusUpdate -Approval Unapproved
$ARMUpdates = $AllUpdates | where { $_.update.Title -like "*ARM64*" } 
$WinClientUpdates = $AllUpdates | where { $_.update.Title -like "*Windows 7*" -or $_.Update.Title -like "*Windows 8*" -or $_.Update.Title -like "*Windows Server 200*" -or $_.Update.Title -like "*Windows XP*" -or $_.Update.Title -like "*Windows Vista*" -or $_.Update.Title -like "*Windows Server 2008*" -or $_.Update.Title -like "*Windows Server 2012*" } | where { $_.update.Title -notlike "*Windows Server 2012 R2*" } | where { $_.Update.Title -notlike "*Windows Server 2016*" } | where { $_.Update.ProductTitles -notcontains "Windows Server 2016" -and $_.Update.ProductTitles -notcontains "Windows Server 2012 R2" -and $_.Update.ProductTitles -notcontains "Windows 10" }
$Otherupdates = $AllUpdates | where { $_.update.Title -like "*Windows 10 Version *" -or $_.update.Title -like "*Feature*On*Demand*"} | where { $_.update.Title -notlike "*X64*" } | where { $_.update.Title -notlike "*AMD64*" } 
$ItaniumUpdates = $AllUpdates | where { $_.update.Title -like "*Itanium*" -or $_.update.Title -like "*IA64*"} 
$LanguageFeatureOnDemand = $AllUpdates | where { $_.update.Title -like "*LanguageFeatureOnDemand*" } 
$Insider = $AllUpdates | where { $_.update.Title -like "*Windows-Insider*" } 

$UnAppUpdates | where { $_.Update.Title -like "*Preview*" } | Deny-WsusUpdate -Verbose
$UnAppUpdates | where { $_.Update.Title -like "*Vorabversion*" } | Deny-WsusUpdate -Verbose
$UnAppUpdates | where { $_.Update.Title -like "*Vorschau*" } | Deny-WsusUpdate -Verbose


$AllUpdates | where { $_.Update.Title -like "*Windows 10*N,*" } | Deny-WsusUpdate -Verbose
$AllUpdates | where { $_.Update.Title -like "*Windows 10*N version*" } | Deny-WsusUpdate -Verbose
$AllUpdates | where { $_.Update.Title -like "*Windows 10 Education,*" } | Deny-WsusUpdate -Verbose
$AllUpdates | where { $_.Update.Title -like "*InfoPath*" } | Deny-WsusUpdate -Verbose
$AllUpdates | where { $_.Update.ProductTitles -like "*Dictionary*" } | Deny-WsusUpdate -Verbose
$AllUpdates | where { $_.Update.ProductTitles -like "*Windows Embedded*" } | Deny-WsusUpdate -Verbose
$AllUpdates | where { $_.Update.ProductFamilyTitles -eq "Forefront" }| Deny-WsusUpdate -Verbose
$AllUpdates | where { $_.Update.ProductFamilyTitles -like "Windows" } | where { $_.Update.ProductTitles -contains "Windows XP" -or $_.Update.ProductTitles -contains "Windows Server 2003" -or $_.Update.ProductTitles -contains "Windows Server 2008" -or $_.Update.ProductTitles -contains "Windows Vista" -or $_.Update.ProductTitles -contains "Windows 7" -or $_.Update.ProductTitles -contains "Windows 8.1" -or $_.Update.ProductTitles -contains "Windows 8" } | where { $_.Update.ProductTitles -notcontains "Windows Server 2016" -and $_.Update.ProductTitles -notcontains "Windows Server 2012 R2" -and $_.Update.ProductTitles -notcontains "Windows 10" } | Deny-WsusUpdate -Verbose
$AllUpdates | where { $_.Update.ProductFamilyTitles -eq "Microsoft Application Virtualization" } | Deny-WsusUpdate -Verbose
$AllUpdates | where { $_.Update.Title -like "*Funktionsupdate* en-us x86*" } | Deny-WsusUpdate -Verbose
$AllUpdates | where { $_.Update.Title -like "*Preview*" } | Deny-WsusUpdate -Verbose
$AllUpdates | where { $_.Update.Title -like "*Vorabversion*" } | Deny-WsusUpdate -Verbose
$AllUpdates | where { $_.Update.Title -like "*Vorschau*" } | Deny-WsusUpdate -Verbose

$AllUpdates | where { $_.update.Title -like "*Windows 10 Version 1503*"} | Deny-WsusUpdate -Verbose 
$AllUpdates | where { $_.update.Title -like "*Windows 10 Version 1507*"} | Deny-WsusUpdate -Verbose 
$AllUpdates | where { $_.update.Title -like "*Windows 10 Version 1511*"} | Deny-WsusUpdate -Verbose 
$AllUpdates | where { $_.update.Title -like "*Windows 10 Version 1607*"} | Deny-WsusUpdate -Verbose 
$AllUpdates | where { $_.update.Title -like "*Windows 10 Version 1703*"} | Deny-WsusUpdate -Verbose
$AllUpdates | where { $_.update.Title -like "*Windows 10 Version 1709*"} | Deny-WsusUpdate -Verbose
$AllUpdates | where { $_.update.Title -like "*Windows 10 Version 1803*"} | Deny-WsusUpdate -Verbose 
$AllUpdates | where { $_.update.Title -like "*Windows 10 Version 1809*"} | Deny-WsusUpdate -Verbose 
$AllUpdates | where { $_.update.Title -like "*Windows 10 Version 1903*"} | Deny-WsusUpdate -Verbose
$AllUpdates | where { $_.update.Title -like "*Windows 10 Version 1909*"} | Deny-WsusUpdate -Verbose


$AnyUpdates = Get-WsusUpdate

$AnyUpdates | where { $_.update.Title -like "*Windows 10 Version 1503*"} | Deny-WsusUpdate -Verbose 
$AnyUpdates | where { $_.update.Title -like "*Windows 10 Version 1507*"} | Deny-WsusUpdate -Verbose 
$AnyUpdates | where { $_.update.Title -like "*Windows 10 Version 1511*"} | Deny-WsusUpdate -Verbose 
$AnyUpdates | where { $_.update.Title -like "*Windows 10 Version 1607*"} | Deny-WsusUpdate -Verbose 
$AnyUpdates | where { $_.update.Title -like "*Windows 10 Version 1703*"} | Deny-WsusUpdate -Verbose
$AnyUpdates | where { $_.update.Title -like "*Windows 10 Version 1709*"} | Deny-WsusUpdate -Verbose
$AnyUpdates | where { $_.update.Title -like "*Windows 10 Version 1803*"} | Deny-WsusUpdate -Verbose 
$AnyUpdates | where { $_.update.Title -like "*Windows 10 Version 1809*"} | Deny-WsusUpdate -Verbose 
$AnyUpdates | where { $_.update.Title -like "*Windows 10 Version 1903*"} | Deny-WsusUpdate -Verbose
$AnyUpdates | where { $_.update.Title -like "*Windows 10 Version 1909*"} | Deny-WsusUpdate -Verbose


$AnyUpdates | where { $_.update.Title -like "*Office 2007*"} | Deny-WsusUpdate -Verbose 
$AnyUpdates | where { $_.update.Title -like "*Office 2010*"} | Deny-WsusUpdate -Verbose 
$AnyUpdates | where { $_.update.Title -like "*Office 2013*"} | Deny-WsusUpdate -Verbose 








$Otherupdates | Deny-WsusUpdate -Verbose
$ARMUpdates | Deny-WsusUpdate -Verbose
$WinClientUpdates | Deny-WsusUpdate -Verbose
$ItaniumUpdates | Deny-WsusUpdate -Verbose
$LanguageFeatureOnDemand | Deny-WsusUpdate -Verbose
$Insider | Deny-WsusUpdate -Verbose

Write-Host "Nuke WSUS Files"
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer()
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | Out-Null
$wsus.getupdates() | Where {$_.isdeclined -match 'true'} | ForEach-Object { $wsus.DeleteUpdate($_.Id.UpdateID); Write-Host $_.Title entfernt } 



