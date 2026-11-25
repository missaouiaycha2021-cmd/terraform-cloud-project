output "autoscaling_group_name" {
  description = "Nom de l'Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}

output "launch_template_id" {
  description = "ID du Launch Template"
  value       = aws_launch_template.app.id
}

output "ami_id" {
  description = "ID de l'image utilisée par les instances"
  value       = data.aws_ami.al2023.id
}