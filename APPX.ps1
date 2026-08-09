#requires -RunAsAdministrator
<#
#=========================================================#
APPX
Debloat Windows

Version : 1.7
Author  : SuavePanic

Copyright (c) 2026 SuavePanic.
All Rights Reserved.

Special Thanks:
- Lord Helmet
- BOB (Quality Assurance and One Piece Of Cake!)
- Apollo (Field Testing)
- Chief (B7)

Description:
APPX-Package Remover for Windows 10 and Windows 11.
Features: REMOVES BLOATWARE FROM WINDOWS
#>
#=========================================================#
$AppName = "APPX"
$Version = "1.7"
$LogRoot = "C:\Logs\APPX"
$LogFile = Join-Path $LogRoot "APPX-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"

New-Item -Path $LogRoot -ItemType Directory -Force | Out-Null
Start-Transcript -Path $LogFile -Append | Out-Null

#=======================HEADER============================#
function Write-Header {
    Clear-Host
    Write-Host "========================================"    -ForegroundColor Magenta           
    Write-Host "             $AppName v$Version"             -ForegroundColor Green
    Write-Host "         APPX-REMOVER WINDOWS"              -ForegroundColor Green
    Write-Host "========================================"    -ForegroundColor Magenta
    Write-Host ""
    Write-Host "Hostname: $env:COMPUTERNAME"
    Write-Host "User:     $env:USERNAME"
    Write-Host "Log:      $LogFile"
    Write-Host ""
}

#======================FUNCTIONS===========================#
function Remove-APPX11 {
    
    Clear-Host
        Write-Host "Removing Windows 11 APPX packages..." -ForegroundColor Yellow
        Write-Host ""
 
        Get-AppxPackage -Name "Clipchamp.Clipchamp" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.BingNews" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.BingSearch" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.BingWeather" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.GamingApp" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.GetHelp" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.MicrosoftOfficeHub" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.MicrosoftSolitaireCollection" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.MicrosoftStickyNotes" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.OutlookForWindows" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.ScreenSketch" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.Todos" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.Windows.Photos" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.WindowsAlarms" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.WindowsFeedbackHub" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.Xbox.TCUI" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.XboxGamingOverlay" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.XboxIdentityProvider" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.XboxSpeechToTextOverlay" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.YourPhone" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.ZuneMusic" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.Teams" -AllUsers | Remove-AppxPackage

catch {
        Write-Host "APPX Removal Failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }

    Wait-continue
}

function Remove-APPX10 {

    Clear-Host
    Write-Host "Removing Windows 10 APPX packages..." -ForegroundColor Yellow
    Write-Host ""

        Get-AppxPackage -Name "Microsoft.ZuneVideo" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.Xbox.TCUI" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.Wallet" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.MicrosoftSolitaireCollection" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.Microsoft3DViewer" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.MixedReality.Portal" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.XboxApp" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.549981C3F5F10" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.Getstarted" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.SkypeApp" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.Office.OneNote" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.MicrosoftStickyNotes" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.People" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.WindowsMaps" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.XboxGamingOverlay" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.XboxSpeechToTextOverlay" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.XboxIdentityProvider" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.XboxGameOverlay" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.HEIFImageExtension" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.VP9VideoExtensions" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.BingWeather" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.GetHelp" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.ZuneMusic" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.WindowsAlarms" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.Windows.Photos" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.MicrosoftOfficeHub" -AllUsers | Remove-AppxPackage
        Get-AppxPackage -Name "Microsoft.YourPhone" -AllUsers | Remove-AppxPackage

    catch { 
        Write-Host "APPX Removal Failed: $($_.Exception.Message)" -ForegroundColor Red
    }

    Wait-continue

}

function Restart-Computer {
    Shutdown -r -t 00
}

function wait-continue {
    Write-Host ""
    Write-Host "Press any key to continue..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

#=========================MENU===============================#

do {
    Write-Header
    Write-Host "========== MENU ==========" -ForegroundColor Magenta
    Write-Host "1. APPX-REMOVAL-11"   -ForegroundColor Green
    Write-Host "2. APPX-REMOVAL-10"   -ForegroundColor Green
    Write-Host "3. Restart-Computer"  -ForegroundColor Yellow
    Write-Host "0. Exit"              -ForegroundColor Red
    Write-Host "==========================" -ForegroundColor Magenta

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