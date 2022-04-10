# Minecraft deployer

Deploys Minecraft to [AWS](#) using either:

- [EC2](#)
- [ECS Fargate](#)

## Setup

- Download and configure the [AWS CLI](https://aws.amazon.com/cli/).
- Download and install [tfenv](https://github.com/tfutils/tfenv) for managing [Terraform](https://www.terraform.io/)

## Steps

### Choose the deployment option

```bash
cd ec2 # or ecs
```

All subsequent commands will be run from the chosen deployment option directory.

### Install Terraform

```bash
tfenv install
```

### Run Terraform

```bash
terraform init
terraform plan
 # and if happy with the plan
terraform apply -auto-approve
```

To destroy all AWS reources you can run `terraform destroy`.

## Terraform State backup

Minecraft deployer is using the `local` backend to record Terraform state,
therefore it is important to backup the `ec2` and / or `ecs` directories copy
of `terraform.tfstate`.
