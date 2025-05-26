# aws-terraform-project
Repo for highly available, scalable php web facing application deployed on AWS using terraform.

AWS Services used: 
AWS VPC
AWS Load balancer for Presentation layer facing web.
AWS Autoscaling group for handling and hosting the ngnix,php code.
AWS RDS for storing the data for the php application.
AWS S3 for storing the userdata script and the applications dependencies like the php code & terracloud image, also another S3 is created for storing the Load balancer logs.


Terraform resources:
VPC module from terraform registry.
S3 module created locally.
Variables for storing the variable values.
terraform.tf.vars for holding some of the variable values.
Locals for TAGS.
Outputs for exporting the resources information created by module/resource block.
Templates folder holds the USER DATA script which will be used the autoscaling for launching instances.
Website folder for sotring the php application code & our company logo.
Backend configuration block for storing the state file in S3.


To run this code:

1) First connnect to your AWS account by one of the below methos:
    #Provide your AWS creds directly in backend conf :
    #AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY
    #AWS_SECRET_ACCESS_KEY=YOUR_SECRET_ACCESS_KEY

    #OR you can use Env variables :
    # For Linux and MacOS
    #export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY
    #export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_ACCESS_KEY

    # For PowerShell
    #$env:AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
    #$env:AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"

    #OR you can create a profile in aws_credentails file and pass this profile as an argument here

    #OR you can pass the AWS access key & secret key creds during the init command with --flag

2) Do the Terraform initilization & Sanity checks by command: terraform init, terraform fmt -recursive, terraform validate

3) Plan the code: terraform plan

4) Deploy the code: terraform apply

5) To destroy everything Terraform created: terraform destroy

6) To store the state file in cloud S3, deploy the backend folder code for s3 backend config and s3 bucket creation, you can run this folder    initially so the S3 bcuket is created & stores the state file and then deploy the rest of code.

