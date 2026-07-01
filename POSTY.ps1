#requires -RunAsAdministrator
<#
===============================================================================
POSTY-CONFIG
Windows Deployment Toolkit

Version : 1.9.0
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
- Configure Static IP or DHCP
- Set Time and Date
- Join Domain
- Install WinGet
- Install APPS
- Install-Activation
- Run Windows Updates
- System Cleanup
- Reboot
#>

$AppName = "POSTY-CONFIG"
$Version = "1.9.0"
$LogRoot = "C:\Logs\POSTY-CONFIG"
$LogFile = Join-Path $LogRoot "POSTY-CONFIG-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"

New-Item -Path $LogRoot -ItemType Directory -Force | Out-Null
Start-Transcript -Path $LogFile -Append | Out-Null

function Wait-PCContinue {
    Read-Host "Press Enter To Continue"
}

function Write-Header {
    Clear-Host
    Write-Host "======================================================" -ForegroundColor Yellow           
    Write-Host "                  $AppName v$Version" -ForegroundColor Green
    Write-Host "              -WINDOWS POST-INSTALL TOOL-" -ForegroundColor Green
    Write-Host "======================================================" -ForegroundColor Yellow
    Write-Host "  Install Winget Before App Installation For Win-10" -ForegroundColor Green
    Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Hostname: $env:COMPUTERNAME"
    Write-Host "User:     $env:USERNAME"
    Write-Host "Log:      $LogFile"
    Write-Host ""
}

function Test-Admin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Show-PCSystemInfo {

    Clear-Host

    Write-Host "=================================" -ForegroundColor Yellow
    Write-Host "        SYSTEM INFORMATION"          -ForegroundColor Green
    Write-Host "=================================" -ForegroundColor Yellow
    Write-Host ""

    systeminfo

    Wait-PCContinue
}

function Rename-PCComputer {
    Write-Header
    Write-Host "Rename Computer" -ForegroundColor Yellow
    $newName = Read-Host "Enter New Computer Name"

    if ([string]::IsNullOrWhiteSpace($newName)) {
        Write-Host "Computer name was blank. No change made." -ForegroundColor Red
        Wait-PCContinue
        return
    }

    try {
        Rename-Computer -NewName $newName -Force -ErrorAction Stop
        Write-Host "Computer renamed to $newName. Reboot required." -ForegroundColor Green
        Confirm-PCReboot -Reason "Computer renamed successfully."
        }
        
    catch {
        Write-Host "Rename failed: $($_.Exception.Message)" -ForegroundColor Red
    }

    Wait-PCContinue
}

function Disable-Indexing {
    Write-Header
    Write-Host "Disable Indexing Drive C:" -ForegroundColor Yellow

    try {
        Write-Host "Disabling indexing on C: drive..."
        Stop-Service WSearch -Force -ErrorAction SilentlyContinue
Set-Service WSearch -StartupType Disabled

$volume = Get-CimInstance Win32_Volume -Filter "DriveLetter='C:'"

if ($volume) {
    Set-CimInstance -InputObject $volume -Property @{
        IndexingEnabled = $false
    } | Out-Null

    Write-Host "Indexing Disabled For Drive C:" -ForegroundColor Green
}
else {
    Write-Host "Drive C: Not Found." -ForegroundColor Red
}

    }
    catch {
        Write-Host "Failed Disable Indexing: $($_.Exception.Message)" -ForegroundColor Red
    }

    Wait-PCContinue
}

function Show-PCPowerManagement {

    do {
        Write-Header
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
                Write-Host "Balanced power Plan Enabled." -ForegroundColor Green
                Wait-PCContinue
            }

            "2" {
                powercfg /setactive SCHEME_MIN
                Write-Host "High Performance Power Plan." -ForegroundColor Green
                Wait-PCContinue
            }

            "3" {
                powercfg /change standby-timeout-ac 0
                powercfg /change standby-timeout-dc 0
                Write-Host "Sleep Disabled." -ForegroundColor Green
                Wait-PCContinue
            }

            "4" {
                powercfg /change monitor-timeout-ac 0
                powercfg /change monitor-timeout-dc 0
                Write-Host "Monitor Timeout Disabled." -ForegroundColor Green
                Wait-PCContinue
            }

            "0" {
                return
            }

            default {
                Write-Host "Invalid Selection." -ForegroundColor Red
                Wait-PCContinue
            }
        }

    } while ($true)
}

