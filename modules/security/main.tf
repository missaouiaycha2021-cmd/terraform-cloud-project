# ---------------------------------------------------------------
# Security Group du Load Balancer : HTTP/HTTPS depuis Internet
# ---------------------------------------------------------------
resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Load Balancer : trafic web depuis Internet"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP depuis Internet"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  count = var.enable_https ? 1 : 0

  security_group_id = aws_security_group.alb.id
  description       = "HTTPS depuis Internet"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id            = aws_security_group.alb.id
  description                  = "Vers les instances applicatives"
  referenced_security_group_id = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = var.app_port
  to_port                      = var.app_port
}

# ---------------------------------------------------------------
# Security Group applicatif : trafic web uniquement depuis l'ALB
# ---------------------------------------------------------------
resource "aws_security_group" "app" {
  name        = "${var.name_prefix}-app-sg"
  description = "Instances applicatives : trafic depuis l'ALB uniquement"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-app-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.app.id
  description                  = "Trafic web depuis le SG du Load Balancer"
  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "tcp"
  from_port                    = var.app_port
  to_port                      = var.app_port
}

resource "aws_vpc_security_group_egress_rule" "app_https" {
  security_group_id = aws_security_group.app.id
  description       = "HTTPS sortant (paquets, SSM, S3)"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "app_http" {
  security_group_id = aws_security_group.app.id
  description       = "HTTP sortant (dépôts de paquets)"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "app_to_db" {
  security_group_id            = aws_security_group.app.id
  description                  = "Vers la base de données"
  referenced_security_group_id = aws_security_group.db.id
  ip_protocol                  = "tcp"
  from_port                    = var.db_port
  to_port                      = var.db_port
}

# ---------------------------------------------------------------
# Security Group de la base : connexions depuis le SG applicatif
# ---------------------------------------------------------------
resource "aws_security_group" "db" {
  name        = "${var.name_prefix}-db-sg"
  description = "Base de données : connexions depuis les instances applicatives"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-db-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id            = aws_security_group.db.id
  description                  = "Connexions depuis le SG applicatif"
  referenced_security_group_id = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = var.db_port
  to_port                      = var.db_port
}