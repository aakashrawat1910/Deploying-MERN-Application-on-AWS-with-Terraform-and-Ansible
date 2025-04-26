output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

output "nat_gateway_ip" {
  value = module.vpc.nat_gateway_ip
}

output "web_server_public_ip" {
  value = module.compute.web_server_public_ip
}