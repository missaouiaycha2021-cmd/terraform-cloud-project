variable "name_prefix" {
  type        = string
  description = "Préfixe de nommage des ressources (ex: cloud5-dev)"
}

variable "private_db_subnet_ids" {
  type        = list(string)
  description = "IDs des sous-réseaux privés de base de données (au moins deux, zones différentes)"

  validation {
    condition     = length(var.private_db_subnet_ids) >= 2
    error_message = "RDS nécessite au moins deux sous-réseaux dans deux zones."
  }
}

variable "db_sg_id" {
  type        = string
  description = "ID du Security Group de la base de données"
}

variable "db_instance_class" {
  type        = string
  description = "Classe de l'instance RDS"
  default     = "db.t3.micro"

  validation {
    condition     = can(regex("^db\\.", var.db_instance_class))
    error_message = "db_instance_class doit commencer par db. (ex: db.t3.micro)."
  }
}

variable "engine_version" {
  type        = string
  description = "Version majeure de MySQL"
  default     = "8.0"
}

variable "allocated_storage" {
  type        = number
  description = "Stockage alloué en Go"
  default     = 20

  validation {
    condition     = var.allocated_storage >= 20
    error_message = "allocated_storage doit valoir au moins 20 Go."
  }
}

variable "db_name" {
  type        = string
  description = "Nom de la base créée à l'initialisation"
  default     = "appdb"
}

variable "master_username" {
  type        = string
  description = "Nom de l'administrateur de la base"
  default     = "appadmin"
}

variable "manage_master_password" {
  type        = bool
  description = "true : AWS Secrets Manager gère le mot de passe. false : il est fourni par master_password"
  default     = false
}

variable "master_password" {
  type        = string
  description = "Mot de passe administrateur (utilisé si manage_master_password = false). À fournir par TF_VAR_db_password, jamais dans Git"
  default     = null
  sensitive   = true
}

variable "multi_az" {
  type        = bool
  description = "Déploie un standby dans une autre zone (payant)"
  default     = false
}

variable "backup_retention_period" {
  type        = number
  description = "Nombre de jours de conservation des sauvegardes automatiques"
  default     = 1
}