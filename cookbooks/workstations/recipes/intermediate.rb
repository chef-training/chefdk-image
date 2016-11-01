#
# Cookbook Name:: workstations
# Recipe:: intermediate
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# This course a combination of the TDD course and the Extending Cookbooks Course

# The TDD course takes care of the core requirements for the environment
include_recipe "#{cookbook_name}::tdd_cookbook_development"

directory '/home/chef/day_2' do
  user 'chef'
  group 'chef'
end

git '/home/chef/extending_cookbooks-repo' do
  repository 'https://github.com/chef-training/extending_cookbooks-repo.git'
  revision 'master'
  user 'chef'
  group 'chef'
  notifies :run, 'execute[copy cookbook to home]', :immediately
end

directory '/home/chef/extending_cookbooks-repo' do
  recursive true
  action :nothing
end

execute 'copy cookbook to home' do
  command 'cp -R /home/chef/extending_cookbooks-repo/cookbooks/httpd /home/chef/day_2/httpd'
  action :nothing
  notifies :run, 'execute[set correct permissions on cookbook]', :immediately
end

execute 'set correct permissions on cookbook' do
  command 'chown -R chef:chef /home/chef/day_2/httpd'
  action :nothing
  notifies :delete, 'directory[/home/chef/extending_cookbooks-repo]', :immediately
end
