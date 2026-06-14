bucket = "terraform-state"
key = "server/terraform.tfstate"

endpoints = {
    s3 = "tailscale url"
}


# These are to keep it from trying aws specific commands
use_path_style              = true
skip_credentials_validation = true
skip_requesting_account_id  = true