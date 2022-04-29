# Minecraft deployer

Deploys Minecraft to [AWS](#) using either:

- [EC2](#)
- [ECS Fargate](#) -- TODO

## Setup

- Download and configure the [AWS CLI](https://aws.amazon.com/cli/).
- Download and install [tfenv](https://github.com/tfutils/tfenv) for managing [Terraform](https://www.terraform.io/)
- Download and install [tgswitch](https://github.com/warrensbox/tgswitch) for managing [Terragrunt](https://terragrunt.gruntwork.io/)

Run the bootstrap script to create a state bucket and lock table for Terraform:

```bash
./bootstrap $ENV_ID $AWS_PROFILE
./bootstrap minecraft-deployer default
```

## Steps

### Choose the deployment option

```bash
mkdir ec2-deploy # or ecs-deploy
cd ec2 # or ecs
tfenv install
cd -
```

### Run Terraform

```bash
cp terragrunt.hcl.example ec2-deploy/terragrunt.hcl
cp terraform.tfvars.ec2 ec2-deploy/terraform.tfvars
# edit terragrunt.hcl & terraform.tfvars values as needed
cd ec2-deploy
terragrunt init
terragrunt plan
# and if happy with the plan
terragrunt apply
```

Terraform apply will output a public IP address which can be used to access
Minecraft at `$PUBLIC_IP:25565` after a minute or two.

### Managing the EC2 based deployment

- Access: `./ec2_access-server minecraft-ec2`
- Start: `./ec2_update-server start minecraft-ec2`
- Stop: `./ec2_update-server stop minecraft-ec2`
- Terminate: `./ec2_terminate-server`

### Destroying resources

To destroy all AWS reources you can run `terraform destroy`. To target a specific
resource use `terraform destroy -target=$resource`, for example:
`terraform destroy -target=module.minecraft-server.aws_instance.minecraft`.
