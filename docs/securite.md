# Choix de sécurité

| Exigence | Mise en œuvre |
|---|---|
| ALB accepte HTTP depuis Internet | SG ALB : port 80 depuis 0.0.0.0/0 |
| Instances accessibles uniquement via l'ALB | SG applicatif : source = SG de l'ALB |
| Base accessible uniquement depuis les instances | SG base : source = SG applicatif, port 3306 |
| Base non publique | `publicly_accessible = false`, sous-réseaux sans route Internet |
| Aucun secret dans Git | Variable `sensitive`, `TF_VAR_db_password`, secrets GitHub, `.gitignore` |
| Chiffrement | RDS, EBS, buckets S3 et état Terraform |
| Accès administratif limité | Aucun SSH ouvert, pas d'IP publique sur les instances |
| IMDSv2 | `http_tokens = "required"` dans le Launch Template |
| IAM moindre privilège | `LabInstanceProfile` imposé par AWS Academy (limite documentée) |
| Buckets S3 privés | Blocage de l'accès public |
| État protégé | Versioning, chiffrement, verrouillage `use_lockfile` |