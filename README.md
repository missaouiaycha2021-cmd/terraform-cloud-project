# Terraform Cloud Project

Plateforme Web hautement disponible sur AWS, décrite en Terraform (modules et environnements) et contrôlée par un pipeline GitHub Actions.

## Architecture

- VPC `10.20.0.0/16` sur deux zones de disponibilité
- 2 sous-réseaux publics (ALB, NAT Gateway), 2 privés applicatifs, 2 privés base de données
- Application Load Balancer, Launch Template et Auto Scaling Group (2 à 4 instances nginx)
- RDS MySQL privé et chiffré
- Bucket S3 applicatif et bucket S3 d'état Terraform (versioning, chiffrement, accès public bloqué)

Le schéma se trouve dans `docs/architecture.png`.

## Prérequis

- Terraform 1.10 ou plus (`use_lockfile`), AWS CLI, Git
- Un laboratoire AWS Academy démarré (régions `us-east-1` ou `us-west-2`)

## Authentification (sans secret dans Git)

Copiez les identifiants du Learner Lab (AWS Details > AWS CLI) dans `~/.aws/credentials`. Ils expirent à chaque session. Le mot de passe RDS se fournit par variable d'environnement :

```bash
export TF_VAR_db_password='MotDePasseLong-Aleatoire'
```

## Utilisation

```bash
./scripts/bootstrap-backend.sh          # une seule fois : bucket d'état
cd environments/dev
cp terraform.tfvars.example terraform.tfvars   # remplir owner et bucket_suffix
terraform init
terraform plan -out=tfplan
terraform apply tfplan
terraform output alb_url
terraform destroy                        # après la démonstration
```

## Modules

| Module | Rôle |
|---|---|
| `network` | VPC, sous-réseaux, Internet Gateway, NAT Gateway, routage |
| `security` | Security Groups et profil d'instance |
| `load-balancer` | ALB, listener, Target Group, health check |
| `compute` | Launch Template, Auto Scaling Group, scaling CPU |
| `database` | RDS MySQL, subnet group, paramètres |
| `storage` | Bucket S3 chiffré avec versioning |

## Variables et sorties principales

Variables : `aws_region`, `environment`, `project_name`, `owner`, `vpc_cidr`, `instance_type`, `min_size`, `max_size`, `db_instance_class`, `db_multi_az`, `db_password` (sensible).
Sorties : `alb_url`, `db_endpoint`, `app_bucket_name`, `autoscaling_group_name`.

## CI/CD

À chaque Pull Request : `fmt -check`, `init`, `validate`, puis `plan` pour dev, test et prod, avec le plan publié en artefact. L'`apply` se lance manuellement (workflow_dispatch) depuis `main`, avec validation requise pour test et prod. Secrets requis : `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`, `DB_PASSWORD` ; variables : `OWNER`, `BUCKET_SUFFIX`.

## Coûts et limites

Voir `docs/couts.md`. L'ALB, la NAT Gateway, les EC2 et RDS sont facturés : détruire après chaque démonstration. Limites : HTTP uniquement, mot de passe RDS stocké dans l'état (bucket chiffré), identifiants AWS Academy temporaires.

## Dépannage

| Problème | Solution |
|---|---|
| `connection reset by peer` à l'init | Relancer, ou utiliser un cache de plugins (`plugin_cache_dir`) |
| Bucket d'état introuvable | Lancer `bootstrap-backend.sh`, vérifier le nom dans `backend.tf` |
| `ExpiredToken` | Recopier les identifiants du Learner Lab |
| Cibles *Unhealthy* | Attendre 3 minutes, vérifier la NAT Gateway et `user_data.sh` |
| Nom de bucket déjà pris | Changer `bucket_suffix` |