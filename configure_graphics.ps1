Write-Host "`n[Tweak] Aplicando configuracoes graficas para desempenho..." -ForegroundColor Cyan

# Desativar transparência
Write-Host "[+] Desativando transparencia..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name EnableTransparency -Value 0

# Ajustar efeitos visuais: manter apenas "mostrar conteúdo ao arrastar" e "usar fontes com cantos arredondados"
Write-Host "[+] Ajustando efeitos visuais personalizados..."

# Define configuração personalizada
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name VisualFXSetting -Value 3

# Define flags individuais (1 = ativado, 0 = desativado)
$visualSettings = @{
    "DragFullWindows" = 1  # Mostrar conteúdo da janela ao arrastar
    "FontSmoothing"   = 1  # Usar fontes com cantos arredondados
    "MenuAnimation"   = 0
    "ComboBoxAnimation" = 0
    "ListBoxSmoothScrolling" = 0
    "TooltipAnimation" = 0
    "WindowAnimation" = 0
    "ClientAreaAnimation" = 0
    "CursorShadow" = 0
    "SelectionFade" = 0
    "GradientCaptions" = 0
    "DropShadow" = 0
}

foreach ($setting in $visualSettings.GetEnumerator()) {
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name $setting.Key -Value $setting.Value -Force
}

Write-Host "`n[OK] Configuracoes graficas aplicadas com sucesso." -ForegroundColor Green