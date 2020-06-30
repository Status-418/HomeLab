
function Test-Administrator  
{  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}


$Base_Dir = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

if ( -not (Test-Administrator)) {
    Write-Host "[Setup] This script needs to be run with elevated priveleges" -ForegroundColor Red
    Break
} else {
    Write-Host "[Setup] Running as Administrator" -ForegroundColor Green
    if( Get-Service -Name vmms -ErrorAction Ignore ) {
        Write-Host "[Setup] Hyper-V is enabled, moving on" -ForegroundColor Green
    } else {
        Write-Host "[Setup] Hyper-V is not installed, installing now" -ForegroundColor Green
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
        Write-Host '[Setup] Hyper-V is installed a reboot is required.' -ForegroundColor Red
    }

    if ( -not ( Test-Path $env:USERPROFILE\Documents\WindowsPowerShell\Modules\MyLab )) {
        Write-Host '[Setup] Installing the MyLab module' -ForegroundColor Green
        New-Item -Path $env:USERPROFILE\Documents\WindowsPowerShell\Modules\MyLab -ItemType Directory
        Copy-Item $Base_Dir\Resources\Modules\MyLab\ $env:USERPROFILE\Documents\WindowsPowerShell\Modules\ -Recurse -Force
        Import-Module -Name MyLab -Force
    } else {
        Import-Module -Name MyLab -Force
    }

    Write-Host '[Setup] Installation completed. Next reboot the computer and run Start-MyLab' -ForegroundColor Green
}