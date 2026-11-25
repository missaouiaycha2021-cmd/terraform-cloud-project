variable "name_prefix" {
  type        = string
  description = "Préfixe de nommage des ressources (ex: cloud5-dev)"
}

variable "vpc_id" {
  type        = string
  description = "ID du VPC dans lequel créer le Target Group"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "IDs des sous-réseaux publics où placer l'ALB (au moins deux)"

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "L'ALB nécessite au moins deux sous-réseaux publics."
  }
}

variable "alb_sg_id" {
  type        = string
  description = "ID du Security Group du Load Balancer"
}

variable "app_port" {
  type        = number
  description = "Port des instances applicatives"
  default     = 80

  validation {
    condition     = var.app_port >= 1 && var.app_port <= 65535
    error_message = "app_port doit être compris entre 1 et 65535."
  }
}

variable "health_check_path" {
  type        = string
  description = "Chemin utilisé par le health check"
  default     = "/"
}

variable "deregistration_delay" {
  type        = number
  description = "Délai (secondes) avant retrait d'une instance du Target Group"
  default     = 30
}