<#
1. Create OU structure
2. Move all users, servers & computers in to the right OUs
3. Create Group Policies
#>

Import-Module -Name ActiveDirectory

Write-Host "[DC Setup] Creating the OUs needed in the new domain" -ForegroundColor Green
New-ADOrganizationalUnit -Name DetectionLab -ProtectedFromAccidentalDeletion $false
$outList = @('Users', 'Admins', 'Computers', 'Servers') 
$outList | ForEach-Object { New-ADOrganizationalUnit -Name $_ -ProtectedFromAccidentalDeletion $false -path "ou=DetectionLab,DC=lab,DC=local" }

Write-Host "[DC Setup] Create Lab Users" -ForegroundColor Green
$accoutPassword = ConvertTo-SecureString "Password1" -AsPlainText -Force
$userList =  @('Alice', 'Bob', 'Charlie')

Write-Host "[DC Setup] Move Xena to DetectionLab/Admins OU"
Get-ADUser Xena | Move-ADObject -TargetPath 'ou=Admins,ou=detectionlab,dc=lab,dc=local'

$userList | ForEach-Object { New-ADUser -Name $_ -AccountPassword $accoutPassword -Path "ou=users,ou=detectionlab,DC=lab,DC=local" -ChangePasswordAtLogon $false -Enabled $true -PasswordNeverExpires $true }

Write-Host "[DC Setup] Move computers & servers to the right OUs" -ForegroundColor Green
Get-ADComputer -Filter 'Name -like "client*"' | Move-ADObject -TargetPath 'ou=computers,ou=detectionlab,dc=lab,dc=local'
Get-ADComputer -Filter 'Name -like "router*"' | Move-ADObject -TargetPath 'ou=servers,ou=detectionlab,dc=lab,dc=local'

Write-Host "[DC Setup] Create a GPO for enabling RDP on Clients by users" -ForegroundColor Green
Invoke-WebRequest -Uri https://github.com/Status-418/HomeLab/raw/v02/Allow%20RDP%20Access.zip -OutFile "C:\Windows\Temp\Allow RDP Access.zip"
Expand-Archive -Path "C:\Windows\Temp\Allow RDP Access.zip" -DestinationPath "C:\Windows\Temp\Allow RDP Access\"
Import-GPO -BackupGpoName "Allow RDP Access" -TargetName "Allow RDP Access" -CreateIfNeeded -Path 'C:\Windows\Temp\Allow RDP Access'
Get-GPO -Name "Allow RDP Access" | New-GPLink -Target "ou=computers,ou=detectionlab,dc=lab,dc=local" -LinkEnabled yes
Get-GPO -Name "Allow RDP Access" | New-GPLink -Target "ou=servers,ou=detectionlab,dc=lab,dc=local" -LinkEnabled yes

Write-Host "[DC Setup] Adding users to the Remote Desktop Users group" -ForegroundColor Green
Add-ADGroupMember -Identity "Remote Desktop Users" -Members Alice,Bob,Charlie,Xena
Invoke-Command -ComputerName Client1 -Command { gpupdate /force }
