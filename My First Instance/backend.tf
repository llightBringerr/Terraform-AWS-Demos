# Configure the backend for storing Terraform state in AWS S3

terraform {
  backend "s3" {
    bucket = "terraform-backend-for-statefiles" # Replace with your S3 bucket name
    key    = "awsdemos/myfirstinstance/terraform.tfstate" # Path within the bucket
    region = "ap-south-1"
    dynamodb_table = "terraform-lock" # Replace with your DynamoDB table name for state locking
  }
}