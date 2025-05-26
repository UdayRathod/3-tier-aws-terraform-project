terraform {

  backend "s3" {
    bucket       = "s3-bucket-terraform-terracloud-state"
    use_lockfile = true
    key          = "terraform-state.tf"
    region       = "us-east-1"

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


  }
}

