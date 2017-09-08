Write-Output "Setting Administrator Password"
([ADSI]'WinNT://localhost/Administrator, user').psbase.Invoke('SetPassword', 'Cod3Can!')

Write-Output "Creating Hints Location and Writing Hints File"
New-Item -path 'C:\\chef\\ohai\\hints' -type directory
Add-Content 'C:\\chef\\ohai\\hints\\ec2.json' '{}'

Write-Output "Writing out Kitchen Template"
Invoke-WebRequest "https://raw.githubusercontent.com/chef-training/chefdk-image/master/test_kitchen-templates/kitchen-template.yml" -OutFile 'C:\\Users\\Administrator\kitchen-template.yml'

Write-Output "Install Chocolately"
Set-ExecutionPolicy ByPass -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install ConEmu and Atom
Invoke-Expression "C:\ProgramData\chocolatey\bin\choco install conemu -y"
Invoke-Expression "C:\ProgramData\chocolatey\bin\choco install atom -y"

# Install Chef DK

$metadataURL = "https://omnitruck.chef.io/stable/chefdk/metadata?p=windows&pv=2012r2&m=x86_64&v=latest"

$getMetadata = Invoke-WebRequest -UseBasicParsing $metadataURL

$latest_info = $getMetadata.Content
$CHEFDK_LATEST_PATTERN = "version\s(\d{1,2}\.\d{1,2}\.\d{1,2})"
$targetChefDk = [regex]::match($latest_info, $CHEFDK_LATEST_PATTERN).Groups[1].Value

$dotChefDKDir = Join-Path -path $env:LOCALAPPDATA -childPath 'chefdk'
$tempInstallDir = Join-Path -path $env:TEMP -childpath 'chefdk_bootstrap'
$omniUrl = "https://omnitruck.chef.io/install.ps1"

# Set HOME to be c:\users\<username> so cookbook gem installs are on the c:\
# drive
$env:HOME = $env:USERPROFILE

# create the temporary installation directory
if (!(Test-Path $tempInstallDir -pathType container)) {
  New-Item -ItemType 'directory' -path $tempInstallDir
}

# Install ChefDK from chef omnitruck, unless installed already
Write-Host "Checking for installed ChefDK version"
$app = Get-CimInstance -classname win32_product -filter "Name like 'Chef Development Kit%'"
$installedVersion = $app.Version

if ( $installedVersion -like "$targetChefDk*" ) {
  Write-Host "The ChefDK version $installedVersion is already installed."
} else {
  if ( $installedVersion -eq $null ) {
    Write-Host "No ChefDK found. Installing the ChefDK version $targetChefDk"
  } else {
    Write-Host "Upgrading the ChefDK from $installedVersion to $targetChefDk"
    Write-Host "Uninstalling ChefDK version $installedVersion. This might take a while..."
    Invoke-CimMethod -InputObject $app -MethodName Uninstall
    if ( -not $? ) { promptContinue "Error uninstalling ChefDK version $installedVersion" }
    if (Test-Path $dotChefDKDir) {
      Remove-Item -Recurse $dotChefDKDir
    }
  }
  $installScript = Invoke-WebRequest -UseBasicParsing $omniUrl
  $installScript | Invoke-Expression
  if ( -not $? ) { die "Error running installation script" }
  Write-Host "Installing ChefDK version $targetChefDk. This might take a while..."
  install -channel stable -project chefdk -version $targetChefDk
  if ( -not $? ) { die "Error installing the ChefDK version $targetChefDk" }
}

# Add ChefDK to the path
$env:Path += ";C:\opscode\chefdk\bin"

Write-Output "Installing Kitchen EC2 Gem"
Invoke-Expression "chef gem install kitchen-ec2"

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
