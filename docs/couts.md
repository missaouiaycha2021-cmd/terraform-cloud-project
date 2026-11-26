# Estimation des coûts (us-east-1, tarifs à la demande, à vérifier avec l'AWS Pricing Calculator)

| Ressource | Tarif indicatif | Démo de 4 h | Mois complet |
|---|---|---|---|
| Application Load Balancer | ~0,0225 $/h + trafic | ~0,09 $ | ~16 $ |
| NAT Gateway | ~0,045 $/h + 0,045 $/Go | ~0,18 $ | ~33 $ |
| 2 EC2 t3.micro | ~0,0104 $/h chacune | ~0,08 $ | ~15 $ |
| RDS db.t3.micro MySQL (20 Go) | ~0,017 $/h + stockage | ~0,07 $ | ~15 $ |
| S3 (état et application) | quelques Mo | négligeable | négligeable |

Ordre de grandeur : moins de 1 $ pour une démonstration, environ 80 $ par mois si l'environnement reste actif.

## Maîtrise
- Types minimaux, `multi_az = false` en dev et test (le doubler double le coût RDS).
- `terraform destroy` après chaque démonstration, puis vérification dans la console.
- Postes les plus coûteux à surveiller : NAT Gateway et ALB.