#! /bin/bash
sudo yum update -y
sudo amazon-linux-extras enable php8.0
sudo yum clean metadata
yum install -y unzip curl php php-mysqlnd nginx
sudo systemctl start php-fpm
sudo systemctl enable php-fpm
sudo systemctl start nginx
sudo systemctl enable nginx

# Configure NGINX to process PHP
sed -i '/location \/ {/!b;n;c\        index  index.php index.html index.htm;' /etc/nginx/nginx.conf
cat >> /etc/nginx/nginx.conf << 'EOCONFIG'

    location ~ \.php$ {
        root           /usr/share/nginx/html;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
EOCONFIG

aws s3 cp s3://${s3_bucket_name}/website/index.php /usr/share/nginx/html/index.php
aws s3 cp s3://${s3_bucket_name}/website/Terracloud.png /usr/share/nginx/html/Terracloud.png
systemctl restart nginx


# Fetch instance ID and other metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# Set the instance name based on the stack ID, availability zone, and instance ID
INSTANCE_NAME="${var.Instance_Name}-$${INSTANCE_ID}"

# Tag the instance with the unique name
/usr/local/bin/aws  ec2 create-tags --resources $INSTANCE_ID --tags Key=Name,Value=$INSTANCE_NAME --region us-east-1

