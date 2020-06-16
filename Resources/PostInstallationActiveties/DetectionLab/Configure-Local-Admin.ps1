<#
.SYNOPSIS
  Install the GPO that adds users to the local admin group
.DESCRIPTION
  A script used to configure a GPO on the DC to add usrs to the local admin group.
#>

Write-Host "[Configure Local Admin GPO] Downloading and unpackign the GPOs"
Invoke-WebRequest -Uri 'https://github.com/Status-418/HomeLab/raw/master/Resources/GPOs/Add_Users_To_Local_Admin.zip' -OutFile 'C:\Windows\Temp\Add_Users_To_Local_Admin.zip'
Expand-Archive -Path 'C:\Windows\Temp\Add_Users_To_Local_Admin.zip' -DestinationPath 'C:\Windows\Temp\Add_Users_To_Local_Admin'

Write-Host "[Configure Local Admin GPO] Importing the GPO to usres to local admin group..."
Import-GPO -BackupGpoName 'Add Users To Local Admin' -Path "c:\windows\temp\Add_Users_To_Local_Admin" -TargetName 'Add Users To Local Admin' -CreateIfNeeded

Write-Host "[Configure Local Admin GPO] Linking the GPO to the Client OU"
$OU = "ou=Computers,ou=detectionlab,dc=lab,dc=local"
$gPLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name 'Add Users To Local Admin'
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
  New-GPLink -Name 'Add Users To Local Admin' -Target $OU -Enforced yes
  Write-Host "[Configure Local Admin GPO] Sucessfully linked $OU to add users to local admin group"
}
else
{
  Write-Host "[Configure Local Admin GPO] The OU is already linked to $OU. Moving On."
}

Write-Host "[Configure Local Admin GPO] Linking the GPO to the Server OU"
$OU = "ou=Servers,ou=detectionlab,dc=lab,dc=local"
$gPLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name 'Add Users To Local Admin'
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
    New-GPLink -Name 'Add Users To Local Admin' -Target $OU -Enforced yes
    Write-Host "[Configure Local Admin GPO] Sucessfully linked $OU to add users to local admin group"
  }
else
{
  Write-Host "[Configure Local Admin GPO] The OU is already linked to $OU. Moving On."
}
gpupdate /force