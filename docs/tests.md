# Résultats des tests

| Test | Procédure | Attendu | Résultat | Capture |
|---|---|---|---|---|
| Format | `terraform fmt -check -recursive` | Aucune différence | | |
| Validation | `terraform validate` | Success | | |
| Plan | `terraform plan` | Sans erreur | | |
| Accès Web | URL de l'ALB | Page disponible | | |
| Répartition | Actualiser | Plusieurs hôtes | | |
| Panne | Arrêter une instance | Service disponible | | |
| Auto Scaling | Capacité à 3 | 3 instances | | |
| Sécurité DB | `nc -zv <endpoint> 3306` | Refusé | | |
| Destruction | `terraform destroy` | Ressources supprimées | | |