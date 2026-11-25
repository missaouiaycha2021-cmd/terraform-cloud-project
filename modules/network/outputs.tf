output "vpc_id" {
  description = "ID du VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "Bloc CIDR du VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "IDs des sous-réseaux publics (ALB)"
  value       = aws_subnet.public[*].id
}

output "private_app_subnet_ids" {
  description = "IDs des sous-réseaux privés applicatifs (instances)"
  value       = aws_subnet.private_app[*].id
}

output "private_db_subnet_ids" {
  description = "IDs des sous-réseaux privés de base de données (RDS)"
  value       = aws_subnet.private_db[*].id
}

output "nat_gateway_public_ip" {
  description = "IP publique de la NAT Gateway (null si désactivée)"
  value       = one(aws_eip.nat[*].public_ip)
}