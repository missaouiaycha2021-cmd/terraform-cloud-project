output "alb_sg_id" {
  description = "ID du Security Group du Load Balancer"
  value       = aws_security_group.alb.id
}

output "app_sg_id" {
  description = "ID du Security Group des instances applicatives"
  value       = aws_security_group.app.id
}

output "db_sg_id" {
  description = "ID du Security Group de la base de données"
  value       = aws_security_group.db.id
}

output "instance_profile_name" {
  description = "Nom du profil d'instance IAM existant à attacher au Launch Template"
  value       = var.instance_profile_name
}