# Define values for variables using terraform.tfvars

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to use"
  type        = map(string)

  default     = {
    dev     = "t3.micro"
    staging = ""
    prod    = ""
  }
}
