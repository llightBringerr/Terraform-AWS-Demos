resource "aws_instance" "demo1" {
    ami           = var.ami_id # variable for AMI ID
    instance_type = var.instance_type # variable for instance type
    vpc_security_group_ids = [aws_security_group.demo1sg.id] # Reference to the security group created

    tags = {
        Name = "DemoInstance1" # Tagging the instance with a name 
    }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "demo1sg" {
    vpc_id = data.aws_vpc.default.id # Reference to the default VPC
    name   = "DemoSG" # Name of the security group

   ingress {
        from_port   = 22 # Allow SSH access
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # Open to all IPs for demonstration purposes
    }

    egress {
        from_port   = 0 # Allow all outbound traffic
        to_port     = 0
        protocol    = "-1" # -1 means all protocols
        cidr_blocks = ["0.0.0.0/0"] # Open to all IPs
    }

}