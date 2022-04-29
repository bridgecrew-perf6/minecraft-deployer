# Minecraft deployer

Deploys Minecraft to [AWS](#) using either:

- [EC2](#)
- [ECS Fargate](#) -- TODO

## Setup

- Download and configure the [AWS CLI](https://aws.amazon.com/cli/).
- Download and install [tfenv](https://github.com/tfutils/tfenv) for managing [Terraform](https://www.terraform.io/)

Run the bootstrap script to create a state bucket and lock table for Terraform:

```bash
./bootstrap $ENV_ID $AWS_PROFILE
./bootstrap minecraft-deployer default
```

## Steps

### Choose the deployment option

```bash
cd ec2 # or ecs
mkdir mc1 # any folder name you want to allow for multiple environments
mkdir mc2 # optional, 2nd environment
```

All subsequent commands will be run from the chosen deployment option directory.

### Install Terraform

```bash
tfenv install
```

### Run Terraform

```bash
cp backend.tfvars.example mc1/backend.tfvars
cp terraform.tfvars.example mc1/terraform.tfvars
# edit backend.tfvars & terraform.tfvars values as needed
terraform init -reconfigure -backend-config=mc1/backend.tfvars
terraform plan -var-file=mc1/terraform.tfvars
# and if happy with the plan
terraform apply -var-file=mc1/terraform.tfvars -auto-approve
```

Terraform apply will output a public IP address which can be used to access
Minecraft at `$PUBLIC_IP:25565` after a minute or two.

### Managing the EC2 based deployment

- Access: `./access-server minecraft-ec2`
- Start: `./update-server start minecraft-ec2`
- Stop: `./update-server stop minecraft-ec2`
- Terminate: `./terminate-server`

### Destroying resources

To destroy all AWS reources you can run `terraform destroy`. To target a specific
resource use `terraform destroy -target=$resource`, for example:
`terraform destroy -target=module.minecraft-server.aws_instance.minecraft`.
