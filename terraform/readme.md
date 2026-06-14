# Cloudflare with terraform
This manages Cloudflare infrastructure using Terraform. The reason is to define Cloudflare configurations as code, which makes it easier to recreate on a new machine.
So how to run it?

Preequisites:
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

I run this on a Linux machine

Create terraform.tfvars from the mock file. There we add account id and api token to cloudflare.

The reason why we use terraform is to redeploy my cloudflare tunneling automatically. We have the saved states in minio bucket which is a service on kubernetes cluster. 

To get the states from minio we use tailscale to connect to it and get information. Copy backend-mock.hcl and jsut switchout enpoint s3 to your tailscale url. Can be found if you run 
```kubectl get ingress -n minio```
and choose the url for minio-Api


Then just pull from this repository and run

```terraform init``

This will download cloudflare and hashicorp/random, which are necessary providers


```terraform validate```

To make sure that your syntax is correct and preview the infrastructure.

Lastly run 
```terraform plan```

to see what changes terraform would make. It jsut displays and does not change anything.

Apply the changes:
```terraform apply```

Terraform states tracks managed resources in a state file.

```terraform state list```
List all managed resources.




