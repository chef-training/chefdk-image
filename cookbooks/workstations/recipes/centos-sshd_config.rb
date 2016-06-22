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
append_if_no_line "Update max sessions" do
  path "/etc/ssh/sshd_config"
  line "MaxSessions 250"
end

append_if_no_line "Update max startups" do
  path "/etc/ssh/sshd_config"
  line "MaxStartups 250"
end