<#
.SYNOPSIS
  Used to install Chocolatey applications
.DESCRIPTION
  A script used to install covarious Chocolatey Applications on a Windows Client
#>

$testchoco = powershell choco -v

if(-not($testchoco)){
  Write-Host "[Windows Installing Apps] Installing Chocolatey" -ForegroundColor Green
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  write-Host "[Windows Installing Apps] Installing Chocolatey" -ForegroundColor Green
  iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) 
} else {
  Write-Host "[Windows Installing Apps] Chocolatey is already installed." -ForegroundColor Red
}

Write-Host "[Windows Installing Apps] Installing utilities..." -ForegroundColor Green
choco install -y --limit-output --no-progress googlechrome, firefox, 7zip, git

Write-Host "[Windows Installing Apps] Removing Links from Desktop" -ForegroundColor Green
Remove-Item -Path $env:PUBLIC\Desktop\*.lnk -Force
Remove-Item -Path $env:USERPROFILE\Desktop\*.lnk -Force

  # Fixing the Start Menu
  # Command for taking a new config file: Export-StartLayout -path C:\Users\tom\Documents\HomeLab\Win-10\Scripts\LayoutModification_new.xml
  #Write-Host "[Windows Installing Apps] Configuring the Start menue and Taskbar" -ForegroundColor Green
  #If((Test-Path $labSources\PostInstallationActivities\PostInstallClient\LayoutModification.xml) -eq $True) {
  #  Copy-Item $labSources\PostInstallationActivities\PostInstallClient\LayoutModification.xml $env:LOCALAPPDATA\Microsoft\Windows\Shell\LayoutModification.xml -Force
  #  Remove-Item 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*$start.tilegrid$windows.data.curatedtilecollection.tilecollection' -Force -Recurse
  #  Get-Process Explorer | Stop-Process
  #  }
    ## This will have to happen after a reboot of the PowerShell window
  # Configure VSCode
  # Install Powershell, pretty Json & xml, disable telemetry
  #Write-Host "[Windows Installing Apps] Configuring VSCode" -ForegroundColor Green
  #Copy-Item $Base_Dir\vscode_settings.json $env:APPDATA\Code\User\settings.json
  #Write-Host "[Windows Installing Apps] Installing VSCode Extentions" -ForegroundColor Green
  #code --install-extension ms-vscode.powershell'
  #code --install-extension eriklynd.json-tools'


  