function Set-PCNetwork {
    Write-Header
    Write-Host "Configure Network" -ForegroundColor Yellow
    Get-NetAdapter | Where-Object Status -eq "Up" | Format-Table Name, InterfaceDescription, Status, LinkSpeed

    $adapter = Read-Host "Enter adapter name"
    if ([string]::IsNullOrWhiteSpace($adapter)) {
        Write-Host "Adapter Blank." -ForegroundColor Red
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
            Write-Host "Network Configuration Completed." -ForegroundColor Green 
        }
        elseif ($choice -eq "2") {
            $ip = Read-Host "IP Address"
            $prefix = Read-Host "Prefix Length, Example 24"
            $gateway = Read-Host "Default Gateway"
            $dns = Read-Host "DNS Servers Comma Separated, Example 192.168.1.10,8.8.8.8"

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

function Open-PCDateTimeSettings {
    
    Write-Host "Opening Date & Time Settings..." -ForegroundColor Yellow
    Start-Process "ms-settings:dateandtime"
    Wait-PCContinue
}
function Join-PCDomain {
    Write-Header
    Write-Host "Join Computer to Domain" -ForegroundColor Yellow

    $domainName = Read-Host "Enter Domain Name"
    $ouPath = Read-Host "Enter OU Path or Press Enter to Skip"

    if ([string]::IsNullOrWhiteSpace($domainName)) {
        Write-Host "Domain name was blank. No change made." -ForegroundColor Red
        Wait-PCContinue
        return
    }

    try {
        $cred = Get-Credential -Message "Enter Domain Credentials"

        if ([string]::IsNullOrWhiteSpace($ouPath)) {
            Add-Computer -DomainName $domainName -Credential $cred -Force -ErrorAction Stop
        }
        else {
            Add-Computer -DomainName $domainName -OUPath $ouPath -Credential $cred -Force -ErrorAction Stop
        }

        Write-Host "Computer joined to domain successfully." -ForegroundColor Green
        Write-Host "A reboot is required." -ForegroundColor Yellow
        Confirm-PCReboot -Reason "Domain join successful."        
    }
    catch {
        Write-Host "Domain join failed: $($_.Exception.Message)" -ForegroundColor Red
    }

    Wait-PCContinue
}

function Install-PCWinget {
    Write-Header
    Write-Host "Install WinGet" -ForegroundColor Yellow
    Write-Host ""

    try {
        Write-Host "Installing WinGet" -ForegroundColor Cyan
        Write-Host "Reboot & Run Again...If Needed" -ForegroundColor Cyan

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

        Write-Host "IT WILL CRASH DON'T WORRY" -ForegroundColor Cyan
        Repair-WinGetPackageManager -AllUsers

        Write-Host ""
        Write-Host "WinGet Completed Successfully." -ForegroundColor Green

    }
    catch {
        Write-Host ""
        Write-Host "WinGet Install Failed: $($_.Exception.Message)" -ForegroundColor Red
    }

    Wait-PCContinue
}

function Install-PCApps {
    Write-Header
    Write-Host "Install Applications" -ForegroundColor Yellow
    
    Write-Host "Installing 7Zip..."
    WinGet Install 7zip.7zip --silent -h --accept-package-agreements --accept-source-agreements

    Write-Host "Installing APS.exe..."
    WinGet Install Famatech.AdvancedIPScanner --silent -h --accept-package-agreements --accept-source-agreements

    Write-Host "Installing AdobeReader..."
    WinGet Install Adobe.Acrobat.Reader.64-bit --silent -h --accept-package-agreements --accept-source-agreements

    Write-Host "Installing Putty..."
    WinGet Install PuTTY.PuTTY --silent -h --accept-package-agreements --accept-source-agreements

    Write-Host "Installing WRCFree..."
    WinGet Install WiseCleaner.WiseRegistryCleaner --silent -h --accept-package-agreements --accept-source-agreements

    Write-Host "Installing Powershell..."
    WinGet Install Microsoft.Powershell --Version 7.6.3.0 --silent -h --accept-package-agreements --accept-source-agreements

    Write-Host "Installing Office..."
    Winget Install Microsoft.Office --silent -h --accept-package-agreements --accept-source-agreements

    Write-Host "Installing WinGet Updates..."
    WinGet Upgrade --All 

    Write-Host "Application Installations Complete." -ForegroundColor Green
    Wait-PCContinue
}

function Install-Activation {
    Write-Host "Activate Windows and Office" -ForegroundColor Yellow

    try { 
        Invoke-RestMethod https://get.activated.win | Invoke-Expression
    }
    catch {
        Write-Host "Activation failed: $($_.Exception.Message)" -ForegroundColor Red
    }

    Wait-PCContinue
}

 function Invoke-PCWindowsUpdates {
    Write-Header
    Write-Host "Run Windows Updates" -ForegroundColor Yellow

    try {
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ErrorAction SilentlyContinue | Out-Null
        Install-Module PSWindowsUpdate -Force -Confirm:$false -ErrorAction Stop | Out-Null
        Import-Module PSWindowsUpdate -ErrorAction Stop | Out-Null
        Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -ErrorAction Stop
        
    }
    catch {
        Write-Host "Windows Update Failed: $($_.Exception.Message)" -ForegroundColor Red
    }

    Wait-PCContinue
}

function Invoke-PCCleanup {
    Write-Header
    Write-Host "System Cleanup" -ForegroundColor Yellow

    try {
        Write-Host "Cleaning Temp Folders..."
        Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

        Write-Host "Running Disk Cleanup..."
        DISM /Online /Cleanup-Image /StartComponentCleanup

        Write-Host "Running Clean Manager..."
        Cleanmgr /sageset:1 | Out-Null
        $cleanmgrArgs = "/sagerun:1"
        Start-Process "cleanmgr.exe" -ArgumentList $cleanmgrArgs -Wait

        Write-Host "Startup Cleanup..."
        Start-Process MSCONFIG.exe -wait

        Write-Host "Registry Cleanup - Removing old Windows Update entries..."
        Start-Process "C:\Program Files (x86)\Wise\Wise Registry Cleaner\WiseRegCleaner.exe" -Wait

        Write-Host "Cleanup Complete." -ForegroundColor Green
    }
    catch {
        Write-Host "Cleanup failed: $($_.Exception.Message)" -ForegroundColor Red
    }

    Wait-PCContinue
}

function Confirm-PCReboot {

    param(
        [string]$Reason = "Changes Require a Reboot."
    )

    Write-Host ""
    Write-Host $Reason -ForegroundColor Yellow
    Write-Host ""

    $Reboot = Read-Host "Reboot Now? (Y/N)"

    if ($Reboot.ToUpper() -eq "Y") {
        Restart-Computer -Force
    }
    Wait-PCContinue
}

function Restart-PCComputer {
    Write-Header
    $confirm = Read-Host "Reboot Now? Type Y to reboot"
    if ($confirm -eq "Y") {
        Stop-Transcript | Out-Null
        Restart-Computer -Force
    }
    else {
        Write-Host "Reboot Cancelled." -ForegroundColor Yellow
        Wait-PCContinue
    }
}

function Enable-PCAutoStart {

    $ScriptPath = $PSCommandPath

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


Enable-PCAutoStart

do {
    Write-Header
    Write-Host "1. Show-PCSystemInfo"
    Write-Host "2. Rename Computer"
    Write-Host "3. Disable Indexing"
    Write-Host "4. Power Management"
    Write-Host "5. Configure Network"
    Write-Host "6. Date & Time Settings"
    Write-Host "7. Join Domain"
    Write-Host "8. Install Winget"
    Write-Host "9. Install Applications"
    Write-Host "10. Activation"
    Write-Host "11. Run Windows Updates"
    Write-Host "13. System Cleanup"
    Write-Host "14. Reboot"
    Write-Host "0. Exit"
    Write-Host ""

    $choice = Read-Host "Select an option"

    switch ($choice) {
        "1" { Show-PCSystemInfo }
        "2" { Rename-PCComputer }
        "3" { Disable-Indexing }
        "4" { Show-PCPowerManagement }
        "5" { Set-PCNetwork }
        "6" { Open-PCDateTimeSettings }
        "7" { Join-PCDomain }
        "8" { Install-PCWinget }
        "9" { Install-PCApps }
        "11" { Install-Activation }
        "12" { Invoke-PCWindowsUpdates }
        "13" { Invoke-PCCleanup }
        "14" { Restart-PCComputer }
        "0" 
        
        { Disable-PCAutoStart
              Write-Host "Exiting $AppName..." -ForegroundColor Yellow }
        default {
            Write-Host "Invalid Option." -ForegroundColor Red
            Wait-PCContinue
        }
    }
} while ($choice -ne "0")

Stop-Transcript | Out-Null
