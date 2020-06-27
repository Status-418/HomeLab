<#
.SYNOPSIS
  This will install and configure a Windows Server
.DESCRIPTION
  This will install and configure a Windows Server
#>
param(
    [string]$SplunkUser = "admin",
    [string]$SplunkPassword = "Password1"
)


Write-Host "[Splunk Forwarder Install] Downloading Server Applicaiont" -ForegroundColor Green 
Start-BitsTransfer -Source "https://download.splunk.com/products/splunk/releases/8.0.4.1/windows/splunk-8.0.4.1-ab7a85abaa98-x64-release.msi" -Destination "$env:TEMP\splunk.msi"

Write-Host "[Splunk Forwarder Install] Installing Server Applicaiont" -ForegroundColor Green 
Start-Process -FilePath msiexec.exe -ArgumentList "/i $env:TEMP\splunk.msi AGREETOLICENSE=Yes SPLUNKUSERNAME=$SplunkUser SPLUNKPASSWORD=$SplunkPassword  /quiet" -Wait
Start-Sleep -Seconds 5

Write-Host "[Splunk Forwarder Install] Configuring Server To Listen For Forwarders" -ForegroundColor Green 
& 'C:\Program Files\Splunk\bin\splunk.exe' enable listen 9997 -auth $SplunkUser':'$SplunkPassword

Write-Host "[Splunk Forwarder Install] Installing Splunk Apps" -ForegroundColor Green 
& 'C:\Program Files\Splunk\bin\splunk.exe' install app C:\Windows\Temp\splunk-add-on-for-microsoft-windows_800.tgz -update 1 -auth $SplunkUser':'$SplunkPassword