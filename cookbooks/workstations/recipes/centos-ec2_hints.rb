#
# Cookbook Name:: workstations
# Recipe:: centos-ec2_hints
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

#
# These images are being created on EC2 and I have found that often
# times Ohai is unable to determine that the system is an EC2 instance.
#
# This hint file is important because without it the learner will not be able
# to retrieve the public hostname and IP address from the node data from Ohai.
#
#
# @note this hint file is only necessary when working on EC2.

directory "/etc/chef/ohai/hints" do
  recursive true
end

file "/etc/chef/ohai/hints/ec2.json" do
  content '{}'
end
