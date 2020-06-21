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

function _Show_File_Extensions() 
{
    Push-Location
    Set-Location HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
    Set-ItemProperty . HideFileExt "0"
    Pop-Location
}

function _Ask_Reboot {
    do { $myInput = ( Read-Host '[Defender] For the change to take effect a reboot is needed. Reboot now? (Y/N)' ).ToLower() } while ($myInput -notin @('y','n'))
    if ($myInput -eq 'y') {
    Write-Host '[Defender] Rebooting computer in 5 seconds' -ForegroundColor Green
    Sleep -Seconds 5
    Restart-Computer
    } else {
        Write-Host '[Defender] Please reboot for the changes to take effect' -ForegroundColor Red
    }
}

function Start-LabDefender {
    if ((Get-ItemProperty -Path 'HKLM:SOFTWARE\Policies\Microsoft\Windows Defender' -Name DisableAntiSpyware -ErrorAction SilentlyContinue).DisableAntiSpyware -eq '0' ) {
            Write-Host '[Defender] Windows Defender is already Enabled' -ForegroundColor Green
        } else  {
            Write-Host '[Defender] Enabling Windows Defender' -ForegroundColor Green
            New-ItemProperty -Path 'HKLM:SOFTWARE\Policies\Microsoft\Windows Defender' -Name DisableAntiSpyware -Value 0 -PropertyType DWORD -Force -
            _Ask_Reboot
        }
    }

function Stop-LabDefender {
    if ((Get-ItemProperty -Path 'HKLM:SOFTWARE\Policies\Microsoft\Windows Defender' -Name DisableAntiSpyware -ErrorAction SilentlyContinue).DisableAntiSpyware -eq '1' ) {
        Write-Host '[Defender] Windows Defender is already disabled' -ForegroundColor Green
    } else  {
        Write-Host '[Defender] Disabling Windows Defender' -ForegroundColor Green
        New-ItemProperty -Path 'HKLM:SOFTWARE\Policies\Microsoft\Windows Defender' -Name DisableAntiSpyware -Value 1 -PropertyType DWORD -Force 
        _Ask_Reboot
    }
}

function Install-LabTerminal {
    Write-Host '[Terminal] Installing Terminal' -ForegroundColor Green
    Invoke-WebRequest -Uri 'https://github.com/microsoft/terminal/releases/download/v1.0.1401.0/Microsoft.WindowsTerminal_1.0.1401.0_8wekyb3d8bbwe.msixbundle' -OutFile 'C:\Windows\Temp\terminal.msixbundle'
    Add-AppxPackage -Path 'C:\Windows\Temp\terminal.msixbundle'
    Write-Host '[Defender] Terminal is installed' -ForegroundColor Green

}

function Repair-LabUI {
    # Command for taking a new config file: Export-StartLayout -path C:\Users\tom\Documents\HomeLab\Win-10\Scripts\LayoutModification_new.xml
    Write-Host "[UI] Configuring the Start menue and Taskbar" -ForegroundColor Green
    If((Test-Path 'C:\Program Files\WindowsPowerShell\Modules\Lab-Tools\LayoutModification.xml') -eq $True) {
        Copy-Item -Path "C:\Program Files\WindowsPowerShell\Modules\Lab-Tools\LayoutModification.xml" -Destination $env:LOCALAPPDATA\Microsoft\Windows\Shell\LayoutModification.xml -Force        Remove-Item 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*$start.tilegrid$windows.data.curatedtilecollection.tilecollection' -Force -Recurse
        _Show_File_Extensions
        Write-Host "[UI] Done, restarting Explorer" -ForegroundColor Green
        Get-Process Explorer | Stop-Process
        Remove-Item $env:USERPROFILE\Desktop\*.lnk
        Remove-Item $env:PUBLIC\Desktop\*.lnk
        Write-Host "[UI] All UI fixes applied" -ForegroundColor Green
    }
}

Export-ModuleMember -Function ('Start-LabDefender',  'Stop-LabDefender', 'Install-LabTerminal', 'Repair-LabUI')