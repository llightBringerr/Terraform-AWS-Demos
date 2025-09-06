terraform {
  backend "s3" {
    bucket = "terraform-backend-for-statefiles"
    key    = "awsdemos/myfirstinstance/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-lock"
  }
}