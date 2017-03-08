#
# Cookbook Name:: workstations
# Recipe:: extending_cookbooks
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# This course has all the base requirements of the TDD course
# with the exception that we are starting the learners with the ark cookbook
include_recipe "#{cookbook_name}::tdd_cookbook_development"

git '/home/chef/elegant_tests-repo' do
  repository 'https://github.com/chef-training/elegant_tests-repo.git'
  revision 'master'
  user 'chef'
  group 'chef'
  notifies :run, 'execute[copy cookbook to home]', :immediately
end

directory '/home/chef/elegant_tests-repo' do
  recursive true
  action :nothing
end

execute 'copy cookbook to home' do
  command 'cp -R /home/chef/elegant_tests-repo/cookbooks/ark /home/chef/ark'
  action :nothing
  notifies :run, 'execute[set correct permissions on cookbook]', :immediately
end

execute 'set correct permissions on cookbook' do
  command 'chown -R chef:chef /home/chef/ark'
  action :nothing
  notifies :delete, 'directory[/home/chef/elegant_tests-repo]', :immediately
end
