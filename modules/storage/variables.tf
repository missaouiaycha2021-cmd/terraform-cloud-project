variable "name_prefix" {
  type        = string
  description = "Préfixe de nommage des ressources (ex: cloud5-dev)"
}

variable "bucket_suffix" {
  type        = string
  description = "Suffixe pour rendre le nom du bucket unique dans tout AWS (ex: votre identifiant)"

  validation {
    condition     = can(regex("^[a-z0-9-]{3,20}$", var.bucket_suffix))
    error_message = "bucket_suffix : 3 à 20 caractères, minuscules, chiffres et tirets."
  }
}

variable "force_destroy" {
  type        = bool
  description = "Autorise terraform destroy à supprimer le bucket même s'il contient des objets"
  default     = true
}

variable "logs_expiration_days" {
  type        = number
  description = "Nombre de jours avant suppression des objets du préfixe logs/"
  default     = 30

  validation {
    condition     = var.logs_expiration_days >= 1
    error_message = "logs_expiration_days doit être supérieur ou égal à 1."
  }
}

variable "noncurrent_version_expiration_days" {
  type        = number
  description = "Nombre de jours avant suppression des anciennes versions d'objets"
  default     = 30

  validation {
    condition     = var.noncurrent_version_expiration_days >= 1
    error_message = "noncurrent_version_expiration_days doit être supérieur ou égal à 1."
  }
}