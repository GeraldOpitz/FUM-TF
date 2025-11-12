variable "name" {
  description = "Insance name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "Type of instance"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID where EC2 will be created"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID for the EC2 instance"
  type        = string
}

variable "tags" {
  description = "Additional tags for the instance"
  type        = map(string)
  default     = {}
}

variable "key_name" {
  description = "SSH Key Name for the instance"
  type        = string
}
