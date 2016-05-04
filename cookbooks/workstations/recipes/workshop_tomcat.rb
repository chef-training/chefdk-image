#
# Cookbook Name:: workstations
# Recipe:: tdd_cookbook_development
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# NOTE: The chefdk install through chef_ingredient fails on CentOS 7. Returning
#       back to installing chefdk through the packer script.
#
# chef_ingredient 'chefdk' do
#   action :install
#   channel :stable
#   version '0.10.0'
# end

include_recipe "#{cookbook_name}::centos-chef_user"

#
# Ensure the package repository is all up-to-date. This is essential
# because sometimes the packages will fail to install because of a
# stale package repository.
#
# @note This command is not idempotent. A better command may existin within the yum cookbook.
#
execute "yum update -y"

needed_packages_for_attendees = %w[ vim nano emacs git tree ]
package needed_packages_for_attendees

include_recipe "#{cookbook_name}::centos-permissions"

include_recipe "#{cookbook_name}::centos-ec2_hints"

remote_file '/tmp/apache-tomcat-8.0.33.tar.gz' do
  source 'http://mirror.sdunix.com/apache/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz'
end

remote_file '/home/chef/tomcat.service' do
  source 'https://raw.githubusercontent.com/chef-training/workshops/master/Tomcat/tomcat.service'
  owner 'chef'
end
