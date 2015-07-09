user 'chef' do
  action :create
  password 'P@ssW0rd!' # Really!?
end

group 'Administrators' do
  action :modify
  members 'chef'
  append true
end

cookbook_file 'config.xml' do
 path 'C:\Program Files\Amazon\Ec2ConfigService\Settings\config.xml'
 action :create
end