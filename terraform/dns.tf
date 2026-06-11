resource "cloudflare_dns_record" "nginx" {
    zone_id = data.cloudflare_zone.main.id

    name = "nginx"
    type = "CNAME"

    content = "${cloudflare_zero_trust_tunnel_cloudflared.server.id}.cfargotunnel.com"
    ttl = 1
    proxied = true
}
