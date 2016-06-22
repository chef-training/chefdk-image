#
# Cookbook Name:: workstations
# Recipe:: centos-ssh_config
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

#
# To allow the Sales Engineer team to use this instances effectively with Atom
# employing a remote-sync plugin the number of max sessions and max startups
# needs to be increased to allow lots of file copies to happen simultaneously.
#
ssh_config "*" do
  options 'MaxSessions' => '250', 'MaxStartups' => '250'
end
