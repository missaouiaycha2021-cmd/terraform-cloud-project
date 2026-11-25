output "alb_dns_name" {
  description = "Nom DNS de l'ALB (URL à ouvrir dans le navigateur)"
  value       = aws_lb.this.dns_name
}

output "alb_arn" {
  description = "ARN de l'ALB"
  value       = aws_lb.this.arn
}

output "target_group_arn" {
  description = "ARN du Target Group, à attacher à l'Auto Scaling Group"
  value       = aws_lb_target_group.app.arn
}