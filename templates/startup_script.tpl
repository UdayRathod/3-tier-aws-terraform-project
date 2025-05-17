#! /bin/bash
sudo yum update -y
sudo yum install -y unzip curl
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
aws s3 cp s3://${s3_bucket_name}/website/index.html /home/ec2-user/index.html
aws s3 cp s3://${s3_bucket_name}/website/Terracloud.png /home/ec2-user/Terracloud.png
sudo rm /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/Terracloud.png /usr/share/nginx/html/Terracloud.png
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
# Fetch instance ID and other metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# Set the instance name based on the stack ID, availability zone, and instance ID
INSTANCE_NAME="${var.Instance_Name}-$${INSTANCE_ID}"

# Tag the instance with the unique name
/usr/local/bin/aws  ec2 create-tags --resources $INSTANCE_ID --tags Key=Name,Value=$INSTANCE_NAME --region us-east-1

