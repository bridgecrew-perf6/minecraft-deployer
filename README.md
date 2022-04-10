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
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars values as needed
terraform init
terraform plan
# and if happy with the plan
terraform apply -auto-approve
```

Terraform apply will output a public IP address which can be used to access
Minecraft at `$PUBLIC_IP:25565` after a minute or two.

### Managing the EC2 based deployment

- Access: `./access-server minecraft-ec2`
- Start: `./start-server minecraft-ec2`
- Stop: `./stop-server minecraft-ec2`
- Terminate: `./terminate-server`

### Destroying resources

To destroy all AWS reources you can run `terraform destroy`. To target a specific
resource use `terraform destroy -target=$resource`, for example:
`terraform destroy -target=module.minecraft-server.aws_instance.minecraft`.

## Terraform State backup

Minecraft deployer is using the `local` backend to record Terraform state,
therefore it is important to backup the `ec2` and / or `ecs` directories copy
of `terraform.tfstate`.

It can be backed up by running:

```bash
# Make a backup
aws s3 cp terraform.tfstate s3://$bucket_name/ --profile $profile
aws s3 cp terraform.tfstate s3://minecraft-ec2-deployer/ --profile default
# TODO: ./upload_state $BUCKET_NAME $PROFILE

# Download the backup
aws s3 cp s3://$bucket_name/terraform.tfstate . --profile $profile
aws s3 cp s3://minecraft-ec2-deployer/terraform.tfstate . --profile default
# TODO: ./download_state $BUCKET_NAME $PROFILE
```

Minecraft deployer is not using the s3 backend to avoid referencing a specific resource
as variables are not allowed by Terraform in the backend configuration.
