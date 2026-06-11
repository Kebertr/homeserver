resource "cloudflare_dns_record" "nginx" {
    zone_id = data.cloudflare_zone.main.id

    name = "nginx"
    type = "CNAME"

    value = "server"
    proxied = true
}