# Image: Base - CentOS 6.9

This image adds a Chef user to the system with lots of power in a very insecure system. Defines a default password for the user that is defined in hashed text within the `init.sh`. This is acceptable with the other risks as these systems are suppose to only run short-lived.

## Build

### Linux

```shell
$ export TRAINING_AWS_KEYPAIR_NAME=(NAME OF YOUR EC2 KEYPAIR)
$ export TRAINING_AWS_KEYPAIR=(FILEPATH TO YOUR PRIVATE KEY 1/2 OF THE KEYPAIR)
$ packer build packer.json
...
...
==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs: AMIs were created:
us-east-1: ami-0f9d003768fb94ef7
```

### Windows

```shell
> $env:TRAINING_AWS_KEYPAIR_NAME=(NAME OF YOUR EC2 KEYPAIR)
> $env:TRAINING_AWS_KEYPAIR=(FILEPATH TO YOUR PRIVATE KEY 1/2 OF THE KEYPAIR)
> packer build packer.json
...
...
==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs: AMIs were created:
us-east-1: ami-0f9d003768fb94ef7
```

## Run

The next step requires [Terraform](https://www.terraform.io/downloads.html) installed.

```shell
$ terraform init
$ terraform apply
var.base_ami
  Enter a value: ami-0f9d003768fb94ef7
    ...
    ...
  > yes
  instance.ip = 54.157.10.89
  instance.password = Cod3Can!
  instance.user = chef
```

## Connect

Use your SSH client to connect to the 54.157.10.89:

```
$ ssh chef@54.157.10.89
```

## Test

The next step requires InSpec.

```shell
$ inspec exec test.rb --sudo -t ssh://chef:Cod3Can!@54.157.10.89
```
