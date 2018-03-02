#
# By default cloud-init will not allow login with user password. For our learning
# environemnts we like to make it easy to get connected.
#
sudo sh -c "sed -i 's/ssh_pwauth:   0/ssh_pwauth: 1/' /etc/cloud/cloud.cfg"

#
# Cloud-Init 0.7.9 is currently on the CentOS 7.4 Instances in AWS
# @see http://cloudinit.readthedocs.io/en/0.7.9/index.html
#
# Users and Groups
# @see http://cloudinit.readthedocs.io/en/0.7.9/topics/modules.html?highlight=selinux#users-and-groups
#
# Package Update Upgrade Install
# @see http://cloudinit.readthedocs.io/en/0.7.9/topics/modules.html?highlight=selinux#package-update-upgrade-install
#
# Runcmd
# @see http://cloudinit.readthedocs.io/en/0.7.9/topics/modules.html#runcmd
#
sudo sh -c "cat >> /etc/cloud/cloud.cfg << 'EOF'
#
# Create the 'chef' user with:
#   * password-less sudoers access
#   * password 'Cod3Can!'
users:
  - default
  - name: chef
    homedir: /home/chef
    groups: [wheel, adm, systemd-journal]
    lock_passwd: false
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    shell: /bin/bash
    passwd: \$6\$saltsalt\$J/vBRLUpNxvyLE/HvWGIC2KA6JMo6sgWcYbZmnfg3a/3fPPj1UjTqcNWWOzmstoV2QFicV3651hkujIlu30QO1

#
# Install some editors and pre-requisite packages for docker-ce
#
packages:
  - yum-utils
  - device-mapper-persistent-data
  - lvm2
  - vim
  - nano
  - emacs

#
# Install docker-ce add the chef user to the group, and then start the service
# Add an ohai hints file in case we want to bootstrap this instance, so that
# the node data will contain the true IP address when reporting to the Chef
# Server.
#
# Based on the Password Authentication change above restart the sshd service
#
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
