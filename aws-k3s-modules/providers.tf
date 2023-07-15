# --- root/providers.tf ---

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  access_key = "AKIAVYHNCFUYF6CLCKO7"
  secret_key = "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"
  region     = var.aws_region
}
