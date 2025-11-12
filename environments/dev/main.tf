module "flask_db" {
  source              = "../../modules/ec2"
  name                = "Flask-DB-dev"
  ami_id              = "ami-0ecb62995f68bb549"
  instance_type       = "t3.micro"
  subnet_id           = module.networking.public_subnet_1_id
  security_group_id   = module.networking.flask_db_sg_id
  key_name            = "ec2-db-key"
  tags = {
    Environment = "dev"
    Role        = "Database"
  }
}

module "flask_app" {
  source              = "../../modules/ec2"
  name                = "Flask-App-User-Manager-dev"
  ami_id              = "ami-0ecb62995f68bb549"
  instance_type       = "t3.micro"
  subnet_id           = module.networking.public_subnet_2_id
  security_group_id   = module.networking.flask_app_sg_id
  key_name            = "ec2-app-key"
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
