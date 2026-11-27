output "alb_url" {
  description = "URL du Load Balancer"
  value       = "http://${module.load_balancer.alb_dns_name}"
}

output "db_endpoint" {
  description = "Adresse de la base RDS (privée)"
  value       = module.database.endpoint
}

#output "app_bucket_name" {
#  description = "Nom du bucket applicatif"
#  value       = module.storage.bucket_name
#}

output "autoscaling_group_name" {
  description = "Nom de l'Auto Scaling Group"
  value       = module.compute.autoscaling_group_name
}