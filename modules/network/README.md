# Module `network`

Crée le réseau d'une plateforme Web répartie sur **deux zones de disponibilité** : VPC, sous-réseaux publics et privés, Internet Gateway, NAT Gateway et tables de routage.

## Ce qui est créé

| Ressource | Détail |
|---|---|
| `aws_vpc` | VPC avec DNS support et DNS hostnames activés |
| `aws_subnet` (x6) | 2 publics (ALB), 2 privés applicatifs (EC2), 2 privés base de données (RDS), créés via `count` |
| `aws_internet_gateway` | Passerelle Internet du VPC |
| `aws_eip` + `aws_nat_gateway` | **1 seule NAT** (dans le premier sous-réseau public), activable avec `enable_nat_gateway` |
| `aws_route_table` (x3) | Publique (route vers l'IGW), privée applicative (route vers la NAT), privée base de données **sans route Internet** |
| `aws_route` | Route `0.0.0.0/0` vers la NAT pour les sous-réseaux applicatifs |
| `aws_route_table_association` (x6) | Associe chaque sous-réseau à sa table de routage, créées via `count` |

## Architecture réseau

| Composant | CIDR par défaut |
|---|---|
| VPC | `10.20.0.0/16` (fourni par l'environnement) |
| Sous-réseaux publics | `10.20.1.0/24`, `10.20.2.0/24` |
| Sous-réseaux privés applicatifs | `10.20.11.0/24`, `10.20.12.0/24` |
| Sous-réseaux privés base de données | `10.20.21.0/24`, `10.20.22.0/24` |

## Utilisation

```hcl
module "network" {
  source             = "../../modules/network"
  name_prefix        = local.name_prefix
  vpc_cidr           = var.vpc_cidr
  availability_zones = ["eu-west-3a", "eu-west-3b"]
}
```

## Entrées

| Nom | Type | Défaut | Description |
|---|---|---|---|
| `name_prefix` | `string` | n/a | Préfixe de nommage (ex : `cloud5-dev`) |
| `vpc_cidr` | `string` | n/a | CIDR du VPC (validé) |
| `availability_zones` | `list(string)` | n/a | Zones utilisées, au moins deux (validé) |
| `public_subnet_cidrs` | `list(string)` | `["10.20.1.0/24", "10.20.2.0/24"]` | Sous-réseaux publics |
| `private_app_subnet_cidrs` | `list(string)` | `["10.20.11.0/24", "10.20.12.0/24"]` | Sous-réseaux applicatifs |
| `private_db_subnet_cidrs` | `list(string)` | `["10.20.21.0/24", "10.20.22.0/24"]` | Sous-réseaux base de données |
| `enable_nat_gateway` | `bool` | `true` | Crée la NAT Gateway (payante) |

## Sorties

| Nom | Description |
|---|---|
| `vpc_id` | ID du VPC |
| `vpc_cidr` | CIDR du VPC |
| `public_subnet_ids` | IDs des sous-réseaux publics |
| `private_app_subnet_ids` | IDs des sous-réseaux applicatifs |
| `private_db_subnet_ids` | IDs des sous-réseaux base de données |
| `nat_gateway_public_ip` | IP publique de la NAT (`null` si désactivée) |

## Sécurité

- Les sous-réseaux de base de données n'ont **aucune route vers Internet**.
- Aucune IP publique n'est attribuée automatiquement au lancement (`map_public_ip_on_launch = false`).
- Les tags communs sont appliqués par `default_tags` du provider, défini dans l'environnement.

## Coûts

La NAT Gateway est la seule ressource payante du module (facturation à l'heure plus le trafic). Une seule NAT est créée pour limiter les coûts : en production réelle, on en placerait une par zone pour la haute disponibilité. Si `enable_nat_gateway = false`, les instances privées ne peuvent plus installer de paquets via `user_data.sh`.

## Limites connues

- Si `vpc_cidr` est modifié (test, prod), les trois listes de CIDR de sous-réseaux doivent être fournies, sinon les sous-réseaux sortent du VPC.
- Une seule NAT : si sa zone tombe, les instances privées perdent leur accès sortant.