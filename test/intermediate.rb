
describe user('chef') do
  it { should exist }
  its('groups') { should include 'docker' }
end

describe sshd_config do
  its('PasswordAuthentication') { should eq 'yes' }
end

describe command('chef') do
  it { should exist }
end

editors = %w[vim-minimal nano emacs]

editors.each do |editor|
  describe package(editor) do
    it { should be_installed }
  end
end

describe package('docker-ce') do
  it { should be_installed }
end

hints_file = '/etc/chef/ohai/hints/ec2.json'

describe file(hints_file) do
  its('content') { should eq "{}\n" }
end

describe file('/home/chef/apache') do
  it { should exist }
  it { should be_directory }
end
