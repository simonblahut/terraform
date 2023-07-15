# output the IP Address of the container
output "ip-address" {
  value       = [for i in docker_container.nodered_container[*] : join(":", [i.network_data.0.ip_address], i.ports[*]["external"])]
  description = "The IP address and external port of the container"
}

# output the name of the container
output "container-name" {
  value       = docker_container.nodered_container[*].name
  description = "The name of the container"
}