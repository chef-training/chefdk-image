#
# Cookbook Name:: workstations
# Recipe:: compliance
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

chef_ingredient 'chefdk' do
  action :install
  channel :stable
  version '0.11.2'
end

execute "chef exec gem install inspec -v 0.14.2"

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

include_recipe "#{cookbook_name}::centos-docker"

include_recipe "#{cookbook_name}::centos-permissions"

include_recipe "#{cookbook_name}::centos-ec2_hints"
