#
# Cookbook Name:: workstations
# Recipe:: centos-docker
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

#
# Test Kitchen on AWS requires that Docker is installed.
#
# The correct Docker package is not contained in the standard package repository
# it has to be added through through the Extra Package for Enterprise Linux (EPEL)
# process.
#
# @see https://docs.docker.com/installation/centos/

remote_file "epel-release-6-8.noarch.rpm" do
  source "http://ftp.osuosl.org/pub/fedora-epel/6/i386/epel-release-6-8.noarch.rpm"
end

#
# Load the EPEL
#
# @note This command is not idempotent. This will break the instance if run a second time.
#
execute "rpm -ivh epel-release-6-8.noarch.rpm"

#
# Remove docker if it happens to be installed in the package repository.
# Because we need to install a different package name on CentOS.
#
# @note This command is not idempotent. A better command may existin within the yum cookbook.
#
execute "yum -y remove docker"

# Install the correct Docker Package from the EPEL.
package "docker-io"

# The service name for docker-io is named docker.
service "docker" do
  action [ :start, :enable ]
end


include_recipe "#{cookbook_name}::centos-chef_user"

#
# Test Kitchen does not automatically ship with the gem that allows it to talk
# with Docker. This will add the necessary gem for Test Kitchen to use Docker.
#
# @note install the kitchen-docker gem for the chef user. This workaround was
#       required to get the right user to have it installed. Without it the root
#       user was getting the kitchen-docker gem
#
execute 'sudo su -c "chef exec gem install kitchen-docker" -s /bin/sh chef'

#
# To allow the chef user to properly manage docker for the purposes of
# integration testing with Test Kitchen.
#
group 'dockerroot' do
  members 'chef'
end


#
# To allow the chef user to properly manage docker for the purposes of
# integration testing with Test Kitchen.
# /var/run/docker.sock
#
# file '/var/run/docker.sock' do
#   owner 'dockerroot'
# end

execute 'chown root:dockerroot /var/run/docker.sock'
