variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}
variable "profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = "admin"
}
