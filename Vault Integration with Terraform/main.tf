resource "aws_instance" "vault_instance" {
    ami           = var.ami_id_ubuntu # variable for AMI ID
    instance_type = lookup(var.instance_type, terraform.workspace, "t3.micro") # lookup instance type based on workspace, default to t3.micro

    tags = {
        Name = "VaultInstance" # Tagging the instance with a name 
    }
}