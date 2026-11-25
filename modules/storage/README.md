# Module `storage`

Crée le bucket S3 applicatif (ressources, journaux, sauvegardes) : accès public bloqué, versioning, chiffrement et règles de cycle de vie.

## Ce qui est créé

| Ressource | Détail |
|---|---|
| `aws_s3_bucket` | Bucket `<name_prefix>-app-<bucket_suffix>` |
| `aws_s3_bucket_public_access_block` | Bloque tout accès public |
| `aws_s3_bucket_versioning` | Versioning activé |
| `aws_s3_bucket_server_side_encryption_configuration` | Chiffrement AES256 |
| `aws_s3_bucket_lifecycle_configuration` | Suppression de `logs/` et des anciennes versions |

## Utilisation

```hcl
module "storage" {
  source        = "../../modules/storage"
  name_prefix   = local.name_prefix
  bucket_suffix = var.bucket_suffix
}
```

## Entrées

| Nom | Type | Défaut | Description |
|---|---|---|---|
| `name_prefix` | `string` | n/a | Préfixe de nommage |
| `bucket_suffix` | `string` | n/a | Suffixe d'unicité du nom (validé) |
| `force_destroy` | `bool` | `true` | Permet de détruire un bucket non vide |
| `logs_expiration_days` | `number` | `30` | Durée de conservation de `logs/` (validé) |
| `noncurrent_version_expiration_days` | `number` | `30` | Durée de conservation des anciennes versions (validé) |

## Sorties

| Nom | Description |
|---|---|
| `bucket_name` | Nom du bucket |
| `bucket_arn` | ARN du bucket |

## Sécurité

- Accès public bloqué sur les quatre options.
- Chiffrement au repos activé.
- Versioning activé.

## Limites connues

- Le nom du bucket doit être unique dans tout AWS : choisissez un `bucket_suffix` personnel.
- `force_destroy = true` facilite la destruction en test ; à passer à `false` en production.
- Sous AWS Academy, aucune politique IAM sur mesure : l'accès des instances passe par `LabRole`.