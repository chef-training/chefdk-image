write-output "Setting Administrator Password"
([ADSI]'WinNT://localhost/Administrator, user').psbase.Invoke('SetPassword', 'Cod3Can!')
write-output "Creating Hints Location and Writing Hints File"
New-Item -path 'C:\\chef\\ohai\\hints' -type directory
Add-Content 'C:\\chef\\ohai\\hints\\ec2.json' '{}'
