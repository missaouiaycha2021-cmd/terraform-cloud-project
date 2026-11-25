variable "name_prefix" {
  type        = string
  description = "Préfixe de nommage des ressources (ex: cloud5-dev)"
}

variable "vpc_id" {
  type        = string
  description = "ID du VPC dans lequel créer les Security Groups"
}

variable "app_port" {
  type        = number
  description = "Port sur lequel les instances applicatives reçoivent le trafic de l'ALB"
  default     = 80

  validation {
    condition     = var.app_port >= 1 && var.app_port <= 65535
    error_message = "app_port doit être compris entre 1 et 65535."
  }
}

variable "db_port" {
  type        = number
  description = "Port de la base de données (3306 pour MySQL, 5432 pour PostgreSQL)"
  default     = 3306

  validation {
    condition     = contains([3306, 5432], var.db_port)
    error_message = "db_port doit valoir 3306 (MySQL) ou 5432 (PostgreSQL)."
  }
}

variable "enable_https" {
  type        = bool
  description = "Ouvre aussi le port 443 sur le Load Balancer (nécessite un certificat)"
  default     = false
}

variable "instance_profile_name" {
  type        = string
  description = "Nom du profil d'instance IAM existant (AWS Academy : LabInstanceProfile)"
  default     = "LabInstanceProfile"
}