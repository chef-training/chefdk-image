# Creates ChefDK Fundamentals AMI

1. Get AWS Credentials (access_key,secret_key)
2. Add them to `~/.aws/config`

```
[default]
aws_access_key_id = ACCESS_KEY_ID
aws_secret_access_key = SECRET_ACCESS_KEY
```

3. Install Packer 0.7.5

4. Run Packer

```
# Ubuntu 14.04
$ packer verify ubuntu.json
$ packer build ubuntu.json

# CentOS 6.5
$ packer verify centos.json
$ packer build centos.json

```

