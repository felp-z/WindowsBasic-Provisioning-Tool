# Get the directory where Setup.ps1 is located
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Verify if the script is running as an administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "[!] This script must be run as an administrator." -ForegroundColor Red
    Pause
    exit
}

# Main script
Clear-Host
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "      Windows Provisioning Tool       " -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

function Show-Menu {
    Write-Host ""
    Write-Host "Select an option:" -ForegroundColor Yellow
    Write-Host "1. Install Applications"
    Write-Host "2. Remove Bloatware"
    Write-Host "3. Apply System Optimizations"
    Write-Host "4. Apply Graphics Settings"
    Write-Host "5. Exit"
}

function Invoke-MenuOption {
    param([string]$choice)

    switch ($choice) {
        "1" {
            Write-Host "`n[+] Running application installation..." -ForegroundColor Green
            & "$ScriptRoot\scripts\install_apps.ps1"
        }
        "2" {
            Write-Host "`n[+] Removing bloatware..." -ForegroundColor Green
            & "$ScriptRoot\scripts\remove_bloatware.ps1"
        }
        "3" {
            Write-Host "`n[+] Applying system optimizations..." -ForegroundColor Green
            & "$ScriptRoot\scripts\optimize_windows.ps1"
        }
        "4" {
            Write-Host "`n[+] Applying graphics settings..." -ForegroundColor Green
            & "$ScriptRoot\scripts\configure_graphics.ps1"
        }
        "5" {
            Write-Host "`nExiting..." -ForegroundColor Red
            exit
        }
        default {
            Write-Host "`n[!] Invalid option. Please try again." -ForegroundColor Red
        }
    }
}

do {
    Show-Menu
    $userChoice = Read-Host "Enter the number of the desired option"
    Invoke-MenuOption -choice $userChoice
    Write-Host "`nPress any key to continue..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Clear-Host
} while ($true)
