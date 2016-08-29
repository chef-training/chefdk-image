#
# Cookbook Name:: workstations
# Recipe:: essentials
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

chef_ingredient 'chefdk' do
  action :install
  channel :stable
  version '0.17.17'
end

include_recipe "#{cookbook_name}::centos-chef_user"

#
# Ensure the package repository is all up-to-date. This is essential
# because sometimes the packages will fail to install because of a
# stale package repository.
#
# @note This command is not idempotent. A better command may exist within the yum cookbook.
#
execute "yum update -y"

needed_packages_for_attendees = %w[ vim nano emacs ]
package needed_packages_for_attendees

packages_attendees_will_install = %w[ cowsay git tree ]
package packages_attendees_will_install do
  action :remove
end

include_recipe "#{cookbook_name}::centos-docker"

include_recipe "#{cookbook_name}::centos-permissions"

include_recipe "#{cookbook_name}::centos-ssh_config"

include_recipe "#{cookbook_name}::centos-ec2_hints"
