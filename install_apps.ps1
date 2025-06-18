# Define o caminho do script e do JSON
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$configPath = Join-Path $ScriptRoot "..\config\apps.json"

# Verifica se o arquivo JSON existe
if (-Not (Test-Path $configPath)) {
    Write-Host "[!] Arquivo apps.json não encontrado em $configPath" -ForegroundColor Red
    exit
}

# Lê o JSON
try {
    $apps = Get-Content $configPath | ConvertFrom-Json
} catch {
    Write-Host "[!] Erro ao ler o arquivo apps.json" -ForegroundColor Red
    exit
}

# Instala via winget
if ($apps.winget) {
    foreach ($app in $apps.winget) {
        Write-Host "`n[Winget] Instalando $app..." -ForegroundColor Cyan
        winget install --id=$app --silent --accept-package-agreements --accept-source-agreements
    }
}

# Instala via choco
if ($apps.choco) {
    foreach ($app in $apps.choco) {
        Write-Host "`n[Choco] Instalando $app..." -ForegroundColor Cyan
        choco install $app -y
    }
}

# Instala via custom
if ($apps.custom) {
    foreach ($customApp in $apps.custom) {
        $name = $customApp.name
        $installer = $customApp.installerPath
        $installArgs = $customApp.arguments


        if (Test-Path $installer) {
            Write-Host "`n[Custom] Instalando $name..." -ForegroundColor Cyan  
            Start-Process -FilePath $installer -ArgumentList $installArgs -Wait -NoNewWindow
        } else {
            Write-Host "[!] Instalador nao encontrado para $name em $installer" -ForegroundColor Red
        }
    }
}

Write-Host "`n [OK] A instalacao de aplicativos foi concluida..." -ForegroundColor Green