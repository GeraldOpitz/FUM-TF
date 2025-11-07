variable "name" {
  description = "Nombre de la instancia"
  type        = string
}

variable "ami_id" {
  description = "AMI ID a usar"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subred donde se desplegará la instancia"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "Lista de security groups"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Etiquetas adicionales"
  type        = map(string)
  default     = {}
}
