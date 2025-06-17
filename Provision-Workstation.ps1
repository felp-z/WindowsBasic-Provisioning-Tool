<#
.SYNOPSIS
    Ferramenta de Provisionamento e Otimizacao de Workstation v1.7
.DESCRIPTION
    Script interativo para configurar uma nova instalacao do Windows, incluindo
    instalacao de apps, atualizacoes, e ajustes finos de desempenho e rede.
.AUTHOR
    Ismael Felipe (com assistencia do Coach de Carreira)
.VERSION
    1.7 - Removidos apps desnecessarios e adicionado ajuste fino em animacoes visuais.
#>

# --- VERIFICACAO DE PRIVILEGIOS ---
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $(New-Object Security.Principal.WindowsIdentity).GetCurrent()
    if (-not $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Warning "Permissao Negada. Por favor, execute este script como Administrador."
        Read-Host "Pressione Enter para sair."
        exit
    }
}

# --- FUNCOES DO MENU ---
function Show-Menu {
    Clear-Host
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host "    Ferramenta de Provisionamento e Otimizacao" -ForegroundColor White
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host
    Write-Host "Selecione uma opcao:" -ForegroundColor Yellow
    Write-Host "1. Instalar Aplicativos Essenciais (Winget)"
    Write-Host "2. Forcar Todas as Atualizacoes do Windows"
    Write-Host "3. Otimizar Desempenho Visual (Performance x Qualidade)"
    Write-Host "4. Otimizar Adaptadores de Rede (Desativar Eco-Mode)"
    Write-Host "5. Renomear PC e Ingressar no Dominio"
    Write-Host "6. Limpar Arquivos Temporarios do Sistema"
    Write-Host
    Write-Host "9. EXECUTAR TUDO (Modo Automatico)" -ForegroundColor Cyan
    Write-Host "0. Sair" -ForegroundColor Red
    Write-Host
}

# --- FUNCOES DE EXECUCAO ---
function Install-Apps {
    Clear-Host
    Write-Host "--- Iniciando Instalacao de Aplicativos Essenciais ---" -ForegroundColor Cyan
    # Lista de aplicativos ajustada
    $apps = @{
        "Google.Chrome"     = "Google Chrome"
        "7zip.7zip"         = "7-Zip"
    }

    foreach ($appId in $apps.Keys) {
        $appName = $apps[$appId]
        Write-Host "Verificando $appName..."
        $installed = winget list --id $appId -n 1
        if (-not [string]::IsNullOrWhiteSpace($installed)) {
            Write-Host "$appName ja esta instalado. Pulando." -ForegroundColor Yellow
        } else {
            try {
                Write-Host "Instalando $appName..." -ForegroundColor White
                winget install --id $appId --silent --accept-source-agreements --accept-package-agreements
                Write-Host "$appName instalado com sucesso." -ForegroundColor Green
            } catch {
                Write-Host "ERRO ao instalar $($appName): $_" -ForegroundColor Red
            }
        }
    }
    Write-Host "--- Instalacao de Aplicativos Concluida ---" -ForegroundColor Cyan
    Read-Host "Pressione Enter para voltar ao menu."
}

function Run-Updates {
    Clear-Host; Write-Host "--- Iniciando Busca e Instalacao de Atualizacoes do Windows ---" -ForegroundColor Cyan; try {Get-Service -Name wuauserv -ErrorAction Stop | Out-Null; Write-Host "Servico Windows Update (wuauserv) encontrado." -ForegroundColor Green} catch {Write-Warning "ALERTA: O servico Windows Update (wuauserv) nao foi encontrado neste sistema."; Write-Warning "A atualizacao automatica nao pode continuar."; Read-Host "Pressione Enter para voltar ao menu."; return}; try {Import-Module PSWindowsUpdate -ErrorAction Stop; Write-Host "Modulo PSWindowsUpdate ja esta disponivel." -ForegroundColor Green} catch {Write-Host "Modulo PSWindowsUpdate nao encontrado. Tentando instalar..." -ForegroundColor Yellow; Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force; Install-Module -Name PSWindowsUpdate -Force -AcceptLicense}; Write-Host "Buscando e instalando atualizacoes... Isso pode levar varios minutos."; Get-WUInstall -MicrosoftUpdate -AcceptAll -AutoReboot -Verbose; Write-Host "--- Processo de Atualizacao Concluido ---" -ForegroundColor Cyan; Write-Host "Uma reinicializacao pode ter sido agendada."; Read-Host "Pressione Enter para voltar ao menu."
}

