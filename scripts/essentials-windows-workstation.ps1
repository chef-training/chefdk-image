Write-Output "Setting Administrator Password"
([ADSI]'WinNT://localhost/Administrator, user').psbase.Invoke('SetPassword', 'Cod3Can!')

Write-Output "Creating Hints Location and Writing Hints File"
New-Item -path 'C:\\chef\\ohai\\hints' -type directory
Add-Content 'C:\\chef\\ohai\\hints\\ec2.json' '{}'

Write-Output "Writing out Kitchen Template"
Invoke-WebRequest "https://raw.githubusercontent.com/chef-training/chef-essentials-windows/master/kitchen-template.yml" -OutFile 'C:\\Users\\Administrator\kitchen-template.yml'

# NOTE: This currently fails when executed through Packer - Powershell
Write-Output "Execute Nordstrom ChefDK Bootstrap"
(Invoke-WebRequest -Uri https://raw.githubusercontent.com/Nordstrom/chefdk_bootstrap/master/bootstrap.ps1).Content | Invoke-Expression

Write-Output "Installing Kitchen EC2 Gem"
Invoke-Expression "chef gem install kitchen-ec2"
