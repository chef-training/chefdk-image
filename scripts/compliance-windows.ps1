Write-Output "Setting Administrator Password"
([ADSI]'WinNT://localhost/Administrator, user').psbase.Invoke('SetPassword', 'Cod3Can!')

Write-Output "Creating Hints Location and Writing Hints File"
New-Item -path 'C:\\chef\\ohai\\hints' -type directory
Add-Content 'C:\\chef\\ohai\\hints\\ec2.json' '{}'

Write-Output "Writing out Kitchen Template"
Invoke-WebRequest "https://raw.githubusercontent.com/chef-training/chefdk-image/master/test_kitchen-templates/kitchen-template.yml" -OutFile 'C:\\Users\\Administrator\kitchen-template.yml'

# NOTE: This currently fails when executed through Packer - Powershell
Write-Output "Execute Nordstrom ChefDK Bootstrap"
Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/Nordstrom/chefdk_bootstrap/master/bootstrap.ps1 | Invoke-Expression
install

Write-Output "Installing Kitchen EC2 Gem"
Invoke-Expression "chef gem install kitchen-ec2"

# Install ConEmu
Invoke-Expression "C:\ProgramData\chocolatey\bin\choco install conemu -y"

# Append Chef Development Kit (ChefDK) Embedded Bin to the PATH

$LocalMachinePathRegKey = 'HKLM:\System\CurrentControlSet\Control\Session Manager\Environment'
$ChefDkEmbeddedBin = 'C:\opscode\chefdk\embedded\bin'

Push-Location
Set-Location $LocalMachinePathRegKey
$CurrentPath = (Get-ItemProperty . Path).Path
$PathWithInSpec = "$CurrentPath;$ChefDkEmbeddedBin"
Set-ItemProperty . -Name Path -Value $PathWithInSpec
Pop-Location

# Update the InSpec Version to one that is known to work on Windows
Invoke-Expression "chef gem install inspec -v 0.22.1"
