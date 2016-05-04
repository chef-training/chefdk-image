#
# Cookbook Name:: workstations
# Recipe:: centos-permissions
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


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


#
# CentOS 7.1
#

template '/etc/ssh/ssh_config' do
  source 'ssh_config.erb'
end

template '/etc/ssh/sshd_config' do
  source 'sshd_config.erb'
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
