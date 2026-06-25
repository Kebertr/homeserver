# From https://oneuptime.com/blog/post/2026-02-23-cert-manager-terraform/view

# Create the cert-manager namespace
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"

    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}


# Deploy cert-manager using Helm
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name
  version    = "v1.20.2"

  # Resource limits for the controller
  values = [
    yamlencode({
      # Install CRDs with the chart
      crds = {
        enabled = true
      }

      resources = {
        requests = {
          cpu    = "50m"
          memory = "128Mi"
        }
        limits = {
          memory = "256Mi"
        }
      }
      webhook = {
        resources = {
          requests = {
            cpu    = "25m"
            memory = "64Mi"
          }
          limits = {
            memory = "128Mi"
          }
        }
      }
    })
  ]

  wait    = true
  timeout = 300
}


# Let's Encrypt staging issuer for testing
resource "kubectl_manifest" "letsencrypt_staging" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    # Staging endpoint for testing - does not count against rate limits
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: ${var.acme_email}
    privateKeySecretRef:
      name: letsencrypt-staging-key
    solvers:
      - http01:
          ingress:
            ingressClassName: kong
YAML

  depends_on = [helm_release.cert_manager]
}

# Let's Encrypt production issuer
resource "kubectl_manifest" "letsencrypt_prod" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: ${var.acme_email}
    privateKeySecretRef:
      name: letsencrypt-prod-key
    solvers:
      - http01:
          ingress:
            ingressClassName: kong
YAML

  depends_on = [helm_release.cert_manager]
}