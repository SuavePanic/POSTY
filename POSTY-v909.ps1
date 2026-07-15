#requires -RunAsAdministrator
<#
===============================================================================
POSTY-CONFIG
Windows Deployment Toolkit

Version : 909
Author  : SuavePanic
Project : https://github.com/SuavePanic/POSTY

Copyright (c) 2026 SuavePanic.
All Rights Reserved.

Special Thanks:
- Lord Helmet
- BOB (Quality Assurance and One Piece Of Cake!)
- Apollo (Field Testing... eventually)

Description:
Windows deployment toolkit for Windows 10 and Windows 11.
===============================================================================

Features:
- Show-PCSystemInfo
- Rename computer
- Disable Indexing
- Power Management
- Configure-Network
- Set Time and Date
- Join Domain
- Install-WinGet
- Install-APPS
- Install-Activation
- Windows-Updates
- System-Cleanup
- Reboot
#>

$AppName = "POSTY"
$Version = "909"
$LogRoot = "C:\Logs\POSTY"
$LogFile = Join-Path $LogRoot "POSTY-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"

New-Item -Path $LogRoot -ItemType Directory -Force | Out-Null
Start-Transcript -Path $LogFile -Append | Out-Null

#======================================HEADER=============================================#
function Write-Header {
    Clear-Host
    Write-Host "========================================"   -ForegroundColor Yellow           
    Write-Host "            $AppName v$Version"             -ForegroundColor Green
    Write-Host "       -WINDOWS POST-INSTALL TOOL-"         -ForegroundColor Green
    Write-Host "========================================"   -ForegroundColor Yellow
    Write-Host "  Install Winget Before Installing APPS"    -ForegroundColor Green
    Write-Host "           On Windows 10 Only"              -ForegroundColor Green
    Write-Host "+++++++++++++++++++++++++++++++++++++++++"  -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Hostname: $env:COMPUTERNAME"
    Write-Host "User:     $env:USERNAME"
    Write-Host "Log:      $LogFile"
    Write-Host ""
}

#================================SYSTEM-INFORMATION=======================================#
function Show-PCSystemInfo {

    Clear-Host

    Write-Host "=================================" -ForegroundColor Yellow
    Write-Host "        SYSTEM INFORMATION"        -ForegroundColor Green
    Write-Host "=================================" -ForegroundColor Yellow
    Write-Host ""

    systeminfo

    Wait-PCContinue
}
#==================================RENAME-COMPUTER========================================#

function Rename-PCComputer {
    Write-Header
    Write-Host "Rename Computer" -ForegroundColor Yellow
    $newName = Read-Host "Enter new computer name"

    if ([string]::IsNullOrWhiteSpace($newName)) {
        Write-Host "Computer name was blank. No change Made."       -ForegroundColor Red
        Wait-PCContinue
        return
    }

    try {
        Rename-Computer -NewName $newName -Force -ErrorAction Stop
        Write-Host "Computer renamed to $newName. Reboot Required." -ForegroundColor Green
        
        Enable-PCAutoStart output | Out-Null 

        Confirm-PCReboot -Reason "Computer Renamed Successfully."
        }
        
    catch {
        Write-Host "Rename failed: $($_.Exception.Message)"         -ForegroundColor Red
    }
}

#=====================================DISABLE-INDEXING====================================#
function Disable-PCIndexing {
    Write-Header
    Write-Host "Disable Indexing on C: Drive" -ForegroundColor Yellow

    try {
        Write-Host "Disabling indexing on C: drive..."
        Stop-Service WSearch -Force -ErrorAction SilentlyContinue
Set-Service WSearch -StartupType Disabled

$volume = Get-CimInstance Win32_Volume -Filter "DriveLetter='C:'"

if ($volume) {
    Set-CimInstance -InputObject $volume -Property @{
        IndexingEnabled = $false
    } | Out-Null

    Write-Host "Indexing disabled for drive C:" -ForegroundColor Green
}
else {
    Write-Host "Drive C: not found." -ForegroundColor Red
}

    }
    catch {
        Write-Host "Failed to disable indexing: $($_.Exception.Message)" -ForegroundColor Red
    }

    Wait-PCContinue
}

