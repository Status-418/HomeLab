<#
.SYNOPSIS
    A script used to install and configure a AutomatedLab
.DESCRIPTION
    A script used to install and configure a AutomatedLab
#>

Write-Host "[Build] Installing AutomatedLab" -ForegroundColor Green
Install-PackageProvider Nuget -Force
Install-Module AutomatedLab -AllowClobber -Force

Write-Host "[Build] Disabling Telemetry" -ForegroundColor Green
Disable-LabTelemetry -Force

Write-Host "[Build] Setting up the lab environment" -ForegroundColor Green
New-LabDefinition -Name DetectionLab -DefaultVirtualizationEngine HyperV -vmPath C:\DetectionLab\VMs

Write-Host "[Build] Moving the files" -ForegroundColor Green
Copy-Item -Path .\Resources\PostInstallationActiveties\PostinstallClient\ -Destination C:\LabSources\PostInstallationActivities\ -Recurse
Copy-Item -Path .\Resources\PostInstallationActiveties\PostInstallServer\ -Destination C:\LabSources\PostInstallationActivities\ -Recurse
Copy-Item -Path .\Resources\Software\ -Destination C:\LabSources\Software\ -Recurse

Write-Host "[Build] Checking if there is a Server ISO file" -ForegroundColor Green
if (-not(Test-Path -Path C:\LabSources\ISOs\Windows_Server_2019.iso)) {
    $downloadServerIso = Read-Host 'Do you want to download ISO images?'
    switch ($downloadServerIso) {
        Yes {$downloadServerIso = $true; break}
        Y {$downloadServerIso = $true; break}
        True {$downloadServerIso = $true; break}
        No {$downloadServerIso = $false; break}
        N {$downloadServerIso = $false; break}
        False {$downloadServerIso = $false; break}
        default {"Invalid Input"; break}
        }
    }

Write-Host "[Build] Checking if there is a Client ISO file" -ForegroundColor Green
if (-not(Test-Path -Path C:\LabSources\ISOs\Windows_10.iso)) {
    $downloadClientIso = Read-Host 'Do you want to download ISO images?'
    switch ($downloadClientIso) {
        Yes {$downloadClientIso = $true; break}
        Y {$downloadClientIso = $true; break}
        True {$downloadClientIso = $true; break}
        No {$downloadClientIso = $false; break}
        N {$downloadClientIso = $false; break}
        False {$downloadClientIso = $false; break}
        default {"Invalid Input"; break}
        }
    }    

if ($downloadServerIso) {
    Invoke-WebRequest -URI 'https://software-download.microsoft.com/download/pr/18363.418.191007-0143.19h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso' -OutFile C:\DetectionLab\VMs\Windows_Server_2019.iso
    }

if ($downloadClientIso) {
    Invoke-WebRequest -URI 'https://software-download.microsoft.com/download/pr/18363.418.191007-0143.19h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso' -OutFile C:\DetectionLab\VMs\Windows_Server_2019.iso
    }
