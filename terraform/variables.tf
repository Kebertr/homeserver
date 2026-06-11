variable "domain" {
    type = string
    default = "kebert.se"
}

variable "cloudflare_account_id" {
    type = string
}

variable "cloudflare_api_token" {
    type = string
    sensitive = true
}