<#
.SYNOPSIS
  Install the GPO that allows Users  to RDP
.DESCRIPTION
  A script used to configure a GPO on the DC to allow RDP by users
#>

Write-Host "[Configure RDP GPO] Downloading and unpackign the GPOs"
Invoke-WebRequest -Uri 'https://github.com/Status-418/HomeLab/raw/master/Resources/GPOs/Domain_Users_Allow_RDP.zip' -OutFile 'C:\Windows\Temp\Domain_Users_Allow_RDP.zip'
Expand-Archive -Path 'C:\Windows\Temp\Domain_Users_Allow_RDP.zip' -DestinationPath 'C:\Windows\Temp\Domain_Users_Allow_RDP'

Write-Host "[Configure RDP GPO] Importing the GPO to allow users to RDP..."
Import-GPO -BackupGpoName 'Domain Users Allow RDP' -Path "C:\Windows\Temp\Domain_Users_Allow_RDP\" -TargetName 'Domain Users Allow RDP' -CreateIfNeeded

Write-Host "[Configure RDP GPO] Linking the GPO to the Client OU"
$OU = "ou=Computers,ou=detectionlab,dc=lab,dc=local"
$gPLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name 'Domain Users Allow RDP'
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
  New-GPLink -Name 'Domain Users Allow RDP' -Target $OU -Enforced yes
  Write-Host "[Configure RDP GPO] Sucessfully linked $OU to allow users RDP"
}
else
{
  Write-Host "[Configure RDP GPO] The OU is already linked to $OU. Moving On."
}

Write-Host "[Configure RDP GPO] Linking the GPO to the Server OU"
$OU = "ou=Servers,ou=detectionlab,dc=lab,dc=local"
$gPLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name 'Domain Users Allow RDP'
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
    New-GPLink -Name 'Domain Users Allow RDP' -Target $OU -Enforced yes
    Write-Host "[Configure RDP GPO] Sucessfully linked $OU to allow users RDP."
}
else
{
  Write-Host "[Configure RDP GPO] The OU is already linked to $OU. Moving On."
}
