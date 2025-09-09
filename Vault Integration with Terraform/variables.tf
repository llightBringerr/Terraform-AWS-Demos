variable "ami_id_ubuntu" {
    description = "AMI ID for the vault instance"
    type        = string
}

variable "instance_type" {
    description = "Instance type based on workspace"
    type        = map(string)
    default     = {
        dev  = "t3.micro"
    }
}