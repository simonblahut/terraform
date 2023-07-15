# --- root/backends.tf ---

terraform {
  cloud {
    organization = "simon-ltd"

    workspaces {
      name = "prod"
    }

    workspaces { 
      name = "dev"
    }
  }
}
