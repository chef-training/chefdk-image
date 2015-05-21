require 'spec_helper'

describe 'fundamentals::default' do

  describe user('chef') do
    it { should exist }
    it { should have_home_directory '/home/chef' }
    it { should have_login_shell '/bin/bash' }
  end

  describe file('/etc/chef/client.pem') do
    it { should_not be_file }
  end

  describe file('/etc/ssh/sshd_config') do
    it { should_not contain('#PasswordAuthentication yes') }
  end

  describe file('/etc/sudoers.d/chef') do
    it { should contain('chef ALL=(ALL) NOPASSWD:ALL') }
  end

  describe package('docker.io') do
    it { should be_installed }
  end

  describe service('docker.io') do
    it { should be_enabled }
    it { should be_running }
  end

  describe command('chef-apply --help') do
    its(:exit_status) { should eq 0 }
  end

  describe command('chef --help') do
    its(:exit_status) { should eq 0 }
  end

  describe command('kitchen --help') do
    its(:exit_status) { should eq 0 }
  end

  describe command('chef gem list kitchen-docker') do
    its(:stdout) { should contain('kitchen docker') }
  end

  describe package("vim") do
    it { should_not be_installed }
  end

  describe package("emacs") do
    it { should_not be_installed }
  end

  describe package("nano") do
    it { should_not be_installed }
  end

  describe package("git") do
    it { should_not be_installed }
  end
end
