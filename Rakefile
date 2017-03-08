require 'yaml'
require 'json'

namespace :ami do
  desc 'Create an instance of the specified AMI (AMI_ID=????????)'
  task :create do
    ami_id = fetch_ami_id

    puts "Creating instance of #{ami_id}"
    create_command = "aws ec2 run-instances --image-id #{ami_id} --count 1 --instance-type t1.micro --security-group-ids #{all_open_security_group}"
    result = JSON.parse `#{create_command}`

    instance_id = result["Instances"][0]["InstanceId"]
    tag = "#{ENV['USER']}-created-#{ami_id}"
    puts "Assigning Instance (#{instance_id} from AMI: #{ami_id}) the tag #{tag}"
    tag_command = "aws ec2 create-tags --resources #{instance_id} --tags Key=Name,Value=\"#{tag}\""
    `#{tag_command}`
  end

  desc 'Grant Subscribers access to Image (AMI_ID=????????)'
  task :grant do
    ami_id = fetch_ami_id

    aws_subscribers = YAML.load(File.read('./subscribers.yml'))["aws"]

    aws_subscribers.each do |user_id|
      puts "Granting #{user_id} launch permission to #{ami_id}"
      `aws ec2 modify-image-attribute --image-id #{ami_id} --launch-permission "{\\"Add\\":[{\\"UserId\\":\\"#{user_id}\\"}]}"`
    end
  end

  task :start do
    ami_id = fetch_ami_id

    command = "aws ec2 run-instances --image-id #{ami_id} --count 1 --instance-type m4.large --key-name training-ec2-keypair --security-groups default-all-open"

    puts `#{command}`
  end
end

namespace :instance do
  desc 'Describe an instance to get the public IP ADDRESS (INSTANCE_ID=???????)'
  task :describe do
    instance_id = fetch_instance_id
    describe_command = "aws ec2 describe-instances --instance-ids #{instance_id}"
    result = JSON.parse `#{describe_command}`
    # puts result
    puts "ssh #{result["Reservations"][0]["Instances"][0]["PublicDnsName"]}"
  end
end

def fetch_ami_id
  ami_id = ENV['AMI_ID']
  unless ami_id
    puts "No AMI_ID environment variable has been specified"
    exit
  end
  ami_id
end

def fetch_instance_id
  instance_id = ENV['INSTANCE_ID']
  unless instance_id
    puts "No INSTANCE_ID environment variable has been specified"
    exit
  end
  instance_id
end


def all_open_security_group
  # NOTE: This value is a hard-coded value for a security group found in the
  # Training AWS account. It is fairly generic to allow SSH and other forms of
  # access to the instance.
  "sg-bd967dda"
end
