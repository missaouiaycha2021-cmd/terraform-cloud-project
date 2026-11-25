variable "name_prefix" {
  type        = string
  description = "Préfixe de nommage des ressources (ex: cloud5-dev)"
}

variable "vpc_cidr" {
  type        = string
  description = "Bloc CIDR du VPC (ex: 10.20.0.0/16)"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr doit être un bloc CIDR valide (ex: 10.20.0.0/16)."
  }
}

variable "availability_zones" {
  type        = list(string)
  description = "Zones de disponibilité utilisées (au moins deux)"

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "Il faut au moins deux zones de disponibilité."
  }
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR des sous-réseaux publics, un par zone"
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_app_subnet_cidrs" {
  type        = list(string)
  description = "CIDR des sous-réseaux privés applicatifs, un par zone"
  default     = ["10.20.11.0/24", "10.20.12.0/24"]
}

variable "private_db_subnet_cidrs" {
  type        = list(string)
  description = "CIDR des sous-réseaux privés de base de données, un par zone"
  default     = ["10.20.21.0/24", "10.20.22.0/24"]
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Crée une NAT Gateway pour la sortie des sous-réseaux privés (payante)"
  default     = true
}