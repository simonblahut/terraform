# --- root/providers.tf ---

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  access_key = "do_not_hardcode_aws_keys"
  secret_key = "do_not_hardcode_aws_keys"
  region     = var.aws_region
}
