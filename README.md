# Creates Chef Development Kit enhanced Amazon Machine Instances (AMI)

This project contains a number of Packer files, scripts and recipes that allow for the creation and configuration of AMI for the training interventions we offer at Chef.

## Setup

> This is a [video](https://drive.google.com/a/opscode.com/file/d/0B1nt6eQeCbyRXzFMV1hHcFhuSFE/view?usp=sharing) that describes these setup procedures.

\1. Get AWS Credentials

> You will need an AWS Access Key, AWS Secret Key, and a Key Pair (AKA access_key, secret_key, key pair)

\2. Add the AWS Access Key and AWS Secret Key to `~/.aws/config`

> This is an example of what the files looks like.

```
[default]
aws_access_key_id = ACCESS_KEY_ID
aws_secret_access_key = SECRET_ACCESS_KEY
```

\3. Add the TRAINING_AWS_KEYPAIR environment variable pointing to the key filepath

> This is an example of setting up that environment variable

```
$ export TRAINING_AWS_KEYPAIR=/Users/franklinwebber/.ssh/training-ec2-keypair.pem
```

\4. Install [Packer](https://www.packer.io/downloads.html). At least 0.8.1.

## Creating AMI

Run `packer` to create the AMI

> This is an example of using packer to creating an image for CentOS.

> NOTE: Each packer file contains a version number within it. When you need to create a new version of the Packer image you will need to update this packer file version or you may received an error because of a conflict of version numbers.

* Essentials - CentOS Workstation Image

```
# Validate and then build the Essentials - CentOS 6.7 Workstation
$ packer validate essentials-centos.json
$ packer build essentials-centos.json
```

* Essentials - Windows Workstation Image

NOTE: WARNING this is currently not working! This script is unable to execute; it FAILS!

```
# Validate and then build the Essentials - Windows Workstation
$ packer validate essentials-windows-workstation.json
$ packer build essentials-windows-workstation.json
```

* Essentials - Windows Node Image

```
# Validate and then build the Essentials - Windows Node
$ packer validate essentials-windows-node.json
$ packer build essentials-windows-node.json
```

* Compliance - CentOS Image

```
# Validate and then build the CentOS 6.7 Compliance Node
$ packer validate compliance-centos.json
$ packer build compliance-centos.json
```

* Compliance - Windows Image

NOTE: WARNING this is currently not working! This script is unable to execute; it FAILS!

```
# Validate and then build the Windows 2012 Compliance Node
$ packer validate compliance-windows.json
$ packer build compliance-windows.json
```

* TDD Cookbook Development - CentOS Image

```
# Validate and then build the TDD Cookbook Development CentOS 6.7 Workstation
$ packer validate tdd_cookbook_development-centos.json
$ packer build tdd_cookbook_development-centos.json
```

* Extending Cookbooks - CentOS Image

```
# Validate and then build the Extending Cookbooks CentOS 6.7 Workstation
$ packer validate extending_cookbooks-centos.json
$ packer build extending_cookbooks-centos.json
```

* Intermediate - CentOS Image

```
# Validate and then build the Intermediate CentOS 6.7 Workstation
$ packer validate intermediate-centos.json
$ packer build intermediate-centos.json
```

* Elegant Tests - CentOS Image

```
# Validate and then build the Elegant Tests CentOS 6.7 Workstation
$ packer validate elegant_tests-centos.json
$ packer build elegant_tests-centos.json
```

## Sharing Images

Once an AMI is created there are a number of individuals that will likely want
access to those AMIs. To grant access to the AMI that was created you run:

```
$ rake ami:grant AMI_ID=ami-????????
```

This will iterate through the entire list of [AMI subscribers](subscribers.yml)


## Known Issues

### Windows Nodes and Workstations

The current version of Packer (0.8.6) does not successfully allow you to use Chef cookbook recipes in the creation of Windows AMIs. To address that issue I started to develop the configuration management in simple PowerShell scripts. However, one of the scripts that installs a lot of the necessary components fails to run when executed through Packer. This means to regenerate a Windows AMI one must:

* Launch a clean Windows 2012R2 Instance
* Login to that Instance
* Run the WinRM script (`scripts/winrm.ps1`)
* Run the specific script for the course (e.g. For Compliance, run `scripts/compliance-windows.ps1`)
