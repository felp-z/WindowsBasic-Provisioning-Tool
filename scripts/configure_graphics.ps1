Write-Host "`n[Tweak] Applying graphics settings for performance..." -ForegroundColor Cyan

# Disable transparency
Write-Host "[+] Disabling transparency..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name EnableTransparency -Value 0

# Adjust visual effects: keep only "show window contents while dragging" and "smooth edges of screen fonts"
Write-Host "[+] Adjusting custom visual effects..."

# Set custom configuration
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name VisualFXSetting -Value 3

# Set individual flags (1 = enabled, 0 = disabled)
$visualSettings = @{
    "DragFullWindows" = 1  # Show window contents while dragging
    "FontSmoothing"   = 1  # Smooth edges of screen fonts
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

Write-Host "`n[OK] Graphics settings applied successfully." -ForegroundColor Green
