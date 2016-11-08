#
# Cookbook Name:: workstations
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.


# ChefDK is automatically installed by Packer during the AMI creation

execute "apt-get update"

package "docker.io"

service "docker.io" do
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

packages_attendees_will_install = %w[ vim nano emacs git ]

packages_attendees_will_install.each do |name|
  package name do
    action :remove
  end
end

# SSH config to allow for password login
service 'ssh'

template '/etc/ssh/sshd_config' do
  source 'debian-sshd_config.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, "service[ssh]"
end

