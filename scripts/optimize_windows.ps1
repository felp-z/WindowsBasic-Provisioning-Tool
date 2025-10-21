Write-Host "`n[Tweak] Starting system optimizations" -ForegroundColor Cyan

# Activate high-performance power plan
Write-Host "[+] Activating high-performance power plan..."
powercfg -setactive SCHEME_MIN

# Disable animations and visual effects
Write-Host "[+] Disabling animations and visual effects..."
Set-ItemProperty "HKCU:\Control Panel\Desktop\WindowMetrics" -Name MinAnimate -Value 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name VisualFXSetting -Value 2

# Disable background apps
Write-Host "[+] Disabling background apps..."
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name GlobalUserDisabled -PropertyType DWord -Value 1 -Force | Out-Null

# Disable unnecessary scheduled tasks (example: diagnostics)
Write-Host "[+] Disabling unnecessary scheduled tasks..."
$tasks = @(
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
    "\Microsoft\Windows\Autochk\Proxy",
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
)
foreach ($task in $tasks) {
    try {
        Disable-ScheduledTask -TaskPath $task.Substring(0, $task.LastIndexOf("\")) -TaskName ($task.Split("\")[-1]) -ErrorAction SilentlyContinue
    } catch {
        Write-Host "[-] Failed to disable task: $task" -ForegroundColor DarkYellow
    }
}

Write-Host "`n[OK] Optimizations applied successfully" -ForegroundColor Green
