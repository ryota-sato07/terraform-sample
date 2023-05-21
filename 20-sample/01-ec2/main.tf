module "web_server" {
  source        = "../../modules"
  instance_type = "t3.micro"
}

output "public_dns" {
  value = module.web_server.public_dns
}
