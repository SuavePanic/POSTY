#requires -RunasAdministrator
<#

------------------------------------------
Appx-Package-Removal

Version : 1.0.0
Author  : Lone-Star/Lord-Helmet
Project : APPX-REMOVER
------------------------------------------
Copyright (c) 2026 Lone-Star.
All Rights Reserved.
Special Thanks:
- Lord Helmet
#>

$AppsToRemove = @(
    "Microsoft.Teams"
    "Microsoft.BingSearch"
    "Microsoft.Todos"
    "Microsoft.YourPhone"
    "Microsoft.WindowsCamera"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.BingWeather"
    "Microsoft.ZuneMusic"
    "Microsoft.WindowsAlarms"
    "Microsoft.GetHelp"
    "Microsoft.BingNews"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.XboxGameCallableUI"
    "Microsoft.Xbox.TCUI" 
    "Microsoft.ScreenSketch"
    "Clipchamp.Clipchamp"
    "Microsoft.GamingApp"
)

foreach ($App in $AppsToRemove) {
    Get-AppxPackage -Name $App -AllUsers |
        Remove-AppxPackage -AllUsers
}

Write-Host "Apps Removed..." -ForegroundColor Green
Write-Host ""
Write-Host ""
Write-Host "Restarting PC in 3 seconds..." -ForegroundColor Blue

shutdown.exe /r /t 3


