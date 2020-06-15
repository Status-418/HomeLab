<#
.SYNOPSIS
  Used to Remove OneDrive from a comptuer.
.DESCRIPTION
  This script will remove and disable OneDrive integration.
  Source: https://github.com/StefanScherer/Debloat-Windows-10
#>

Write-Host "[Windows Configuration] Kill OneDrive process" -ForegroundColor Green
taskkill.exe /F /IM "OneDrive.exe"
taskkill.exe /F /IM "explorer.exe"

Write-Host "[Windows Configuration] Remove OneDrive" -ForegroundColor Green
if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
    & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
}
if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
    & "$env:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall
}

Write-Host "[Windows Configuration] Removing OneDrive leftovers" -ForegroundColor Green
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\Microsoft\OneDrive"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:programdata\Microsoft OneDrive"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:userprofile\OneDrive"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "C:\OneDriveTemp"

Write-Host "[Windows Configuration] Disable OneDrive via Group Policies" -ForegroundColor Green
New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive" -ItemType "directory" -Force
sp "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive" "DisableFileSyncNGSC" 1

Write-Host "[Windows Configuration] Remove Onedrive from explorer sidebar" -ForegroundColor Green
New-PSDrive -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" -Name "HKCR"
New-Item -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -ItemType "directory" -Force
sp "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
New-Item -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -ItemType "directory" -Force
sp "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
Remove-PSDrive "HKCR"

Write-Host "[Windows Configuration] Removing run hook for new users" -ForegroundColor Green
reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
reg unload "hku\Default"

Write-Host "[Windows Configuration] Removing startmenu entry" -ForegroundColor Green
Remove-Item -Force -ErrorAction SilentlyContinue "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

Write-Host "[Windows Configuration] Restarting explorer" -ForegroundColor Green
start "explorer.exe"

Write-Host "[Windows Configuration] Waiting for explorer to complete loading" -ForegroundColor Green
sleep 5

# Causing errors needs more testing
#Write-Host "[Windows Configuration] Removing additional OneDrive leftovers" -ForegroundColor Green
#foreach ($item in (ls "$env:WinDir\WinSxS\*onedrive*")) {
#    Remove-Item -Recurse -Force $item.FullName
#}
