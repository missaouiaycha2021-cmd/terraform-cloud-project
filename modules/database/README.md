# Module `database`

Crée une instance RDS MySQL dans des sous-réseaux privés, chiffrée, sans accès public.

## Ce qui est créé

| Ressource | Détail |
|---|---|
| `aws_db_subnet_group` | Sous-réseaux privés de base de données (deux zones) |
| `aws_db_parameter_group` | Paramètres MySQL (`utf8mb4`) |
| `aws_db_instance` | RDS MySQL, `publicly_accessible = false`, stockage chiffré |

## Utilisation

```hcl
module "database" {
  source                = "../../modules/database"
  name_prefix           = local.name_prefix
  private_db_subnet_ids = module.network.private_db_subnet_ids
  db_sg_id              = module.security.db_sg_id
  db_instance_class     = var.db_instance_class
  master_password       = var.db_password
}
```

## Entrées

| Nom | Type | Défaut | Description |
|---|---|---|---|
| `name_prefix` | `string` | n/a | Préfixe de nommage |
| `private_db_subnet_ids` | `list(string)` | n/a | Sous-réseaux DB, au moins deux (validé) |
| `db_sg_id` | `string` | n/a | Security Group de la base |
| `db_instance_class` | `string` | `"db.t3.micro"` | Classe RDS (validé) |
| `engine_version` | `string` | `"8.0"` | Version de MySQL |
| `allocated_storage` | `number` | `20` | Stockage en Go (validé) |
| `db_name` | `string` | `"appdb"` | Nom de la base |
| `master_username` | `string` | `"appadmin"` | Administrateur |
| `manage_master_password` | `bool` | `false` | Mot de passe géré par Secrets Manager |
| `master_password` | `string` (sensible) | `null` | Mot de passe, via `TF_VAR_db_password` |
| `multi_az` | `bool` | `false` | Standby dans une autre zone |
| `backup_retention_period` | `number` | `1` | Jours de sauvegarde |

## Sorties

| Nom | Description |
|---|---|
| `endpoint` | `hôte:port` |
| `address` | Nom d'hôte |
| `port` | Port |
| `db_name` | Nom de la base |
| `master_user_secret_arn` | Secret Secrets Manager (`null` si mot de passe fourni) |

## Sécurité

- Aucun accès public, sous-réseaux sans route Internet.
- Connexions acceptées uniquement depuis le Security Group applicatif.
- Stockage chiffré.
- Aucun mot de passe dans Git : variable sensible fournie hors dépôt.

## Coûts

RDS est facturé à l'heure : à détruire après la démonstration. `multi_az = true` double le coût.

## Limites connues

- `skip_final_snapshot = true` et `deletion_protection = false` facilitent la destruction ; à changer en production.
- Sous AWS Academy, `manage_master_password = true` peut être refusé (Secrets Manager/KMS) : d'où la valeur par défaut `false`.
- Le mot de passe fourni est stocké dans l'état Terraform (bucket chiffré, accès restreint).