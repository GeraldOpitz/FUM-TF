terraform {
  backend "s3" {
    bucket = "terraform-states-fum"
    key    = "environments/dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
