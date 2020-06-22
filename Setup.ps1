$Base_Dir = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

Write-Host "[Setup] Checking if Hyper-V is installed" -ForegroundColor Green
if( Get-Service -Name vmms ) {
    Write-Host "[Setup] Hyper-V is enabled, moving on" -ForegroundColor Green
} else {
    Write-Host "[Setup] Hyper-V is not installed, installing now" -ForegroundColor Green
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
    Write-Host '[Setup] Hyper-V is installed a reboot is required.' -ForegroundColor Red
}

Write-Host '[Setup] Installing the MyLab module' -ForegroundColor Green
Copy-Item $Base_Dir\Resources\Modules\MyLab\ $env:USERPROFILE\Documents\WindowsPowerShell\Modules\ -Recurse -Force
Import-Module -Name MyLab -Force

Write-Host '[Setup] Installation completed. Use Invoke-MyLab to get started' -ForegroundColor Green
