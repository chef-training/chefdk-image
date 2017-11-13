#
# Cookbook Name:: workstations
# Recipe:: intermediate
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# This course a combination of the TDD course and the Extending Cookbooks Course

# The TDD course takes care of the core requirements for the environment
include_recipe "#{cookbook_name}::tdd_cookbook_development"

git '/home/chef/apache' do
  repository 'https://github.com/chef-training/chef-intermediate-repo.git'
  revision 'master'
  user 'chef'
  group 'chef'
end

execute 'set correct permissions on cookbook' do
  command 'chown -R chef:chef /home/chef/apache'
end