#=====================================POWER-MGMT===========================================#
function Show-PCPowerManagement {

    do {
        Write-Host "Power Management" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "1. Set Balanced Power Plan"
        Write-Host "2. Set High Performance Power Plan"
        Write-Host "3. Disable Sleep"
        Write-Host "4. Disable Monitor Timeout"
        Write-Host "0. Return"
        Write-Host ""

        $choice = Read-Host "Select an option"

        switch ($choice) {

            "1" {
                powercfg /setactive SCHEME_BALANCED
                Write-Host "Balanced power plan enabled." -ForegroundColor Green
                Wait-PCContinue
            }

            "2" {
                powercfg /setactive SCHEME_MIN
                Write-Host "High Performance power plan enabled." -ForegroundColor Green
                Wait-PCContinue
            }

            "3" {
                powercfg /change standby-timeout-ac 0
                powercfg /change standby-timeout-dc 0
                Write-Host "Sleep disabled." -ForegroundColor Green
                Wait-PCContinue
            }

            "4" {
                powercfg /change monitor-timeout-ac 0
                powercfg /change monitor-timeout-dc 0
                Write-Host "Monitor timeout disabled." -ForegroundColor Green
                Wait-PCContinue
            }

            "0" {
                return
            }

            default {
                Write-Host "Invalid selection." -ForegroundColor Red
                Wait-PCContinue
            }
        }

    } while ($true)
}

#=====================================NETWORK=============================================#
function Set-PCNetwork {
    Write-Header
    Write-Host "Configure Network" -ForegroundColor Yellow
    Get-NetAdapter | Where-Object Status -eq "Up" | Format-Table Name, InterfaceDescription, Status, LinkSpeed

    $adapter = Read-Host "Enter adapter name"
    if ([string]::IsNullOrWhiteSpace($adapter)) {
        Write-Host "Adapter name was blank. No change made." -ForegroundColor Red
        Wait-PCContinue
        return
    }

    Write-Host ""
    Write-Host "1. Set DHCP"
    Write-Host "2. Set Static IP"
    $choice = Read-Host "Select option"

    try {
        if ($choice -eq "1") {
            Set-NetIPInterface -InterfaceAlias $adapter -Dhcp Enabled -ErrorAction Stop
            Set-DnsClientServerAddress -InterfaceAlias $adapter -ResetServerAddresses -ErrorAction Stop
            Write-Host "DHCP enabled on $adapter." -ForegroundColor Green
            Start-Process ipconfig /release -wait
            Start-Process ipconfig /renew -wait
            Start-Process ipconfig /flushdns -wait
            Start-Process ipconfig /registerdns -wait
            Write-Host "Network configuration completed." -ForegroundColor Green 
        }
        elseif ($choice -eq "2") {
            $ip = Read-Host "IP Address"
            $prefix = Read-Host "Prefix Length, example 24"
            $gateway = Read-Host "Default Gateway"
            $dns = Read-Host "DNS Servers comma separated, example 192.168.1.10,8.8.8.8"

            Get-NetIPAddress -InterfaceAlias $adapter -AddressFamily IPv4 -ErrorAction SilentlyContinue |
                Remove-NetIPAddress -Confirm:$false -ErrorAction SilentlyContinue

            New-NetIPAddress -InterfaceAlias $adapter -IPAddress $ip -PrefixLength $prefix -DefaultGateway $gateway -ErrorAction Stop
            Set-DnsClientServerAddress -InterfaceAlias $adapter -ServerAddresses ($dns -split ",") -ErrorAction Stop
            Write-Host "Static IP configured on $adapter." -ForegroundColor Green
        }
        else {
            Write-Host "Invalid selection." -ForegroundColor Red
        }
    }
    catch {
        Write-Host "Network configuration failed: $($_.Exception.Message)" -ForegroundColor Red
    }

    Wait-PCContinue   
}

#=====================================DATE/TIME===========================================#
function Open-PCDateTimeSettings {
    
    Write-Host "Opening Date & Time Settings..." -ForegroundColor Yellow
    Start-Process "ms-settings:dateandtime"
    Wait-PCContinue
}

