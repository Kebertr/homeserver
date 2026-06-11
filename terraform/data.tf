data "cloudflare_zones" "main"{
    name = var.domain
}