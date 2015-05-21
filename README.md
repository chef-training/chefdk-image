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
$ packer verify aws.json
$ packef build aws.json
```