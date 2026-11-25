variable "name_prefix" {
  type        = string
  description = "Préfixe de nommage des ressources (ex: cloud5-dev)"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "IDs des sous-réseaux privés applicatifs (au moins deux, zones différentes)"

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "Il faut au moins deux sous-réseaux privés pour répartir les instances sur deux zones."
  }
}

variable "app_sg_id" {
  type        = string
  description = "ID du Security Group des instances applicatives"
}

variable "target_group_arn" {
  type        = string
  description = "ARN du Target Group auquel l'Auto Scaling Group enregistre ses instances"
}

variable "instance_profile_name" {
  type        = string
  description = "Nom du profil d'instance IAM existant (AWS Academy : LabInstanceProfile)"
  default     = "LabInstanceProfile"
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

  validation {
    condition     = var.min_size >= 2
    error_message = "min_size doit valoir au moins 2 (deux instances réparties sur deux zones)."
  }
}

variable "max_size" {
  type        = number
  description = "Nombre maximal d'instances"
  default     = 4

  validation {
    condition     = var.max_size >= 2
    error_message = "max_size doit être supérieur ou égal à 2."
  }
}

variable "desired_capacity" {
  type        = number
  description = "Capacité souhaitée au démarrage (null = min_size)"
  default     = null
}

variable "user_data" {
  type        = string
  description = "Contenu du script de démarrage (user_data.sh), en clair : il est encodé par le module"
}

variable "cpu_target_percent" {
  type        = number
  description = "Utilisation CPU moyenne visée par la politique de scaling"
  default     = 60

  validation {
    condition     = var.cpu_target_percent > 0 && var.cpu_target_percent < 100
    error_message = "cpu_target_percent doit être compris entre 1 et 99."
  }
}

variable "health_check_grace_period" {
  type        = number
  description = "Délai (secondes) avant les health checks, le temps d'installer nginx"
  default     = 180
}