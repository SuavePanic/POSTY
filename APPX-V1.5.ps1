#requires -RunAsAdministrator
<#
#=========================================================#
APPX
Debloat Windows

Version : 1.5
Author  : SuavePanic

Copyright (c) 2026 SuavePanic.
All Rights Reserved.

Special Thanks:
- Lord Helmet
- BOB (Quality Assurance and One Piece Of Cake!)
- Apollo (Field Testing)

Description:
APPX-Package Remover for Windows 10 and Windows 11.
Features: REMOVES BLOATWARE FROM WINDOWS
#>
#=========================================================#
$AppName = "APPX"
$Version = "1.5"
$LogRoot = "C:\Logs\APPX"
$LogFile = Join-Path $LogRoot "APPX-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"

New-Item -Path $LogRoot -ItemType Directory -Force | Out-Null
Start-Transcript -Path $LogFile -Append | Out-Null

#=======================HEADER============================#
function Write-Header {
    Clear-Host
    Write-Host "========================================"    -ForegroundColor DarkCyan           
    Write-Host "             $AppName v$Version"             -ForegroundColor Green
    Write-Host "         APPX-REMOVER WINDOWS"              -ForegroundColor Green
    Write-Host "========================================"    -ForegroundColor DarkCyan
    Write-Host ""
    Write-Host "Hostname: $env:COMPUTERNAME"
    Write-Host "User:     $env:USERNAME"
    Write-Host "Log:      $LogFile"
    Write-Host ""
}

#======================FUNCTIONS===========================#
function Remove-APPX11 {
    
    Clear-Host
    Write-Host "Removing Windows 11 APPX packages..." -ForegroundColor LightBlue
    Write-Host ""
 
        Get-AppxPackage -Name -AllUsers "Clipchamp.Clipchamp" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.BingNews" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.BingSearch" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.BingWeather" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.GamingApp" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.GetHelp" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.MicrosoftOfficeHub" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.MicrosoftStickyNotes" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.OutlookForWindows" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.ScreenSketch" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.Todos" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.Windows.Photos" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.WindowsAlarms" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.WindowsFeedbackHub" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.Xbox.TCUI" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.XboxGamingOverlay" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.XboxIdentityProvider" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.XboxSpeechToTextOverlay" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.YourPhone" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.ZuneMusic" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.Teams" | Remove-AppxPackage

    Wait-continue

catch {
        Write-Host "APPX Removal Failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

function Remove-APPX10 {

    Clear-Host
    Write-Host "Removing Windows 10 APPX packages..." -ForegroundColor LightBlue
    Write-Host ""

        Get-AppxPackage -Name -AllUsers "Microsoft.Windows.Search" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.ZuneVideo" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.Xbox.TCUI" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.Wallet" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.Microsoft3DViewer" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.MixedReality.Portal" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.XboxApp" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.549981C3F5F10" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.Getstarted" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.SkypeApp" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.Office.OneNote" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.MicrosoftStickyNotes" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.People" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.WindowsMaps" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.XboxGamingOverlay" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.XboxSpeechToTextOverlay" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.XboxIdentityProvider" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.XboxGameOverlay" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.HEIFImageExtension" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.VP9VideoExtensions" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.BingWeather" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.GetHelp" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.ZuneMusic" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.WindowsAlarms" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.Windows.Photos" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.MicrosoftOfficeHub" | Remove-AppxPackage
        Get-AppxPackage -Name -AllUsers "Microsoft.YourPhone" | Remove-AppxPackage

    Wait-continue

    catch { 
        Write-Host "APPX Removal Failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

function Restart-Computer {
    Shutdown -r -t 00
}

function wait-continue {
    Write-Host ""
    Write-Host "Press any key to continue..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

#=========================MENU================================#

do {
    Write-Header
    Write-Host "========== MENU =========="
    Write-Host "1. APPX-REMOVAL-11"   -ForegroundColor Blue
    Write-Host "2. APPX-REMOVAL-10"   -ForegroundColor Blue
    Write-Host "3. Restart-Computer"  -ForegroundColor Blue
    Write-Host "0. Exit"              -ForegroundColor Red
    Write-Host "=========================="

#=========================CHOICE===============================#
$choice = Read-Host "Choose An Option"
    switch ($choice) {

    "1" { Remove-APPX11 }
    "2" { Remove-APPX10 }
    "3" { Restart-Computer}
    "0" { Write-Host "Exiting..." -ForegroundColor Green }
        default {
            Write-Host "Invalid option." -ForegroundColor Yellow
            Wait-Continue}
    }
} until ($choice -eq "0")