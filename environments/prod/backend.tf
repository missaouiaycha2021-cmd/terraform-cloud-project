terraform {
  backend "s3" {
    bucket       = "cloud5-terraform-state-aycha2026"
    key          = "prod/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}