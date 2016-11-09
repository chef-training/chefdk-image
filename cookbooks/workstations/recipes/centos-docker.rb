#
# Cookbook Name:: workstations
# Recipe:: centos-docker
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

#
# Start the docker service
#
docker_service 'default' do
  action [:create, :start]
end

include_recipe "#{cookbook_name}::centos-chef_user"

#
# Test Kitchen does not automatically ship with the gem that allows it to talk
# with Docker. This will add the necessary gem for Test Kitchen to use Docker.
#
gem_package 'kitchen-docker' do
  gem_binary '/opt/chefdk/embedded/bin/gem'
  options '--no-user-install'
  notifies :restart, 'docker_service[default]'
end

#
# To allow the chef user to properly manage docker for the purposes of
# integration testing with Test Kitchen.
#
group 'docker' do
  members 'chef'
  append true
end
