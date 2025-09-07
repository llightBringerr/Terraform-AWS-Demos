resource "aws_instance" "demo1" {
    ami           = var.ami_id # variable for AMI ID
    instance_type = var.instance_type # variable for instance type

    tags = {
        Name = "DemoInstance1" # Tagging the instance with a name 
    }
}