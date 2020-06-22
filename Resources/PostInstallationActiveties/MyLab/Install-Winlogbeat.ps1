<#
.SYNOPSIS
  Install the GPO that adds users to the local admin group
.DESCRIPTION
  A script used to configure a GPO on the DC to add usrs to the local admin group.
#>

param (
    [string]$cloud_id = 'Lab01:ZXUtd2VzdC0xLmF3cy5mb3VuZC5pbyQ3NzE1MzEzODcwNWM0ODRmYTAwNzdhYjM4NGNiNjg2OSRlODExNTQwOTQ2YTg0MWZjOTIyZDVjOThjZjEwYzVhNQ==', 
    [string]$cloud_auth = 'elastic:4LssLuGHvYxJ3reSi1AGe9p6'    
)

if ( -not ( Get-Service | Where-Object Name -eq "winlogbeat" ) ) {
    Write-Host '[WinlogBeat Install] Not instaled, installing now.'
    & choco install -y winlogbeat
} else {
    Write-Host '[Winlogbeat Install] Already installed, moving on'
} 

Write-Host '[Winlogbeat] Updating the configuration'

((Get-Content -path "C:\ProgramData\chocolatey\lib\winlogbeat\tools\winlogbeat.yml" -Raw) -replace '#cloud.id:',"cloud.id: '$cloud_id'") | Set-Content -Path "C:\ProgramData\chocolatey\lib\winlogbeat\tools\winlogbeat.yml"
((Get-Content -path "C:\ProgramData\chocolatey\lib\winlogbeat\tools\winlogbeat.yml" -Raw) -replace '#cloud.auth:',"cloud.auth: '$cloud_auth'") | Set-Content -Path "C:\ProgramData\chocolatey\lib\winlogbeat\tools\winlogbeat.yml"

Write-Host '[Winlogbeat] Starting up'
& C:\ProgramData\chocolatey\lib\winlogbeat\tools\winlogbeat.exe -c C:\ProgramData\chocolatey\lib\winlogbeat\tools\winlogbeat.yml setup
Start-Service winlogbeat