#=====================================JOIN-DOMAIN=========================================#
function Join-PCDomain {
    Write-Header
    Write-Host "Join Computer to Domain" -ForegroundColor Yellow

    $domainName = Read-Host "Enter domain name"
    $ouPath = Read-Host "Enter OU path or press Enter to skip"

    if ([string]::IsNullOrWhiteSpace($domainName)) {
        Write-Host "Domain name was blank. No change made." -ForegroundColor Red
        Wait-PCContinue
        return
    }

    try {
        $cred = Get-Credential -Message "Enter domain credentials"

        if ([string]::IsNullOrWhiteSpace($ouPath)) {
            Add-Computer -DomainName $domainName -Credential $cred -Force -ErrorAction Stop
        }
        else {
            Add-Computer -DomainName $domainName -OUPath $ouPath -Credential $cred -Force -ErrorAction Stop
        }

        Write-Host "Computer joined to domain successfully." -ForegroundColor Green
        Write-Host "A reboot is required." -ForegroundColor Yellow
        Confirm-PCReboot -Reason "Domain Join Successful."        
    }
    catch {
        Write-Host "Domain join failed: $($_.Exception.Message)" -ForegroundColor Red
    }

}

#==================================INSTALL-WINGET=========================================#
function Install-PCWinget {
    Write-Header
    Write-Host "Install WinGet" -ForegroundColor Yellow
    Write-Host ""

    try {
        Write-Host "Installing WinGet PowerShell Module..." -ForegroundColor Cyan

        Install-PackageProvider -Name NuGet -Force | Out-Null

        Set-PSRepository `
            -Name PSGallery `
            -InstallationPolicy Trusted `
            -ErrorAction SilentlyContinue

        Install-Module `
            -Name Microsoft.WinGet.Client `
            -Force `
            -Repository PSGallery `
            -Scope AllUsers `
            -ErrorAction Stop | Out-Null

        Write-Host "Repairing WinGet package manager..." -ForegroundColor Cyan
        Write-Host "This May Crash But It's Normal..."   -ForegroundColor Cyan

        Repair-WinGetPackageManager -AllUsers | Out-Null

        Write-Host ""
        Write-Host "WinGet install/fix completed successfully."         -ForegroundColor Green
    }
    catch {
        Write-Host ""
        Write-Host "WinGet install/fix failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}
#===================================INSTALL-APPS==========================================#
function Install-PCApps {
    Write-Header
    Write-Host "Install Apps" -ForegroundColor Yellow
    
    Write-Host "Installing 7Zip..."
    WinGet Install 7zip.7zip --silent -h --accept-package-agreements --accept-source-agreements

    Write-Host "Installing APS.exe..."
    WinGet Install Famatech.AdvancedIPScanner --silent -h --accept-package-agreements --accept-source-agreements

    Write-Host "Installing AdobeReader..."
    WinGet Install Adobe.Acrobat.Reader.64-bit --silent -h --accept-package-agreements --accept-source-agreements

    Write-Host "Installing Putty..."
    WinGet Install PuTTY.PuTTY --silent -h --accept-package-agreements --accept-source-agreements

    Write-Host "Installing Powershell 7..."
    WinGet Install Microsoft.Powershell --silent -h --accept-package-agreements --accept-source-agreements

    Write-Host "Installing Winfile..."
    WinGet Install Microsoft.WinFile --silent -h --accept-package-agreements --accept-source-agreements

    Write-Host "Installing Office..."
    WinGet Install Microsoft.Office --silent -h --accept-package-agreements --accept-source-agreements

    Write-Host "Installing WRCFree..."
    WinGet Install WiseCleaner.WiseRegistryCleaner --silent -h --accept-package-agreements --accept-source-agreements

    Write-Host "Application Updates..."
    WinGet Upgrade --all --silent -h --accept-package-agreements --accept-source-agreements

    Write-Host "Application Install Task Complete." -ForegroundColor Green
    Wait-PCContinue
}

#===================================INSTALL-GIT&VSCode======================================#
function Install-PCGit {
    Write-Host "Installing git..."
    WinGet Install Git.Git --silent -h --accept-package-agreements --accept-source-agreements

    Write-Host "Setting up Git..." 
    Write-Host "Configuring Git Username&Email..." 
    git config --global user.name "SuavePanic" 
    git config --global user.email "zjaco1@gmail.com"
    Write-Host ""
    Write-Host ""
    Write-Host "Creating C:\VS folder for Git Repositories..." 
    mkdir C:\VS
    Write-Host "Cloning Git Repositories..." 
    git clone https://github.com/SuavePanic/POSTY.git
    git clone https://github.com/SuavePanic/DEV.git
    git clone https://github.com/SuavePanic/MISC.git
    git clone https://github.com/SuavePanic/BETA.git
    Write-Host ""
    Write-Host "Git Install Complete" -ForegroundColor Green
}

function Install-PCVSCode {
    Write-Host "Installing Visual Studio Code..."
    WinGet Install microsoft.visualstudiocode --silent -h --accept-package-agreements --accept-source-agreements
    Write-Host "Setting up Visual Studio Code Extensions..."
    code --install-extension ms-vscode.PowerShell 
    code --install-extension usernamehw.errorlens 
    code --install-extension yzhang.markdown-all-in-one
    code --install-extension eamodio.gitlens
    Write-Host "Visual Studio Code Install Complete" -ForegroundColor Green
}

#=====================================ACTIVATE-WINDOWS====================================#
function Install-Activation {
    Write-Host "Activate Windows and Office" -ForegroundColor Yellow

    try { 
        Write-Host "Activating Windows/Office..."
        Invoke-WebRequest https://get.activated.win | Invoke-Expression
    }
    catch {
        Write-Host "Activation failed: $($_.Exception.Message)" -ForegroundColor Red
    }
       Wait-PCContinue 
}

#==================================WINDOWS-UPDATE=========================================#
 function Invoke-PCWindowsUpdates {
    Write-Header
    Write-Host "Run Windows Updates" -ForegroundColor Yellow

    try {
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ErrorAction SilentlyContinue | Out-Null
        Install-Module PSWindowsUpdate -Force -Confirm:$false -ErrorAction Stop | Out-Null
        Import-Module PSWindowsUpdate -ErrorAction Stop | Out-Null
        Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot
        Confirm-PCReboot -Reason "Windows Updates Installed Successfully."
    }
    catch {
        Write-Host "Windows Update Failed: $($_.Exception.Message)" -ForegroundColor Red
    }

}

#=====================================SYSTEM-CLEANUP======================================#
function Invoke-PCCleanup {
    Write-Header
    Write-Host "System Cleanup" -ForegroundColor Yellow

    try {
        Write-Host "Cleaning Temp Folders..."
        Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

        Write-Host "Running Disk Cleanup component cleanup..."
        DISM /Online /Cleanup-Image /StartComponentCleanup

        Write-Host "Running Disk Cleanup for System Files..."
        Cleanmgr /sageset:1 | Out-Null
        $cleanmgrArgs = "/sagerun:1"
        Start-Process "cleanmgr.exe" -ArgumentList $cleanmgrArgs -Wait

        Write-Host "Startup Cleanup..."
        Start-Process MSCONFIG.exe -wait

        Write-Host "Registry Cleanup - Removing old Windows Update entries..."
        Start-Process "C:\Program Files (x86)\Wise\Wise Registry Cleaner\WiseRegCleaner.exe" -Wait

        Write-Host "Cleanup complete." -ForegroundColor Green
    }
    catch {
        Write-Host "Cleanup failed: $($_.Exception.Message)" -ForegroundColor Red
    }

    Wait-PCContinue
}

function Invoke-PC909 {

    Write-Header

    Write-Host ""
    Write-Host "FEDERATION ACCESS CODE ACCEPTED" -ForegroundColor Green
    Write-Host ""
    Write-Host "Initializing Legacy Systems..." -ForegroundColor Yellow
    Start-Sleep 1

    Write-Host ""
    Write-Host "Connecting to BOB..." -ForegroundColor Cyan
    Start-Sleep 1

    Write-Host ""
    Write-Host "Bridge Status: ONLINE" -ForegroundColor Green
    Write-Host "Chief Reynolds: In Breakroom" -ForegroundColor Yellow
    Write-Host "Apollo: Installing AOL..." -ForegroundColor Yellow
    Write-Host "BOB: Monitoring Clipboard..." -ForegroundColor Magenta

    Write-Host ""
    Write-Host "Special Thanks:" -ForegroundColor Cyan
    Write-Host "  Lord Helmet"
    Write-Host "  BOB"
    Write-Host "  Apollo"
    Write-Host ""
    Write-Host "For the One Piece of Cake." -ForegroundColor Green
    Write-Host "Code-909 Executed Successfully." -ForegroundColor Blue

    Wait-PCContinue
}

#==================================UTILITY-FUNCTIONS======================================#
function Confirm-PCReboot {

    param(
        [string]$Reason = "Changes require a reboot."
    )

    Write-Host ""
    Write-Host $Reason -ForegroundColor Yellow
    Write-Host ""

    $Reboot = Read-Host "Reboot now? (Y/N)"

    if ($Reboot.Trim().ToUpper() -eq "Y") {
        Write-Host "Rebooting now..." -ForegroundColor Red
        Start-Sleep -Seconds 2
        Restart-Computer -Force
    }
    else {
        Write-Host "Reboot skipped." -ForegroundColor Cyan
        Wait-PCContinue
    }
}

function Wait-PCContinue {
    Read-Host "Press Enter to continue"
}

function Restart-PCComputer {
    Write-Header
    Write-Host "Restart Computer" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Computer will restart in 3 seconds..." -ForegroundColor Red

    shutdown.exe /r /t 3
}
    
function Enable-PCAutoStart {

    $ScriptPath = $PSCommandPath
if (-not $ScriptPath) {
    $ScriptPath = $MyInvocation.MyCommand.Path
}

    $Action = New-ScheduledTaskAction `
        -Execute "powershell.exe" `
        -Argument "-ExecutionPolicy Bypass -File `"$ScriptPath`""

    $Trigger = New-ScheduledTaskTrigger -AtLogOn

    Register-ScheduledTask `
        -TaskName "PostyConfigAutoStart" `
        -Action $Action `
        -Trigger $Trigger `
        -RunLevel Highest `
        -Force
}

function Disable-PCAutoStart {

    Unregister-ScheduledTask `
        -TaskName "PostyConfigAutoStart" `
        -Confirm:$false `
        -ErrorAction SilentlyContinue
}

#=====================================MENU==============================================#
do {
    Write-Header
    Write-Host "1. Show-SystemInfo"
    Write-Host "2. Rename-Computer"
    Write-Host "3. Disable-Indexing"
    Write-Host "4. Power-Management"
    Write-Host "5. Configure-Network"
    Write-Host "6. Set-Date/Time"
    Write-Host "7. Join-Domain"
    Write-Host "8. Install-Winget"
    Write-Host "9. Install-Apps"
    Write-Host "10. Install-Git"
    Write-Host "11. Install-VSCode"
    Write-Host "12. Activation"
    Write-Host "13. Windows-Updates"
    Write-Host "14. System-Cleanup"
    Write-Host "15. Restart-Computer"
    Write-Host "0. Exit"
    Write-Host ""

    $choice = Read-Host "Select an option"

    switch ($choice) {
        "1" { Show-PCSystemInfo }
        "2" { Rename-PCComputer }
        "3" { Disable-PCIndexing }
        "4" { Show-PCPowerManagement }
        "5" { Set-PCNetwork }
        "6" { Open-PCDateTimeSettings }
        "7" { Join-PCDomain }
        "8" { Install-PCWinget }
        "9" { Install-PCApps }
        "10" { Install-PCGit }
        "11" { Install-PCVSCode }
        "12" { Install-Activation }
        "13" { Invoke-PCWindowsUpdates }
        "14" { Invoke-PCCleanup }
        "15" { Restart-PCComputer }
        "909" { Invoke-PC909 }
        "0" { Disable-PCAutoStart
              Write-Host "Exiting $AppName..." -ForegroundColor Yellow }
        default {
            Write-Host "Invalid option." -ForegroundColor Red
            Wait-PCContinue
        }
    }
} while ($choice -ne "0")

Stop-Transcript | Out-Null
