# Terraform

### Installation

Via Choco package manager for Windows:

1. open PowerShell in administration mode
2. run

```bash
choco install terraform
```

### Prepare your workspace:

1. create a folder where you will initial your workspace
2. create [main.tf](http://main.tf) with the following content where you will be defining you infra

 

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}
provider "aws" {
  region = var.aws_region
}
```

### Commands:

Initializing a configuration directory downloads and installs the providers defined in the configuration, which in this case is the `aws` provider.

```bash
terraform init
```

validate the syntax

```bash
terraform validate
```

format the script

```bash
terraform fmt
```

to review changes that will be applied → helps review any changes and affected objects in the cloud

```bash
terraform plan
```

apply changes with variables

```bash
terraform apply -var ec2_instance_type=t2.micro
```

Assign variables values with a file:

Terraform automatically loads all files in the current directory with the exact name `terraform.tfvars` or matching `*.auto.tfvars`. You can also use the `-var-file` flag to specify other files by name.

list all the resources

```bash
terraform state list 
```

show the state of the infra created

```bash
terraform show
```

output values about the infrastructure variables:

- outputs should be defined in [outputs.tf](http://outputs.tf) file

```bash
terraform output
```

### Execution modes:

Remote Execution: using HCP terraform 

- Stores variables, access keys

Local Execution: locally:

- AWS CLI installed and configured

Store Remote State:

<aside>
✅ [HCP Terraform](https://cloud.hashicorp.com/products/terraform) allows teams to easily version, audit, and collaborate on infrastructure changes. It also securely stores variables, including API tokens and access keys, and provides a safe, stable environment for long-running Terraform processes

</aside>

when using remote execution:

- we remove the terraform.tfstate file from our local environment
- we delegate the execution to the remote (cloud environment within HCP)