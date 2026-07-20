terraform {
  backend "s3" {
    bucket       = "en-automotive-terraform-state"
    key          = "dev/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}