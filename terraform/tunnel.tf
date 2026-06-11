resource "random_tunnel_id" "tunnel_id"{
    length = 32
    special = false
}

resource "cloudflare_tunnel" "server"{
    account_id = var.cloudflare_account_id
    name = "server"
    secret = base64encode(random_tunnel_id.tunnel_id.result)
}