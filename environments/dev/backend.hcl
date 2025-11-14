bucket         = "terraform-states-fum"
key            = "environments/dev/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-locks"
encrypt        = true
