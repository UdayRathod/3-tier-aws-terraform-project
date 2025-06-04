# aws-terraform-project
Repo for highly available, scalable php web facing application deployed on AWS using terraform.

# AWS Services configured: 
AWS VPC
AWS Load balancer for Presentation layer facing web.
AWS Autoscaling group for handling and hosting the ngnix,php code.
AWS RDS for storing the data for the php application.
AWS S3 for storing the userdata script and the applications dependencies like the php code & terracloud image, also another S3 is created for storing the Load balancer logs.

# Architecture for this project is shown in file: image.png

# Terraform resources used in this repo:
VPC module from terraform registry.
S3 module created locally.
Variables for storing the variable values.
terraform.tf.vars for holding some of the variable values.
Locals for TAGS.
Outputs for exporting the resources information created by module/resource block.
Templates folder holds the USER DATA script which will be used the autoscaling for launching instances.
Website folder for sotring the php application code & our company logo.
Backend configuration block for storing the state file in S3.


# Getting Started
To get started with deploying the AWS services using Terraform, follow these steps:

1) Clone this repository to your local machine.

2) Install Terraform (version X.X.X) from the official Terraform website here.

3) Configure your AWS credentials by setting the necessary environment variables or using the AWS CLI aws configure command:

# For Linux and MacOS
    #export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY
    #export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_ACCESS_KEY

    # For PowerShell
    #$env:AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
    #$env:AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"


4) Navigate to the desired service directory within the repository.

5) Run terraform init to initialize the Terraform workspace.

6) Run terraform plan to review the planned infrastructure changes.

7) Run terraform apply to apply the Terraform configurations and provision the AWS resources.

8) To store the state file in cloud S3, deploy the "backend" folder code for s3 backend config and s3 bucket creation, you can run "backend" folder initially so the S3 bucket is created & stores the state file and then deploy the rest of code.