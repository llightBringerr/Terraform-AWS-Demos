terraform {
  backend "s3" {
    bucket = "terraform-backend-for-statefiles" # Replace with your S3 bucket name
    key    = "awsdemos/vaultintegration/terraform.tfstate" # Path within the bucket
    region = "ap-south-1"
    dynamodb_table = "terraform-lock" # Replace with your DynamoDB table name for state locking
  }
}