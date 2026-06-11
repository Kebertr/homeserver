resource "random_password" "tunnel_secret"{
    length = 32
    special = false
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "server"{
    account_id = var.cloudflare_account_id
    name = "server"
    tunnel_secret = base64encode(random_password.tunnel_secret.result)
    config_src = "cloudflare"
}

# This is for kubernetes secret
resource "kubernetes_secret_v1" "tunnel-credentials" {
    metadata {
        name = "tunnel-credentials"
        namespace = "default"
    }
    data = {
    "credentials.json" = jsonencode({
      AccountTag   = var.cloudflare_account_id
      TunnelID     = cloudflare_zero_trust_tunnel_cloudflared.server.id
      TunnelSecret = base64encode(random_password.tunnel_secret.result)
    })
  }
}
