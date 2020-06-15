<#
.SYNOPSIS
  Install the GPO that allows Users  to RDP
.DESCRIPTION
  A script used to configure a GPO on the DC to allow RDP by users
#>

Write-Host "[Configure RDP GPO] Downloading and unpackign the GPOs"
Invoke-WebRequest -Uri 'https://github.com/Status-418/HomeLab/raw/v03/Resources/GPOs/Allow%20RDP%20Access.zip' -OutFile 'C:\Windows\Temp\Allow_RDP_Access.zip'
Expand-Archive -Path 'C:\Windows\Temp\Allow_RDP_Access.zip' -DestinationPath 'C:\Windows\Temp\Allow_RDP_Access'

Write-Host "[Configure RDP GPO] Importing the GPO to allow users to RDP..."
Import-GPO -BackupGpoName 'Allow Domain Users RDP' -Path "c:\windows\temp\GPO\Allow_RDP_Access" -TargetName 'Allow Domain Users RDP' -CreateIfNeeded

Write-Host "[Configure RDP GPO] Linking the GPO to the Client OU"
$OU = "ou=Workstations,dc=lab,dc=local"
$gPLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name 'Allow Domain Users RDP'
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
  New-GPLink -Name 'Allow Domain Users RDP' -Target $OU -Enforced yes
  Write-Host "[Configure RDP GPO] Sucessfully linked $OU to allow users RDP"
}
else
{
  Write-Host "[Configure RDP GPO] The OU is already linked to $OU. Moving On."
}

Write-Host "[Configure RDP GPO] Linking the GPO to the Server OU"
$OU = "ou=Servers,dc=lab,dc=local"
$gPLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name 'Allow Domain Users RDP'
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
    New-GPLink -Name 'Allow Domain Users RDP' -Target $OU -Enforced yes
    Write-Host "[Configure RDP GPO] Sucessfully linked $OU to allow users RDP."
}
else
{
  Write-Host "[Configure RDP GPO] The OU is already linked to $OU. Moving On."
}
gpupdate /force
