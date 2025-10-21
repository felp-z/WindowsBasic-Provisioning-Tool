# Set the script and JSON paths
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$configPath = Join-Path $ScriptRoot "..\config\apps.json"

# Check if the JSON file exists
if (-Not (Test-Path $configPath)) {
    Write-Host "[!] apps.json file not found at $configPath" -ForegroundColor Red
    exit
}

# Read the JSON file
try {
    $apps = Get-Content $configPath | ConvertFrom-Json
} catch {
    Write-Host "[!] Error reading the apps.json file" -ForegroundColor Red
    exit
}

# Install via winget
if ($apps.winget) {
    foreach ($app in $apps.winget) {
        Write-Host "`n[Winget] Installing $app..." -ForegroundColor Cyan
        winget install --id=$app --silent --accept-package-agreements --accept-source-agreements
    }
}

# Install via choco
if ($apps.choco) {
    foreach ($app in $apps.choco) {
        Write-Host "`n[Choco] Installing $app..." -ForegroundColor Cyan
        choco install $app -y
    }
}

# Install via custom installers
if ($apps.custom) {
    foreach ($customApp in $apps.custom) {
        $name = $customApp.name
        $installer = $customApp.installerPath
        $installArgs = $customApp.arguments

        if (Test-Path $installer) {
            Write-Host "`n[Custom] Installing $name..." -ForegroundColor Cyan
            Start-Process -FilePath $installer -ArgumentList $installArgs -Wait -NoNewWindow
        } else {
            Write-Host "[!] Installer not found for $name at $installer" -ForegroundColor Red
        }
    }
}

Write-Host "`n[OK] Application installation has been completed." -ForegroundColor Green
