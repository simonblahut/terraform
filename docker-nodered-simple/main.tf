terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

# add provisioner for local-exec 
resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    command = "mkdir noderedvol || true && chown -R 1000:1000 noderedvol"
  }
}

# download Node-RED image
resource "docker_image" "nodered_image" {
  name = var.image[terraform.workspace]
}

# random resource 
resource "random_string" "random" {
  count   = local.resource_count
  length  = 4
  special = false
  upper   = false
}

# start the containers
resource "docker_container" "nodered_container" {
  count = local.resource_count
  name  = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
  image = docker_image.nodered_image.image_id
  ports {
    internal = var.int_port
    external = var.ext_port[terraform.workspace][count.index]
  }
  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/noderedvol"
  }
}


