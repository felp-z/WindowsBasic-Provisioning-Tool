# Set the JSON path
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$jsonPath = Join-Path $ScriptRoot "..\config\bloatware.json"

# Check if the file exists
if (-Not (Test-Path $jsonPath)) {
    Write-Host "[!] bloatware.json file not found at $jsonPath" -ForegroundColor Red
    exit
}

# Read the JSON file
try {
    $bloatwares = Get-Content $jsonPath | ConvertFrom-Json
} catch {
    Write-Host "[!] Error reading the bloatware.json file" -ForegroundColor Red
    exit
}

foreach ($app in $bloatwares) {
    Write-Host "`n[Removal] Trying to remove $app..." -ForegroundColor Cyan

    # Remove for the current user
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue

    # Remove provisioning for new users
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -EQ $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

Write-Host "`n[OK] Bloatware removal completed." -ForegroundColor Green
