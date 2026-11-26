variable "aws_region" {
  type        = string
  description = "Région AWS de déploiement"
  default     = "us-east-1"
}

variable "availability_zones" {
  type        = list(string)
  description = "Zones de disponibilité utilisées (au moins deux)"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "environment" {
  type        = string
  description = "Nom de l'environnement"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "L'environnement doit être dev, test ou prod."
  }
}

variable "project_name" {
  type        = string
  description = "Préfixe de nommage du projet"
  default     = "cloud5"
}

variable "owner" {
  type        = string
  description = "Propriétaire des ressources (tag Owner)"
}

variable "vpc_cidr" {
  type        = string
  description = "Bloc CIDR du VPC"
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR des sous-réseaux publics"
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_app_subnet_cidrs" {
  type        = list(string)
  description = "CIDR des sous-réseaux applicatifs"
  default     = ["10.20.11.0/24", "10.20.12.0/24"]
}

variable "private_db_subnet_cidrs" {
  type        = list(string)
  description = "CIDR des sous-réseaux base de données"
  default     = ["10.20.21.0/24", "10.20.22.0/24"]
}

variable "instance_type" {
  type        = string
  description = "Type d'instance EC2"
  default     = "t3.micro"
}

variable "min_size" {
  type        = number
  description = "Nombre minimal d'instances"
  default     = 2
}

variable "max_size" {
  type        = number
  description = "Nombre maximal d'instances"
  default     = 4
}

variable "db_instance_class" {
  type        = string
  description = "Classe de l'instance RDS"
  default     = "db.t3.micro"
}

variable "db_multi_az" {
  type        = bool
  description = "Déploie RDS en Multi-AZ (payant)"
  default     = false
}

variable "bucket_suffix" {
  type        = string
  description = "Suffixe d'unicité du bucket applicatif (ex: votre identifiant)"
}

variable "db_password" {
  type        = string
  description = "Mot de passe RDS. À fournir par TF_VAR_db_password, jamais dans Git"
  sensitive   = true
}