#
# Cookbook Name:: fundamentals
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.


# ChefDK is automatically installed by Packer during the AMI creation

execute "yum update -y"

# https://docs.docker.com/installation/centos/

execute "wget http://ftp.osuosl.org/pub/fedora-epel/6/i386/epel-release-6-8.noarch.rpm"

# This command is not idempotent
execute "rpm -ivh epel-release-6-8.noarch.rpm"

execute "yum -y remove docker"

package "docker-io"

service "docker" do
  action [ :start, :enable ]
end

gem_package "kitchen-docker"

#
# Create a chef user. Yes, that's a password. Yes, that means you know how to login
# No, you don't know which instances are running with that user and password.
#
user 'chef' do
  comment 'ChefDK User'
  home '/home/chef'
  shell '/bin/bash'
  supports :manage_home => true
  password '$1$seaspong$/UREL79gaEZJRXoYPaKnE.'
  action :create
end

#
# Allow password-less sudoers access to the chef user
#
sudo 'chef' do
  template "chef-sudoer.erb"
end

# To allow the chef user to login to the system through SSH
# This was easier than grabbing another cookbook
execute "sed 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh_config > /etc/ssh_config"


packages_attendees_will_install = %w[ vim nano emacs git ]

packages_attendees_will_install.each do |name|
  package name do
    action :remove
  end
end


#
# These images are being created on EC2 and I have found that often
# times Ohai is unable to determine that the system is an EC2 instance.
#

directory '/etc/chef/ohai/hints' do
  recursive true
end

file '/etc/chef/ohai/hints/ec2.json' do
  content '{}'
end

# TODO: There was something about turning off ports blocking and other things
# IPtables & SELinux

service "iptables" do
  action [ :stop, :disable ]
end

service "selinux" do
  action [ :stop, :disable ]
end