### Terraform Getting Started Project

![challenge](./assets/main.png)

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

## Getting Deeper:

### Infra setup for a web server that accesses DynamoDB table and exposes a REST API

1. **EC2 Instance Setup**
    - **Provisioning**: Creates an EC2 instance with a specified security group for controlled access.
    - **Security Group**: Configured to allow necessary traffic (e.g., HTTP, SSH).
2. **DynamoDB Table Provisioning**
    - **Table Creation**: Defines and provisions a DynamoDB table according to the requirements.
    - **Schema Definition**: Includes table attributes and indices if needed.
3. **IAM Role and Policy**
    - **Role Creation**: Sets up an IAM role with permissions to access the DynamoDB table.
    - **Policy Attachment**: Attaches a policy to the IAM role that grants necessary permissions.
4. **Instance Profile Association**
    - **Profile Attachment**: Associates the IAM role with the EC2 instance to provide it with DynamoDB access.
5. **User Data Script Execution**
    - **Environment Setup**: Installs required software (e.g., Java, Git) and sets up the environment.
    - **Application Deployment**: Clones the repository, builds the application, and starts the web server.

### How to Use

To deploy the entire infrastructure and set up the web server, execute the following Terraform command:

```bash
terraform apply -var user_data_file=init-script-advanced.sh
```