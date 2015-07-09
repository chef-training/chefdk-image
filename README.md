# Creates ChefDK Fundamentals AMI

This project contains a number of Packer files that allow for quick creation of an AMI, installation with necessary tools, and the distribution of the AMI to various regions within a specific AWS account.

Creating an AMI is necessary if the core requirements of what is required for the instance changes. Currently these images are created with the following [criteria](https://github.com/chef-training/chefdk-fundamentals-image/blob/master/cookbooks/fundamentals/test/integration/default/serverspec/default_spec.rb).

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

\4. Install [Packer 0.8.1](https://www.packer.io/downloads.html)

\5. Run `packer` to create the AMI

> This is an example of using packer to create two images. The Ubuntu 14.04 AMI and the CentOS 6.5 AMI.

```
# Ubuntu 14.04
$ packer validate ubuntu.json
$ packer build ubuntu.json

# CentOS 6.5
$ packer validate centos.json
$ packer build centos.json

# Windows 2012R2
$ packer validate windows.json
$ packer build windows.json
```

