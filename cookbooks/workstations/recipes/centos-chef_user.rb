#
# Cookbook Name:: workstations
# Recipe:: centos-chef_user
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

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
  manage_home true
  password '$1$seaspong$H8HrJvbldlc6GJidnv6J30'
  action :create
end

#
# Allow password-less sudoers access to the chef user.
#
# @note this custom resource is from the sudo cookbook
#
sudo "chef" do
  template "chef-sudoer.erb"
end

#
# To use the Chef development kit version of Ruby as the default Ruby,
# edit the $PATH and GEM environment variables to include paths to the
# Chef development kit. For example, on a machine that runs Bash, run:
#
execute "echo 'eval \"$(chef shell-init bash)\"' >> /home/chef/.bash_profile"
