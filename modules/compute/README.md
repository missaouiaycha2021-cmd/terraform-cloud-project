# Module `compute`

Crée le Launch Template, l'Auto Scaling Group (sous-réseaux privés, deux zones) et une politique de scaling sur le CPU.

## Ce qui est créé

| Ressource | Détail |
|---|---|
| `data.aws_ami` | Amazon Linux 2023 la plus récente |
| `aws_launch_template` | Type d'instance, `user_data`, profil IAM, Security Group, IMDSv2, disque chiffré |
| `aws_autoscaling_group` | Entre `min_size` et `max_size` instances, enregistrées au Target Group, health check ELB |
| `aws_autoscaling_policy` | Target tracking sur le CPU moyen |

## Utilisation

```hcl
module "compute" {
  source             = "../../modules/compute"
  name_prefix        = local.name_prefix
  private_subnet_ids = module.network.private_app_subnet_ids
  app_sg_id          = module.security.app_sg_id
  target_group_arn   = module.load_balancer.target_group_arn
  instance_type      = var.instance_type
  min_size           = var.min_size
  max_size           = var.max_size
  user_data          = file("${path.module}/../../scripts/user_data.sh")
}
```

## Entrées

| Nom | Type | Défaut | Description |
|---|---|---|---|
| `name_prefix` | `string` | n/a | Préfixe de nommage |
| `private_subnet_ids` | `list(string)` | n/a | Sous-réseaux applicatifs, au moins deux (validé) |
| `app_sg_id` | `string` | n/a | Security Group applicatif |
| `target_group_arn` | `string` | n/a | Target Group de l'ALB |
| `instance_profile_name` | `string` | `"LabInstanceProfile"` | Profil IAM existant |
| `instance_type` | `string` | `"t3.micro"` | Type d'instance |
| `min_size` | `number` | `2` | Instances minimum (validé, au moins 2) |
| `max_size` | `number` | `4` | Instances maximum |
| `desired_capacity` | `number` | `null` | Capacité souhaitée (`null` = `min_size`) |
| `user_data` | `string` | n/a | Contenu de `user_data.sh` |
| `cpu_target_percent` | `number` | `60` | CPU moyen visé (validé) |
| `health_check_grace_period` | `number` | `180` | Délai avant health check (s) |

## Sorties

| Nom | Description |
|---|---|
| `autoscaling_group_name` | Nom de l'Auto Scaling Group |
| `launch_template_id` | ID du Launch Template |
| `ami_id` | Image utilisée |

## Sécurité

- Instances dans des sous-réseaux privés, sans IP publique.
- IMDSv2 obligatoire, disque chiffré.
- Aucun SSH ouvert.

## Coûts

Les instances EC2 sont facturées à l'heure : à détruire après la démonstration.

## Limites connues

- Le `user_data.sh` a besoin de la NAT Gateway pour installer nginx.
- Sous AWS Academy, le rôle IAM est fourni par la plateforme (`LabInstanceProfile`).