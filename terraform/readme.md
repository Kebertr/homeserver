# Cloudflare with terraform
This manages Cloudflare infrastructure using Terraform. The reason is to define Cloudflare configurations as code, which makes it easier to recreate on a new machine.
So how to run it?

Preequisites:
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

I run this on a Linux machine

Create terraform.tfvars from the mock file. There we add account id and api token to cloudflare.


Then just pull from this repository and run

```terraform init``

This will download cloudflare and hashicorp/random, which are necessary providers



```terraform validate```

To make sure that your syntax is correct and preview the infrastructure.

Then

```export CLOUDFLARE_API_TOKEN="my api token"```

verify 
```echo $CLOUDFLARE_API_TOKEN```

Lastly run 
```terraform plan```

to see what changes terraform would make. It jsut displays and does not change anything.

Apply the changes:
```terraform apply```

Terraform states jeeos track of managed resources in a state file.

```terraform state list```
List all managed resources.
