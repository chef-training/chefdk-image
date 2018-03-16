
# variable for the ami I want to create
# let the user enter it

# ami-0a381e9274ee9f1e5

variable "base_ami" { }
# variable "aws_access_key" { }
# variable "aws_secret_key" { }
variable "aws_region" { default = "us-east-1" }
variable "aws_availability_zone" { default = "a" }

provider "aws" {
  # access_key = "${var.aws_access_key}"
  # secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}


resource "aws_instance" "ace_of_base" {
    ami = "${var.base_ami}"
    instance_type = "t2.micro"
    associate_public_ip_address = true
}

output "i-saw-the-sign-and-it-opened-up-my-mind" {
  value = "${aws_instance.ace_of_base.public_ip}"
}
