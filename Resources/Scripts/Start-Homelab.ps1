<#
.SYNOPSIS
    A script used to startup a home lab
.DESCRIPTION
    A script used to startup a home lab
#>

param(
    [Parameter(mandatory=$true)]
    [string]$Labname = "DetectionLab"
)
#
# Defining the Lab
New-LabDefinition -Name $Labname -DefaultVirtualizationEngine HyperV

# Configuring the domain and local user accounts
Add-LabDomainDefinition -Name lab.local -AdminUser Administrator -AdminPassword StickyPot6 
Set-LabInstallationCredential -Username Administrator -Password StickyPot6

# Configuring the lab network
Add-LabVirtualNetworkDefinition -Name $Labname
Add-LabVirtualNetworkDefinition -Name 'Internet' -HyperVProperties @{ SwitchType = 'External'; AdapterName = 'Ethernet' }


$postInstallActivity_Servers = @()
$postInstallActivity_Servers += Get-LabPostInstallationActivity -ScriptFileName Configure-Server.ps1 -DependencyFolder $labSources\PostInstallationActivities\DetectionLab
$postInstallActivity_Servers += Get-LabPostInstallationActivity -ScriptFileName Install-Choco-Apps-Server.ps1 -DependencyFolder $labSources\PostInstallationActivities\DetectionLab
$postInstallActivity_Servers += Get-LabPostInstallationActivity -ScriptFileName Configure-RDP-User-GPO.ps1 -DependencyFolder $labSources\PostInstallationActivities\DetectionLab\
$postInstallActivity_Servers += Get-LabPostInstallationActivity -ScriptFileName Configure-Local-Admin.ps1 -DependencyFolder $labSources\PostInstallationActivities\DetectionLab\
$postInstallActivity_Servers += Get-LabPostInstallationActivity -ScriptFileName Set_Audit_Pol_PS_v2_3_4_5.cmd -DependencyFolder $labSources\PostInstallationActivities\DetectionLab\
Add-LabMachineDefinition -Name DC1 -Memory 4GB -OperatingSystem 'Windows Server 2019 Standard Evaluation (Desktop Experience)' -Roles RootDC -Network $Labname -DomainName lab.local -IpAddress 192.168.11.1 -PostInstallationActivity  $postInstallActivity_Servers

$netAdapter = @()
$netAdapter += New-LabNetworkAdapterDefinition -VirtualSwitch $Labname -Ipv4Address 192.168.11.254 
$netAdapter += New-LabNetworkAdapterDefinition -VirtualSwitch 'Internet' -UseDhcp
Add-LabMachineDefinition -Name Router1 -Memory 1GB -OperatingSystem 'Windows Server 2019 Standard Evaluation (Desktop Experience)' -Roles Routing -NetworkAdapter $netAdapter -DomainName lab.local 

$postInstallActivity_Clients = @()
$postInstallActivity_Clients += Get-LabPostInstallationActivity -ScriptFileName Remove-OneDrive.ps1 -DependencyFolder $labSources\PostInstallationActivities\DetectionLab
$postInstallActivity_Clients += Get-LabPostInstallationActivity -ScriptFileName Remove-Default-Apps.ps1 -DependencyFolder $labSources\PostInstallationActivities\DetectionLab
$postInstallActivity_Clients += Get-LabPostInstallationActivity -ScriptFileName Remove-Default-Apps.ps1 -DependencyFolder $labSources\PostInstallationActivities\DetectionLab
$postInstallActivity_Clients += Get-LabPostInstallationActivity -ScriptFileName Install-Choco-Apps.ps1 -DependencyFolder $labSources\PostInstallationActivities\DetectionLab
$postInstallActivity_Clients += Get-LabPostInstallationActivity -ScriptFileName Set_Audit_Pol_PS_v2_3_4_5.cmd -DependencyFolder $labSources\PostInstallationActivities\DetectionLab
$postInstallActivity_Clients += Get-LabPostInstallationActivity -ScriptFileName Install-Winlogbeat.ps1 -DependencyFolder $labSources\PostInstallationActivities\DetectionLab
Add-LabMachineDefinition -Name Client1 -Memory 4GB -Network $Labname -OperatingSystem 'Windows 10 Enterprise Evaluation' -Roles Office2013 -DomainName lab.local -IpAddress 192.168.11.101 -PostInstallationActivity $postInstallActivity_Clients

Add-LabIsoImageDefinition -Name Office2013 -Path  $labSources\Software\Office_2013.iso

Install-Lab

Disable-LabAutoLogon
Checkpoint-LabVM -SnapshotName Baseline -All

#$packs = @()
#$packs += Get-LabSoftwarePackage -Path $labSources\Software\kolide-launcher.msi -CommandLine -quiet
#Install-LabSoftwarePackages -Machine (Get-LabVM -All) -SoftwarePackage $packs

Show-LabDeploymentSummary -Detailed
