# Module `security`

Crée les Security Groups (Load Balancer, application, base de données) selon le principe du moindre privilège réseau. Le rôle IAM des instances n'est pas créé : il est fourni par la plateforme (AWS Academy).

## Ce qui est créé

| Ressource | Détail |
|---|---|
| `aws_security_group` (x3) | ALB, application, base de données |
| `aws_vpc_security_group_ingress_rule` / `egress_rule` | Une règle par ressource, référencées par Security Group |

## Règles de sécurité

| Security Group | Entrée | Sortie |
|---|---|---|
| ALB | HTTP 80 (et HTTPS 443 si activé) depuis Internet | Port applicatif vers le SG applicatif |
| Application | Port applicatif depuis le SG de l'ALB uniquement | 80/443 sortant, port base vers le SG base |
| Base de données | Port base depuis le SG applicatif uniquement | Aucune |

Aucun port SSH n'est ouvert.

## Utilisation

```hcl
module "security" {
  source      = "../../modules/security"
  name_prefix = local.name_prefix
  vpc_id      = module.network.vpc_id
}
```

## Entrées

| Nom | Type | Défaut | Description |
|---|---|---|---|
| `name_prefix` | `string` | n/a | Préfixe de nommage |
| `vpc_id` | `string` | n/a | ID du VPC |
| `app_port` | `number` | `80` | Port des instances (validé) |
| `db_port` | `number` | `3306` | Port de la base : 3306 ou 5432 (validé) |
| `enable_https` | `bool` | `false` | Ouvre le port 443 sur l'ALB |
| `instance_profile_name` | `string` | `"LabInstanceProfile"` | Profil IAM existant |

## Sorties

| Nom | Description |
|---|---|
| `alb_sg_id` | Security Group du Load Balancer |
| `app_sg_id` | Security Group applicatif |
| `db_sg_id` | Security Group de la base |
| `instance_profile_name` | Profil IAM pour le Launch Template |

## Limite AWS Academy

La création de rôles IAM est interdite dans le Learner Lab. Le module utilise donc le profil `LabInstanceProfile` déjà fourni. Hors AWS Academy, on créerait un rôle dédié avec une politique limitée aux actions strictement nécessaires.

## Limites connues

- `db_port` doit correspondre au moteur choisi dans le module `database`.
- Le HTTPS demande un certificat ACM, à configurer dans le module `load-balancer`.