function Set-VisualEffects {
    Clear-Host
    Write-Host "--- Ajustando Efeitos Visuais para Desempenho ---" -ForegroundColor Cyan
    
    # Define o modo para "Personalizado"
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFxSetting' -Value 3
    
    # Desativa animações e sombras indesejadas (incluindo as novas)
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value ([byte[]](0x90,0x12,0x01,0x80,0x10,0x00,0x00,0x00)) -Force
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\DWM' -Name 'EnableAeroPeek' -Value 0 -Force
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ListviewShadow' -Value 0 -Force
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAnimations' -Value 0 -Force
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Value '0' -Force
    
    # Garante que as opções de qualidade desejadas permaneçam ativas
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'DragFullWindows' -Value '1'
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'FontSmoothing' -Value '2'
    
    Write-Host "Configuracoes de desempenho visual aplicadas." -ForegroundColor Green
    Write-Warning "Pode ser necessario reiniciar o explorer.exe ou o computador para que todos os efeitos sejam aplicados."
    Read-Host "Pressione Enter para voltar ao menu."
}

function Optimize-NetworkAdapters {
    Clear-Host; Write-Host "--- Otimizando Adaptadores de Rede ---" -ForegroundColor Cyan; $adapters = Get-NetAdapter -Physical; foreach ($adapter in $adapters) {Write-Host "Verificando adaptador: $($adapter.Name)" -ForegroundColor White; try {Set-NetAdapterPowerManagement -Name $adapter.Name -AllowComputerToTurnOffDevice $false; Write-Host "Gerenciamento de energia desativado para $($adapter.Name)." -ForegroundColor Green} catch {Write-Warning "Nao foi possivel alterar o gerenciamento de energia para $($adapter.Name). Pode nao ser suportado."}}; Write-Host "--- Otimizacao de Rede Concluida ---" -ForegroundColor Cyan; Read-Host "Pressione Enter para voltar ao menu."
}

function Set-ComputerNameAndDomain {
    Clear-Host; Write-Host "--- Renomear Computador e Ingressar no Dominio ---" -ForegroundColor Cyan; $currentName = $env:COMPUTERNAME; $newName = Read-Host "Digite o NOVO nome para este computador (Atual: $currentName). Pressione Enter para pular"; if (-not [string]::IsNullOrWhiteSpace($newName)) {Write-Host "Renomeando computador para $newName..." -ForegroundColor White; Rename-Computer -NewName $newName -Force; Write-Host "Computador renomeado. E necessario reiniciar." -ForegroundColor Yellow}; $domainName = Read-Host "Digite o nome do Dominio para ingressar (ex: empresa.local). Pressione Enter para pular"; if (-not [string]::IsNullOrWhiteSpace($domainName)) {try {Write-Host "Tentando ingressar no dominio $domainName..." -ForegroundColor White; $credential = Get-Credential; Add-Computer -DomainName $domainName -Credential $credential -Force; Write-Host "Ingresso no dominio $domainName realizado com sucesso." -ForegroundColor Green; Write-Warning "REINICIALIZACAO OBRIGATORIA para aplicar as alteracoes."} catch {Write-Warning "ERRO ao ingressar no dominio: $_"}}; Read-Host "Pressione Enter para voltar ao menu."
}

function Clear-TempFiles {
    Clear-Host; Write-Host "--- Limpando Arquivos Temporarios ---" -ForegroundColor Cyan; $tempPaths = @("$env:TEMP", "$env:windir\Temp"); foreach ($path in $tempPaths) {Write-Host "Limpando pasta: $path" -ForegroundColor White; Remove-Item -Path "$path\*" -Recurse -Force -ErrorAction SilentlyContinue}; Write-Host "Arquivos temporarios removidos." -ForegroundColor Green; Write-Host "--- Limpeza Concluida ---" -ForegroundColor Cyan; Read-Host "Pressione Enter para voltar ao menu."
}

# --- LOOP PRINCIPAL DO SCRIPT ---
Test-Admin
do {Show-Menu; $selection = Read-Host "Sua escolha"; switch ($selection) {"1" { Install-Apps } "2" { Run-Updates } "3" { Set-VisualEffects } "4" { Optimize-NetworkAdapters } "5" { Set-ComputerNameAndDomain } "6" { Clear-TempFiles } "9" {Install-Apps; Run-Updates; Set-VisualEffects; Optimize-NetworkAdapters; Clear-TempFiles; Write-Host "--- TAREFAS AUTOMATICAS CONCLUIDAS ---" -ForegroundColor Green; Write-Warning "A etapa de Renomear/Ingressar no Dominio (opcao 5) deve ser executada manualmente."; Read-Host "Pressione Enter para voltar ao menu."} "0" {Write-Host "Saindo..." -ForegroundColor Yellow} default {Write-Warning "Opcao invalida. Tente novamente."; Start-Sleep -Seconds 2}}} while ($selection -ne "0")