module "flask_db" {
  source              = "../../modules/ec2"
  name                = "Flask-DB"
  ami_id              = "ami-0c02fb55956c7d316"
  instance_type       = "t3.micro"
  tags = {
    Environment = "dev"
    Role        = "Database"
  }
}

module "flask_app" {
  source              = "../../modules/ec2"
  name                = "Flask-App-User-Manager"
  ami_id              = "ami-0c02fb55956c7d316"
  instance_type       = "t3.micro"
  tags = {
    Environment = "dev"
    Role        = "Application"
  }
}
