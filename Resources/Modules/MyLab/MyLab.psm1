
<#
 .Synopsis
  A collection of Scritps used to setup and manage a lab.

 .Description
  A collection of Scritps used to setup and manage a lab.

# .Parameter FirstDayOfWeek
#  The day of the month on which the week begins.

 .Example
   # Show a default display of this month.
   Show-Calendar

#>

function Test-Administrator  
{  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}

function Start-MyLab {
    param (
        [string]$LabName = "MyLab"
    )
    
    Copy-Item -Path "$env:USERPROFILE\HomeLab\Resources\PostInstallationActiveties\MyLab\" -Destination "C:\LabSources\PostInstallationActivities\" -Recurse -Force
    Copy-Item -Path "$env:USERPROFILE\HomeLab\Resources\Software\" -Destination "C:\LabSources\" -Recurse -Force
    & $env:USERPROFILE\HomeLab\Resources\MyLab.ps1 -Labname $LabName
}

function Invoke-MyLab {
    if ( -not ( Test-Administrator )) {
        Write-Host '[Build] Please Run this with elevated priveleges' -ForegroundColor Red
        Break
    }

    Write-Host "[Build] Checking for ISO Files" -ForegroundColor Green
    if ( -not ( Test-Path C:\LabSources\ISOs\* -Include *.iso ) ) {
        Write-Host "[Build] Failed to find ISO files in C:\LabSources\ISO\. Please add ISO files for more info run New-LabISO" -ForegroundColor Red
        Break
    }


    Write-Host "[Build] Installing AutomatedLab" -ForegroundColor Green
    Install-PackageProvider Nuget -Force
    if ( -not ( Get-Module -ListAvailable -Name AutomatedLab )) {
        Install-Module AutomatedLab -AllowClobber -Force
    }

    Write-Host "[Build] Disabling Telemetry" -ForegroundColor Green
    Disable-LabTelemetry -Force -Confirm

    

    Write-Host "[Build] Setting up the lab environment" -ForegroundColor Green
    New-LabDefinition -Name MyLab -DefaultVirtualizationEngine HyperV -vmPath C:\MyLab\VMs
    Write-Host "[Build] MyLab has been initiallised. Use Start-MyLab to start up the enbironment" -ForegroundColor Green


}

function New-MyLabISO {
    Write-Host '[ISO Download] Checking if there is a Windows images' -ForegroundColor Green
    if ( -not ( Test-Path 'C:\LabSources\ISOs\Windows 10.iso' -ErrorAction Ignore )) {
        Write-Host '[ISO Download] Windows 10 Image missing. Dowload it and place it in C:\Labresources\ISOs\Windows 10.iso' -ForegroundColor Red
        Write-Host '[ISO Download] Download from here: https://software-download.microsoft.com/download/pr/18363.418.191007-0143.19h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso' -ForegroundColor Yellow
    } else {
        Write-Host '[ISO Download] No need to download a Windows 10 imge' -ForegroundColor Green
    }

    if ( -not ( Test-Path 'C:\LabSources\ISOs\Windows Server 2019.iso' -ErrorAction Ignore )) {
        Write-Host '[ISO Download] Windows SErver 2019 Image missing. Dowload it and place it in C:\Labresources\ISOs\Windows Server 2019.iso'  -ForegroundColor Red
        Write-Host '[ISO Download] Download from here: https://software-download.microsoft.com/download/pr/17763.737.190906-2324.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us_1.iso'  -ForegroundColor Yellow
    } else {
        Write-Host '[ISO Download] No need to download a Windows Server 2019 imge' -ForegroundColor Green
    }

    if ( -not ( Test-Path 'C:\LabSources\Software\Office 2013.iso' -ErrorAction Ignore )) {
        Write-Host '[ISO Download] Please Download an Office iso manually to the Software folder' -ForegroundColor Red
    } else {
        Write-Host '[ISO Download] No need to download a Office 2013 imge' -ForegroundColor Green
    }

}

Export-ModuleMember -Function ('Invoke-MyLab',  'Start-MyLab', 'New-MyLabISO')