#
# Cookbook Name:: essentials
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.


# ChefDK is automatically installed by Packer during the AMI creation

#
# Ensure the package repository is all up-to-date. This is essential
# because sometimes the packages will fail to install because of a
# stale package repository.
#
execute "yum update -y"

#
# Test Kitchen on AWS requires that Docker is installed.
#
# The correct Docker package is not contained in the standard package repository
# it has to be added through through the Extra Package for Enterprise Linux (EPEL)
# process.
#
# @see https://docs.docker.com/installation/centos/

remote_file "epel-release-6-8.noarch.rpm" do
  source "http://ftp.osuosl.org/pub/fedora-epel/6/i386/epel-release-6-8.noarch.rpm"
end

#
# Load the EPEL
#
# @note This command is not idempotent
#
execute "rpm -ivh epel-release-6-8.noarch.rpm"

#
# Remove docker if it happens to be installed in the package repository.
# Because we need to install a different package name on CentOS.
#
# @note This command is not idempotent
#
execute "yum -y remove docker"

# Install the correct Docker Package from the EPEL.
package "docker-io"

# The service name for docker-io is named docker.
service "docker" do
  action [ :start, :enable ]
end

#
# Test Kitchen does not automatically ship with the gem that allows it to talk
# with Docker. This will add the necessary gem for Test Kitchen to use Docker.
gem_package "kitchen-docker"

#
# Create a 'chef' user with the password 'chef'.
#
# Yes, we are hard-coding the password here in the recipe. These instances are
# not meant to be secure. While the instance is up and running we are relying
# on security through obfuscation.
#
# @note this is not how you should manage your Linux instances
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
# Allow password-less sudoers access to the chef user.
#
# @note this custom resource is from the sudo cookbook
#
sudo 'chef' do
  template "chef-sudoer.erb"
end

#
# Instances for security disable password login. We want to make it easy for
# learners to connect to these instances with the very unsecure user name and
# password that we have provided.
#
# @note This is quick-and-dirty solution to enable Password Authentication.
#   Instead of depending on another cookbook to provide a recipe or custom
#   resource to manage this file.
#
execute "sed 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh_config > /etc/ssh_config"


packages_attendees_will_install = %w[ vim nano emacs git ]

package packages_attendees_will_install do
  action :remove
end

#
# These images are being created on EC2 and I have found that often
# times Ohai is unable to determine that the system is an EC2 instance.
#
# This hint file is important because without it the learner will not be able
# to retrieve the public hostname and IP address from the node data from Ohai.
#
# @note this hint file is only necessary when working on EC2.

directory '/etc/chef/ohai/hints' do
  recursive true
end

file '/etc/chef/ohai/hints/ec2.json' do
  content '{}'
end


#
# Stop and disable iptables.
#
# @note this is not how you should manage your Linux instances
#
service "iptables" do
  action [ :stop, :disable ]
end

#
# Disable SELINUX context
#
# This is essential when you want to create the clowns/bears
# site content from the non-standard directories and ports. While the current
# content does not have those exercises it is now possible that they could be
# done with the selinux now disabled.
#
# @note this is not how you should manage your Linux instances
#
template "/etc/selinux/config" do
  source "selinux-config.erb"
  mode "0644"
end
