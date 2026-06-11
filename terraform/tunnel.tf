resource "random_password" "tunnel_secret"{
    length = 32
    special = false
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "server"{
    account_id = var.cloudflare_account_id
    name = "server"
    secret = base64encode(random_password.tunnel_secret.result)
}