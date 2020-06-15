<#
.SYNOPSIS
    A script used to managed a home lab
.PARAMETER Build
  This switch will determine if it's a client or server and install all requirments to setup a domain
.PARAMETER Start
  This switch will start up the home lab
.PARAMETER Delete
  This switch will tear down the home lab
.PARAMETER Snapshot
  This switch will tear down the home lab
.PARAMETER Snapshot
  This switch will tear down the home lab
.DESCRIPTION
    A script used to configure, start up, manage & tear down a home lab
#>
param(
    [switch]$Build = $false,
    [switch]$Start = $false,
    [switch]$Delete = $false,
    [switch]$Snapshot = $false,
    [switch]$Restore = $false,
    [string]$LabName = "DetectionLab"
)

# ToDo
# rename this to detecitonlab.ps1
# add options for setup env, build lab, tear down lab, snapshot lab, revert lab.
# Add arguments to the Build-Homelab.ps1 to make it more modular

$Base_Dir = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

if ($PSBoundParameters.ContainsKey('Build')) {
  & $Base_Dir\Resources\Scripts\Build-Homelab.ps1
} elseif ($PSBoundParameters.ContainsKey('Start')) {
  Write-Host "[Starting up Lab] Copying files to LabSource"
  Copy-Item -Path $Base_Dir\Resources\PostInstallationActiveties\ -Destination C:\LabSources\PostInstallationActiveties\ -Recurse -Force
  Copy-Item -Path $Base_Dir\Resources\Software\* -Destination C:\LabSources\Software\ -Recurse -Force
  & $Base_Dir\Resources\Scripts\Start-Homelab.ps1 -Labname $LabName
} elseif ($PSBoundParameters.ContainsKey('Delete')) {
  Remove-Lab -Name $LabName
} elseif ($PSBoundParameters.ContainsKey('Snapshot')) {
  # Add the ability to just snapshot one or more hosts
  heckpoint-LabVM -SnapshotName -All
} elseif ($PSBoundParameters.ContainsKey('Restore')) {
  Write-host "TBC Soon, Sorry"
}
