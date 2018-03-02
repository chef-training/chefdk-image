sudo sh -c "sed -i 's/ssh_pwauth:   0/ssh_pwauth: 1/' /etc/cloud/cloud.cfg"

sudo sh -c "cat >> /etc/cloud/cloud.cfg << 'EOF'
users:
  - default
  - name: chef
    homedir: /home/chef
    groups: [wheel, adm, systemd-journal]
    lock_passwd: false
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    shell: /bin/bash
    passwd: \$6\$saltsalt\$J/vBRLUpNxvyLE/HvWGIC2KA6JMo6sgWcYbZmnfg3a/3fPPj1UjTqcNWWOzmstoV2QFicV3651hkujIlu30QO1

packages:
  - yum-utils
  - device-mapper-persistent-data
  - lvm2
  - vim
  - nano
  - emacs
  - git
  - tree

runcmd:
  - echo 'hello friend' > /home/centos/fsociety.dat
  - yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  - yum install docker-ce -y
  - sudo usermod -a -G docker chef
  - systemctl start docker
  - mkdir -p /etc/chef/ohai/hints && echo '{}' > /etc/chef/ohai/hints/ec2.json
  - service sshd restart
EOF
"
