
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

packages_attendees_will_install = %w[ cowsay git tree ]

packages_attendees_will_install.each do |name|
  describe package(name) do
    it { should_not be_installed }
  end
end

hints_file = '/etc/chef/ohai/hints/ec2.json'

describe file(hints_file) do
  its('content') { should eq "{}\n" }
end
