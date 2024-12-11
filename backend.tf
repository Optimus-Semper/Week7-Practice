terraform {
  backend "s3" {
    bucket = "week6-zuva-bucket-terraform"
    key    = "week7Practice/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt = true
  }
}