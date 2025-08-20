#!/bin/bash

# Update system
yum update -y

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Install other useful tools
yum install -y htop git wget curl unzip

# Set up user
if ! id "${ec2_username}" &>/dev/null; then
    useradd -m ${ec2_username}
    echo "${ec2_username}:${ec2_password}" | chpasswd
    usermod -aG wheel ${ec2_username}
fi

# Install Docker
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ${ec2_username}

# Install Node.js (latest LTS)
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
yum install -y nodejs

# Install Python 3 and pip
yum install -y python3 python3-pip

# Create application directory
mkdir -p /opt/myapp
chown ${ec2_username}:${ec2_username} /opt/myapp

# Create a sample script to test AWS integration
cat > /opt/myapp/test_aws.sh << 'EOF'
#!/bin/bash
echo "Testing AWS CLI access..."
aws sts get-caller-identity

echo "Testing S3 access..."
aws s3 ls s3://${s3_bucket_name}/

echo "Testing Secrets Manager access..."
aws secretsmanager list-secrets --region us-east-1
EOF

chmod +x /opt/myapp/test_aws.sh
chown ${ec2_username}:${ec2_username} /opt/myapp/test_aws.sh

# Create a sample Python script to retrieve secrets
cat > /opt/myapp/get_secrets.py << 'EOF'
#!/usr/bin/env python3
import boto3
import json
from botocore.exceptions import ClientError

def get_secret(secret_name, region_name="us-east-1"):
    """Retrieve a secret from AWS Secrets Manager"""
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(SecretId=secret_name)
        secret = get_secret_value_response['SecretString']
        return json.loads(secret)
    except ClientError as e:
        print(f"Error retrieving secret {secret_name}: {e}")
        return None

if __name__ == "__main__":
    # List all secrets
    client = boto3.client('secretsmanager', region_name='us-east-1')
    secrets = client.list_secrets()
    
    print("Available secrets:")
    for secret in secrets['SecretList']:
        print(f"- {secret['Name']}")
        
    # Example: Get EC2 credentials
    ec2_creds = get_secret('terraform-demo-ec2-credentials')
    if ec2_creds:
        print(f"\nEC2 Username: {ec2_creds.get('username', 'N/A')}")
EOF

chmod +x /opt/myapp/get_secrets.py
chown ${ec2_username}:${ec2_username} /opt/myapp/get_secrets.py

# Install required Python packages
pip3 install boto3

# Create systemd service for a sample application
cat > /etc/systemd/system/myapp.service << 'EOF'
[Unit]
Description=My Application
After=network.target

[Service]
Type=simple
User=${ec2_username}
WorkingDirectory=/opt/myapp
ExecStart=/usr/bin/python3 /opt/myapp/get_secrets.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable but don't start the service (for demonstration)
systemctl daemon-reload
systemctl enable myapp

# Create a welcome message
cat > /home/${ec2_username}/README.txt << 'EOF'
Welcome to your AWS EC2 instance!

This instance has been configured with:
- AWS CLI v2
- Docker
- Node.js (LTS)
- Python 3 with boto3

Sample scripts available in /opt/myapp/:
- test_aws.sh: Test AWS CLI access
- get_secrets.py: Retrieve secrets from AWS Secrets Manager

Your credentials are stored securely in AWS Secrets Manager.
Use the AWS CLI or boto3 to retrieve them programmatically.

To test AWS access, run:
  /opt/myapp/test_aws.sh

To retrieve secrets, run:
  python3 /opt/myapp/get_secrets.py
EOF

chown ${ec2_username}:${ec2_username} /home/${ec2_username}/README.txt

# Signal completion
echo "User data script completed successfully" > /var/log/user-data.log
