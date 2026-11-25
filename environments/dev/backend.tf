terraform {
  backend "s3" {
    bucket       = "cloud5-terraform-state-VOTRE-SUFFIXE"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}