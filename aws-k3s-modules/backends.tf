# --- root/backends.tf ---

terraform {
  cloud {
    organization = "simon-xaas"

    workspaces {
      name = "dev"
    }
  }
}