Write-Host "`n[Tweak] Iniciando otimizacoes de sistema" -ForegroundColor Cyan

# Ativar plano de energia de alto desempenho
Write-Host "[+] Ativando plano de energia de alto desempenho..."
powercfg -setactive SCHEME_MIN

# Desativar animações e efeitos visuais
Write-Host "[+] Desativando animacoes e efeitos visuais..."
Set-ItemProperty "HKCU:\Control Panel\Desktop\WindowMetrics" -Name MinAnimate -Value 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name VisualFXSetting -Value 2

# Desabilitar apps em segundo plano
Write-Host "[+] Desabilitando apps em segundo plano..."
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name GlobalUserDisabled -PropertyType DWord -Value 1 -Force | Out-Null

# Desabilitar tarefas agendadas desnecessárias (exemplo: diagnóstico)
Write-Host "[+] Desabilitando tarefas agendadas desnecessarias..."
$tasks = @(
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
    "\Microsoft\Windows\Autochk\Proxy",
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
)
foreach ($task in $tasks) {
    try {
        Disable-ScheduledTask -TaskPath $task.Substring(0, $task.LastIndexOf("\")) -TaskName ($task.Split("\")[-1]) -ErrorAction SilentlyContinue
    } catch {
        Write-Host "[-] Falha ao desabilitar tarefa: $task" -ForegroundColor DarkYellow
    }
}

Write-Host "`n[OK] Otimizacoes aplicadas com sucesso" -ForegroundColor Green