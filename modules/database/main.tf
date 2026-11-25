# ---------------------------------------------------------------
# Groupe de sous-réseaux privés
# ---------------------------------------------------------------
resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-db-subnets"
  subnet_ids = var.private_db_subnet_ids

  tags = {
    Name = "${var.name_prefix}-db-subnets"
  }
}

# ---------------------------------------------------------------
# Paramètres du moteur
# ---------------------------------------------------------------
resource "aws_db_parameter_group" "this" {
  name_prefix = "${var.name_prefix}-mysql-"
  family      = "mysql${var.engine_version}"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  tags = {
    Name = "${var.name_prefix}-mysql-params"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ---------------------------------------------------------------
# Instance RDS : privée, chiffrée, sans accès public
# ---------------------------------------------------------------
resource "aws_db_instance" "this" {
  identifier = "${var.name_prefix}-db"

  engine         = "mysql"
  engine_version = var.engine_version
  instance_class = var.db_instance_class

  allocated_storage = var.allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.master_username

  manage_master_user_password = var.manage_master_password ? true : null
  password                    = var.manage_master_password ? null : var.master_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_sg_id]
  parameter_group_name   = aws_db_parameter_group.this.name

  publicly_accessible = false
  multi_az            = var.multi_az

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = true
  deletion_protection     = false
  apply_immediately       = true

  tags = {
    Name = "${var.name_prefix}-db"
  }

  lifecycle {
    precondition {
      condition     = var.manage_master_password || var.master_password != null
      error_message = "Fournissez master_password (TF_VAR_db_password) ou activez manage_master_password."
    }
  }
}