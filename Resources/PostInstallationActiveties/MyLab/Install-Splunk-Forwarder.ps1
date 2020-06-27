<#
.SYNOPSIS
  This will install and configure a Windows Universal Forwarder
.DESCRIPTION
  This will install and configure a Windows Universal Forwarder
#>
# Add parameters for splunk username & password
param(
    [string]$SplunkUser = "admin",
    [string]$SplunkPassword = "Password1"
)

Write-Host "[Splunk Forwarder Install] Downloading Universal Forwarder" -ForegroundColor Green 
(New-Object net.webclient).Downloadfile("https://download.splunk.com/products/universalforwarder/releases/8.0.4/windows/splunkforwarder-8.0.4-767223ac207f-x64-release.msi", "$env:TEMP\splunk.msi")

Write-Host "[Splunk Forwarder Install] Installing Universal Forwarder" -ForegroundColor Green 
Start-Process -FilePath "c:\windows\system32\msiexec.exe" -ArgumentList "/i", "$env:TEMP\splunk.msi", "RECEIVING_INDEXER='192.168.11.254:9997' WINEVENTLOG_SEC_ENABLE=1 AGREETOLICENSE=Yes SERVICESTARTTYPE=auto LAUNCHSPLUNK=1 SPLUNKPASSWORD=$SplunkPassword /quiet" -Wait
