resource "cloudflare_dns_record" "nginx" {
    zone_id = data.cloudflare_zone.main.id

    name = "nginx"
    type = "CNAME"

    value = "${cloudflare_zero_trust_tunnel_cloudflared.server.id}.cfargotunnel.com"
    proxied = true
}