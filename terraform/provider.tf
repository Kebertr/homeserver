terraform{
    required_version = ">= 1.0"
    required_providers{
        cloudflare = {
            source = "cloudflare/cloudflare"
            version = "~> 5.19"
        }

        random = {
            source = "hashicorp/random"
        }
    }
}

provider "kubernetes" {
    config_path = "~/.kube/config"
}

provider "cloudflare" {
}
