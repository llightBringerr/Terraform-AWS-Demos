resource "aws_instance" "demo1" {
    ami           = var.ami_id # variable for AMI ID
    instance_type = lookup(var.instance_type, terraform.workspace, "t3.micro") # lookup instance type based on workspace, default to t3.micro

    tags = {
        Name = "DemoInstance1" # Tagging the instance with a name 
    }
}