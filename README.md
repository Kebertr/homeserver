# Homeserver

Infrastructure-as-code for a personal Linux homeserver running K3s.

This repository provisions Cloudflare infrastructure, Cloudflare Tunnel credentials, DNS records, cert-manager, and Let's Encrypt issuers using Terraform.

Kubernetes applications are managed separately through the `homeserver-gitops` repository.

## Architecture

```text
Internet
   |
Cloudflare DNS
   |
Cloudflare Tunnel
   |
K3s cluster
   |
Kong / Traefik / Tailscale
   |
Cluster applications
```

Infrastructure responsibilities are divided between two repositories:

| Repository | Responsibility |
| --- | --- |
| `homeserver` | Terraform, Cloudflare, DNS, tunnel credentials and cert-manager |
| `homeserver-gitops` | Argo CD Applications, Helm charts and Kubernetes workloads |

## Repository structure

```text
terraform/
├── backend.tf             Remote S3-compatible state configuration
├── backend-mock.hcl       Example MinIO backend configuration
├── cert-manager.tf        cert-manager and Let's Encrypt issuers
├── data.tf                Terraform data sources
├── dns.tf                 Cloudflare DNS records
├── provider.tf            Terraform providers
├── terraform.tfvars.mock  Example input variables
├── tunnel.tf              Cloudflare Tunnel and Kubernetes credentials
└── variables.tf           Input variable definitions
```

## Managed infrastructure

Terraform currently manages:

- Cloudflare DNS records
- Cloudflare Tunnel
- Cloudflare Tunnel Kubernetes credentials
- cert-manager
- Let's Encrypt staging ClusterIssuer
- Let's Encrypt production ClusterIssuer

Terraform state is stored in an S3-compatible MinIO bucket and reached through a private Tailscale endpoint.

## Prerequisites

Install:

- Linux
- Git
- K3s
- `kubectl`
- Terraform
- Helm
- Tailscale
- Access to a Cloudflare account and API token
- Access to the private MinIO Terraform state bucket

## Install K3s

For a single-node cluster:

```bash
curl -sfL https://get.k3s.io | sh -
```

Verify the node:

```bash
kubectl get nodes
```

K3s can be removed with:

```bash
/usr/local/bin/k3s-uninstall.sh
```

Warning: uninstalling K3s removes the local cluster.

## Clone the repositories

Clone this repository:

```bash
git clone https://github.com/Kebertr/homeserver.git
```

Clone the GitOps repository:

```bash
git clone https://github.com/Kebertr/homeserver-gitops.git
```

## Terraform variables

Enter the Terraform directory:

```bash
cd terraform
```

Copy the example variables:

```bash
cp terraform.tfvars.mock terraform.tfvars
```

Configure the required values:

```hcl
cloudflare_account_id = "your-account-id"
cloudflare_api_token  = "your-api-token"
acme_email            = "you@example.com"
```

Keep `terraform.tfvars` out of Git.

## Remote state

Terraform uses the S3 backend with MinIO.

Copy the example backend configuration:

```bash
cp backend-mock.hcl backend.hcl
```

Configure it with the private MinIO endpoint:

```hcl
bucket = "terraform-state"
key    = "server/terraform.tfstate"

access_key = "your-access-key"
secret_key = "your-secret-key"

endpoints = {
  s3 = "https://your-private-minio-tailscale-host"
}

use_path_style              = true
skip_credentials_validation = true
skip_requesting_account_id  = true
```

The endpoint can be found with:

```bash
kubectl get ingress -n minio
```

Use the private Tailscale MinIO API endpoint, not the public application-upload endpoint.

Keep `backend.hcl` out of Git because it contains credentials.

## Terraform workflow

Initialize Terraform:

```bash
terraform init -backend-config=backend.hcl
```

If the backend address changes:

```bash
terraform init -reconfigure -backend-config=backend.hcl
```

Validate the configuration:

```bash
terraform validate
```

Format Terraform files:

```bash
terraform fmt -check
```

Preview changes:

```bash
terraform plan
```

Apply reviewed changes:

```bash
terraform apply
```

Inspect managed resources:

```bash
terraform state list
```

Do not run `terraform apply` until the plan has been reviewed.

## Cloudflare Tunnel

Terraform creates the Cloudflare Tunnel and stores its credentials in a Kubernetes Secret:

```text
Namespace: cloudflare
Secret:    tunnel-credentials
```

The cloudflared workload itself is deployed from the GitOps repository.

Cloudflare hostname rules select whether traffic is forwarded to Kong or Traefik inside the cluster.

## DNS

Terraform defines proxied CNAME records pointing to the Cloudflare Tunnel, including endpoints for:

- Valhall
- Valhall development
- Keycloak
- Nginx
- Public uploads

Adding DNS alone does not create an application route. A matching cloudflared hostname rule and Kubernetes Ingress must also exist.

## TLS certificates

Terraform installs cert-manager and creates Let's Encrypt staging and production ClusterIssuers.

The HTTP-01 solver currently uses Kong:

```yaml
http01:
  ingress:
    ingressClassName: kong
```

An Ingress can request a certificate with:

```yaml
metadata:
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
```

Inspect certificate state:

```bash
kubectl get certificate,certificaterequest,order,challenge -A
```

## Troubleshooting remote state

If Terraform cannot find its state endpoint, verify Tailscale DNS:

```bash
nslookup <private-minio-host>
```

Check the MinIO resources:

```bash
kubectl get pods,services,ingress -n minio
```

Then test backend initialization again:

```bash
terraform init -reconfigure -backend-config=backend.hcl
```

Do not replace or recreate Terraform state unless you are certain the existing state is unavailable. Losing the state file does not delete infrastructure, but Terraform will no longer know that it manages those resources.

## Security notes

- Never commit API tokens, access keys or backend credentials.
- Use the private Tailscale endpoint for Terraform state.
- Keep the MinIO console private.
- Expose only the required upload bucket through the public ingress.
- Review `terraform plan` before applying changes.
- Prefer the Let's Encrypt staging issuer while testing certificate configuration.