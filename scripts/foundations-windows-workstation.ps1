Write-Output "Setting Administrator Password"
([ADSI]'WinNT://localhost/Administrator, user').psbase.Invoke('SetPassword', 'Cod3Can!')

Write-Output "Creating Hints Location and Writing Hints File"
New-Item -path 'C:\\chef\\ohai\\hints' -type directory
Add-Content 'C:\\chef\\ohai\\hints\\ec2.json' '{}'

Write-Output "Writing out Kitchen Template"
Invoke-WebRequest "https://raw.githubusercontent.com/chef-training/chefdk-image/master/test_kitchen-templates/kitchen-template.yml" -OutFile 'C:\\Users\\Administrator\kitchen-template.yml'

Write-Output "Install Chocolately"
Set-ExecutionPolicy ByPass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# Set-ExecutionPolicy ByPass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://gist.githubusercontent.com/johnfitzpatrick/08793f88f5b7f777489e0cddfb799c27/raw/f09d87b561ac0347a622b91dce840427df4454b6/install.ps1'))
Write-Output "Chocolately Installed"


# Install ConEmu, Atom and VSCode
Invoke-Expression "C:\ProgramData\chocolatey\bin\choco install conemu -y"
Invoke-Expression "C:\ProgramData\chocolatey\bin\choco install atom -y"
Invoke-Expression "C:\ProgramData\chocolatey\bin\choco install vscode -y"
Invoke-Expression "C:\ProgramData\chocolatey\bin\choco install notepadplusplus -y"

# Install Chef Workstation
Write-Output "Install Chef Workstation"
$metadataURL = "https://omnitruck.chef.io/stable/chef-workstation/metadata?p=windows&pv=2012r2&m=x86_64&v=latest"

$getMetadata = Invoke-WebRequest -UseBasicParsing $metadataURL

$latest_info = $getMetadata.Content
$CHEFWORKSTATION_LATEST_PATTERN = "version\s(\d{1,2}\.\d{1,2}\.\d{1,2})"
$targetChefWorkstation = [regex]::match($latest_info, $CHEFWORKSTATION_LATEST_PATTERN).Groups[1].Value

$dotChefWorkstationDir = Join-Path -path $env:LOCALAPPDATA -childPath 'chef-workstation'
$tempInstallDir = Join-Path -path $env:TEMP -childpath 'chef-workstation_bootstrap'
$omniUrl = "https://omnitruck.chef.io/install.ps1"

# Set HOME to be c:\users\<username> so cookbook gem installs are on the c:\
# drive
$env:HOME = $env:USERPROFILE

# create the temporary installation directory
if (!(Test-Path $tempInstallDir -pathType container)) {
  New-Item -ItemType 'directory' -path $tempInstallDir
}

# Install Chef Workstation from chef omnitruck, unless installed already
Write-Host "Checking for installed Chef Workstation version"
$app = Get-CimInstance -classname win32_product -filter "Name like 'Chef Workstation%'"
$installedVersion = $app.Version

if ( $installedVersion -like "$targetChefWorkstation*" ) {
  Write-Host "The Chef Workstation version $installedVersion is already installed."
} else {
  if ( $installedVersion -eq $null ) {
    Write-Host "No Chef Workstation found. Installing the Chef Workstation version $targetChefWorkstation"
  } else {
    Write-Host "Upgrading the Chef Workstation from $installedVersion to $targetChefWorkstation"
    Write-Host "Uninstalling Chef Workstation version $installedVersion. This might take a while..."
    Invoke-CimMethod -InputObject $app -MethodName Uninstall
    if ( -not $? ) { promptContinue "Error uninstalling Chef Workstation version $installedVersion" }
    if (Test-Path $dotChefWorkstationDir) {
      Remove-Item -Recurse $dotChefWorkstationDir
    }
  }
  $installScript = Invoke-WebRequest -UseBasicParsing $omniUrl
  $installScript | Invoke-Expression
  if ( -not $? ) { die "Error running installation script" }
  Write-Host "Installing Chef Workstation version $targetChefWorkstation. This might take a while..."
  install -channel stable -project chef-workstation -version $targetChefWorkstation
  if ( -not $? ) { die "Error installing the Chef Workstation version $targetChefWorkstation" }
}

# Add Chef Workstation to the path
$env:Path += ";C:\opscode\chef-workstation\bin"

Write-Output "Installing Kitchen EC2 Gem"
Invoke-Expression "chef gem install kitchen-ec2"

# Append Chef Development Kit (Chef Workstation) Embedded Bin to the PATH

$LocalMachinePathRegKey = 'HKLM:\System\CurrentControlSet\Control\Session Manager\Environment'
$ChefWorkstationEmbeddedBin = 'C:\opscode\chef-workstation\embedded\bin'

Push-Location
Set-Location $LocalMachinePathRegKey
$CurrentPath = (Get-ItemProperty . Path).Path
$PathWithInSpec = "$CurrentPath;$ChefWorkstationEmbeddedBin"
Set-ItemProperty . -Name Path -Value $PathWithInSpec
Pop-Location
