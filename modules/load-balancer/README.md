# Module `load-balancer`

Crée l'Application Load Balancer public, son Target Group avec health check et le listener HTTP.

## Ce qui est créé

| Ressource | Détail |
|---|---|
| `aws_lb` | ALB internet-facing dans les sous-réseaux publics |
| `aws_lb_target_group` | Cible les instances sur le port applicatif, avec health check |
| `aws_lb_listener` | Listener HTTP 80 qui redirige vers le Target Group |

## Utilisation

```hcl
module "load_balancer" {
  source            = "../../modules/load-balancer"
  name_prefix       = local.name_prefix
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
}
```

## Entrées

| Nom | Type | Défaut | Description |
|---|---|---|---|
| `name_prefix` | `string` | n/a | Préfixe de nommage |
| `vpc_id` | `string` | n/a | ID du VPC |
| `public_subnet_ids` | `list(string)` | n/a | Sous-réseaux publics, au moins deux (validé) |
| `alb_sg_id` | `string` | n/a | Security Group de l'ALB |
| `app_port` | `number` | `80` | Port des instances (validé) |
| `health_check_path` | `string` | `"/"` | Chemin du health check |
| `deregistration_delay` | `number` | `30` | Délai de retrait d'une instance (s) |

## Sorties

| Nom | Description |
|---|---|
| `alb_dns_name` | URL de l'ALB |
| `alb_arn` | ARN de l'ALB |
| `target_group_arn` | Target Group à lier à l'Auto Scaling Group |

## Coûts

L'ALB est facturé à l'heure plus le trafic : à détruire après la démonstration.

## Limites connues

- Listener HTTP uniquement : le HTTPS demande un certificat ACM (variable `enable_https` du module `security`).
- Le nom de l'ALB et du Target Group est limité à 32 caractères : gardez un `name_prefix` court.