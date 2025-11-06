terraform {
  backend "s3" {
    bucket = "terraform-states-fum"
    key    = "environments/prod/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
