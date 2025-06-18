# Descobre o diretório onde o Setup.ps1 está localizado
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Verifica se está rodando como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "[!] Este script precisa ser executado como administrador." -ForegroundColor Red
    Pause
    exit
}

# Setup.ps1
Clear-Host
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "     Pos-Formatacao - Workstation     " -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

function Show-Menu {
    Write-Host ""
    Write-Host "Selecione uma opcao:" -ForegroundColor Yellow
    Write-Host "1. Instalar Aplicativos"
    Write-Host "2. Remover Bloatwares"
    Write-Host "3. Aplicar Otimizacoes de Sistema"
    Write-Host "4. Configuracoes Graficas"
    Write-Host "5. Sair"
}

function Invoke-MenuOption {
    param([string]$choice)

    switch ($choice) {
    "1" {
        Write-Host "`n[+] Executando instalacao de aplicativos..." -ForegroundColor Green
        & "$ScriptRoot\scripts\install_apps.ps1"
    }
    "2" {
        Write-Host "`n[+] Removendo bloatwares..." -ForegroundColor Green
        & "$ScriptRoot\scripts\remove_bloatware.ps1"
    }
    "3" {
        Write-Host "`n[+] Aplicando otimizacoes de sistema..." -ForegroundColor Green
        & "$ScriptRoot\scripts\optimize_windows.ps1"
    }
    "4" {
        Write-Host "`n[+] Aplicando configuracoes graficas..." -ForegroundColor Green
        & "$ScriptRoot\scripts\configure_graphics.ps1"
    }
    "5" {
        Write-Host "`nSaindo..." -ForegroundColor Red
        exit
    }
    default {
        Write-Host "`n[!] Opcao invalida. Tente novamente." -ForegroundColor Red
    }
}

}

do {
    Show-Menu
    $userChoice = Read-Host "Digite o numero da opcao desejada"
    Invoke-MenuOption -choice $userChoice
    Start-Sleep -Seconds 2
} 

while ($true)