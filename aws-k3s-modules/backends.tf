# --- root/backends.tf ---

terraform {
  cloud {
    organization = "simon-ltd"

    workspaces {
      name = "dev"
    }
  }
}