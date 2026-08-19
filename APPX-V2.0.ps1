#requires -RunAsAdministrator
<#
#=========================================================#
APPX
Debloat Windows

Version : 2.0
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
$Version = "2.0"
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

    Try {
            Get-AppPackage -allusers -Name "Clipchamp.Clipchamp" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.3DBuilder" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.BingWeather" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.GetHelp" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.Getstarted" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.Microsoft3DViewer" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.BingFinance" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.BingSports" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.BingNews" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.BingSearch" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.GamingApp" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.MicrosoftOfficeHub" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.MicrosoftStickyNotes" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.OutlookForWindows" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.ScreenSketch" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.Todos" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.Windows.Photos" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.WindowsAlarms" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.WindowsFeedbackHub" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.Xbox.TCUI" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.XboxGamingOverlay" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.XboxIdentityProvider" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.XboxSpeechToTextOverlay" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.YourPhone" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.ZuneMusic" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "MSTEAMS" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
    }

    catch {
        Write-Host "APPX Removal Failed: $($_.Exception.Message)" -ForegroundColor Red
        }

     Wait-continue
}

function Remove-APPX10 {

    Clear-Host
    Write-Host "Removing Windows 10 APPX packages..." -ForegroundColor Yellow
    Write-Host ""

    Try {
            Get-AppPackage -allusers -Name "Microsoft.ZuneVideo" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.Xbox.TCUI" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.Wallet" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.Microsoft3DViewer" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.MixedReality.Portal" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.ScreenSketch" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.549981C3F5F10" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.Getstarted" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.SkypeApp" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.Office.OneNote" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.MicrosoftStickyNotes" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.People" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.WindowsMaps" | Remove-AppxPackage -ErrorAction SilentlyContinue

            Get-AppPackage -allusers -Name "Microsoft.XboxApp" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.XboxGamingOverlay" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.XboxSpeechToTextOverlay" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.XboxIdentityProvider" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.XboxGameOverlay" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.HEIFImageExtension" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.VP9VideoExtensions" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.BingWeather" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.GetHelp" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.ZuneMusic" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.WindowsAlarms" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.Windows.Photos" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.MicrosoftOfficeHub" | Remove-AppxPackage -ErrorAction SilentlyContinue

            Get-AppPackage -allusers -Name "Microsoft.WindowsFeedbackHub" | Remove-AppxPackage -ErrorAction SilentlyContinue
            
            Get-AppPackage -allusers -Name "Microsoft.YourPhone" | Remove-AppxPackage -ErrorAction SilentlyContinue
    }

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