A hooby project with server running on linux machine, K3s and Cloudflare tunnel atm.
K3s:
Command for a single node K3s
```curl -sfL https://get.k3s.io | sh -```

Uninstall it
```/usr/local/bin/k3s-uninstall.sh```

Some useful commands:
nodes:
```kubectl get nodes```

pods
```kubectl get pods -A```

services
```kubectl get svc -A```

ingress
```kubectl get ingress -A```

namespaces
```kubectl get namespaces```

Cloudflare tunnel:
Creating:
```cloudflared tunnel run [name]```

login to Cloudflare:
```cloudflared tunnel login```

run it:
```cloudflared tunnel run homelab```