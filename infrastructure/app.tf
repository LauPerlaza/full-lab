module "app-full-lab" {
    source = "./modules/instance"
    region = var.region
    Environment = var.Environment
    ip = var.ip
    instance_type = var.instance_type
}