Welcome to a fun hooby project with server running on linux machine, K3s and Cloudflare tunneling!

# Setup to the server
Clone this repository:
```git clone https://github.com/Kebertr/homeserver.git```

K3s:
Command for a single node K3s
```curl -sfL https://get.k3s.io | sh -```

Uninstall it
```/usr/local/bin/k3s-uninstall.sh```

Guide to recreate the server:
Kubernetes node
```curl -sfL https://get.k3s.io | sh -```

argocd:
```kubectl create namespace argocd```

```kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml```

clone the homeserver-gitops repo, i do with https:
```git clone https://github.com/Kebertr/homeserver-gitops.git```

Apply applications with ArgoCD, command from /homeserver-gitops
```kubectl apply -f /applications/[name of file]```

Create a bucket in minio for terraform states. I use name terraform-state

Configure backend.hcl to use the url from tailscale

# Terraform
```terraform init -backend-config=backend.hcl```

```terraform validate```

```terraform plan```

If everything is alright. Which it should be. Then run 
```terraform apply```

# Documentation
Terraform: terraform/README.md

Kubernetess application is in: https://github.com/Kebertr/homeserver-gitops

