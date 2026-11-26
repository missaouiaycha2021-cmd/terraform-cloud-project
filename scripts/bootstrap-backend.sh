#!/bin/bash
# Crée une seule fois le bucket S3 qui stocke l'état Terraform.
# Usage : ./scripts/bootstrap-backend.sh
set -euo pipefail

BUCKET="${BUCKET:-cloud5-terraform-state-aycha2026}"
REGION="${REGION:-us-east-1}"

echo "Compte AWS :"
aws sts get-caller-identity --query Account --output text

echo "Création du bucket $BUCKET dans $REGION..."

# us-east-1 n'accepte PAS LocationConstraint
if [ "$REGION" = "us-east-1" ]; then
  aws s3api create-bucket --bucket "$BUCKET" --region "$REGION"
else
  aws s3api create-bucket --bucket "$BUCKET" --region "$REGION" \
    --create-bucket-configuration LocationConstraint="$REGION"
fi

aws s3api put-bucket-versioning --bucket "$BUCKET" \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption --bucket "$BUCKET" \
  --server-side-encryption-configuration \
  '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

aws s3api put-public-access-block --bucket "$BUCKET" \
  --public-access-block-configuration \
  BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

echo "Bucket d'état prêt : $BUCKET"