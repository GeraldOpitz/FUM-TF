variable "project_name" {
  description = "Project name to tag resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR to be used for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_1" {
  description = "CIDR block for the first public subnet"
  type        = string
}

variable "subnet_cidr_2" {
  description = "CIDR block for the second public subnet"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR to be used for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Abailability zone for the subnet"
  type        = string
  default     = "us-east-1b"
}

variable "app_port" {
  description = "Application port for Flask app"
  type        = number
  default     = 5000
}

variable "db_port" {
  description = "PostgreSQL database port"
  type        = number
  default     = 5432
}

variable "subnet_cidr" {
  description = "Subnet CIDR for DB security group"
  type        = string
  default     = "10.0.1.0/24"
}
