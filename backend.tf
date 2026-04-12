terraform {
  backend "s3" {
    bucket         = "banking-app-tfstate-109804294707"
    key            = "banking-app/prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "banking-app-terraform-lock"
  }
}
