#
# Cookbook Name:: workstations
# Recipe:: intermediate
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# This course a combination of the TDD course and the Extending Cookbooks Course

# The TDD course takes care of the core requirements for the environment
include_recipe "#{cookbook_name}::tdd_cookbook_development"

git '/home/chef/chef-intermediate-repo' do
  repository 'https://github.com/chef-training/chef-intermediate-repo.git'
  revision 'master'
  user 'chef'
  group 'chef'
  notifies :run, 'execute[copy cookbook to home]', :immediately
end

directory '/home/chef/chef-intermediate-repo' do
  recursive true
  action :nothing
end

execute 'copy cookbook to home' do
  command 'cp -R /home/chef/chef-intermediate-repo/apache /home/chef/apache'
  action :nothing
  notifies :run, 'execute[set correct permissions on cookbook]', :immediately
end

execute 'set correct permissions on cookbook' do
  command 'chown -R chef:chef /home/chef/apache'
  action :nothing
  notifies :delete, 'directory[/home/chef/chef-intermediate-repo]', :immediately
end
