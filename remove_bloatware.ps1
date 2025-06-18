# Caminho do JSON
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$jsonPath = Join-Path $ScriptRoot "..\config\bloatware.json"

# Verifica se o arquivo existe
if (-Not (Test-Path $jsonPath)) {
    Write-Host "[!] Arquivo bloatware.json nao encontrado em $jsonPath" -ForegroundColor Red
    exit
}

# Lê o JSON
try {
    $bloatwares = Get-Content $jsonPath | ConvertFrom-Json
} catch {
    Write-Host "[!] Erro ao ler o arquivo bloatware.json" -ForegroundColor Red
    exit
}

foreach ($app in $bloatwares) {
    Write-Host "`n[Remocao] Tentando remover $app..." -ForegroundColor Cyan

    # Remove para o usuário atual
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue

    # Remove provisionamento para novos usuários
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -EQ $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

Write-Host "`n[OK] Remocao de bloatwares concluida." -ForegroundColor Green