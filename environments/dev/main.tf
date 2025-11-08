module "flask_db" {
  source              = "../../modules/ec2"
  name                = "Flask-DB"
  ami_id              = "ami-0c02fb55956c7d316"
  instance_type       = "t3.micro"
  subnet_id           = module.networking.private_subnet_1_id
  security_group_id   = module.networking.flask_db_sg_id
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
  subnet_id           = module.networking.public_subnet_1_id
  security_group_id   = module.networking.flask_app_sg_id
  tags = {
    Environment = "dev"
    Role        = "Application"
  }
}

module "networking" {
  source       = "../../modules/networking"
  project_name = "FUM"
  vpc_cidr     = "10.0.0.0/16"

  subnet_cidr_1 = "10.0.1.0/24"
  subnet_cidr_2 = "10.0.2.0/24"

  app_port = 5000
  db_port  = 5432
}
