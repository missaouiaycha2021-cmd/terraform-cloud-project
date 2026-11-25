output "endpoint" {
  description = "Adresse de connexion à la base (hôte:port)"
  value       = aws_db_instance.this.endpoint
}

output "address" {
  description = "Nom d'hôte de la base"
  value       = aws_db_instance.this.address
}

output "port" {
  description = "Port de la base"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Nom de la base"
  value       = aws_db_instance.this.db_name
}

output "master_user_secret_arn" {
  description = "ARN du secret Secrets Manager (null si le mot de passe est fourni)"
  value       = one(aws_db_instance.this.master_user_secret[*].secret_arn)
}