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

        helm = {
            source  = "hashicorp/helm"
            version = "~> 2.17"
        }

        kubectl = {
            source  = "gavinbunney/kubectl"
            version = "~> 1.14"
        }

        kubernetes = {
            source = "hashicorp/kubernetes"
        }
    }
}

provider "kubernetes" {
    config_path = "~/.kube/config"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubectl" {
  config_path = "~/.kube/config"
}