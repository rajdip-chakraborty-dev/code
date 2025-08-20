#!/bin/bash

# Update system
apt-get update && apt-get upgrade -y

# Install Google Cloud SDK
curl https://sdk.cloud.google.com | bash
exec -l $SHELL

# Install other useful tools
apt-get install -y htop git wget curl unzip jq python3-pip

# Install Docker
apt-get install -y docker.io
systemctl start docker
systemctl enable docker

# Install Node.js (latest LTS)
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs

# Set up user
if ! id "${vm_username}" &>/dev/null; then
    useradd -m -s /bin/bash ${vm_username}
    echo "${vm_username}:${vm_password}" | chpasswd
    usermod -aG sudo ${vm_username}
    usermod -aG docker ${vm_username}
fi

# Create application directory
mkdir -p /opt/myapp
chown ${vm_username}:${vm_username} /opt/myapp

# Create a sample script to test GCP integration
cat > /opt/myapp/test_gcp.sh << 'EOF'
#!/bin/bash
echo "Testing gcloud CLI access..."
gcloud auth list

echo "Testing Cloud Storage access..."
gsutil ls gs://${bucket_name}/

echo "Testing KMS access..."
gcloud kms keys list --location=us-central1 --keyring=${keyring_name}
EOF

chmod +x /opt/myapp/test_gcp.sh
chown ${vm_username}:${vm_username} /opt/myapp/test_gcp.sh

# Create a sample Python script to decrypt KMS secrets
cat > /opt/myapp/decrypt_secrets.py << 'EOF'
#!/usr/bin/env python3
import base64
import json
from google.cloud import kms

def decrypt_secret(project_id, location, key_ring, key_name, ciphertext):
    """Decrypt a secret using Cloud KMS"""
    client = kms.KeyManagementServiceClient()
    
    # Build the key name
    key_name = client.crypto_key_path(project_id, location, key_ring, key_name)
    
    # Decrypt the ciphertext
    response = client.decrypt(request={"name": key_name, "ciphertext": ciphertext})
    
    # Decode the plaintext
    plaintext = response.plaintext.decode('utf-8')
    return json.loads(base64.b64decode(plaintext).decode('utf-8'))

if __name__ == "__main__":
    project_id = "${project_id}"
    location = "us-central1"
    key_ring = "terraform-demo-keyring"
    
    print("GCP KMS Secret Decryption Test")
    print("=" * 40)
    
    # This is a placeholder - in practice, you would get the ciphertext from your deployment
    print("To decrypt secrets, use the following pattern:")
    print("1. Get the ciphertext from your Terraform outputs")
    print("2. Call decrypt_secret() with the appropriate parameters")
    print("3. The function will return the decrypted JSON data")
    
    # Example usage (commented out as we don't have real ciphertext here):
    # vm_creds = decrypt_secret(project_id, location, key_ring, "vm-credentials-key", ciphertext_data)
    # print(f"VM Username: {vm_creds.get('username', 'N/A')}")
EOF

chmod +x /opt/myapp/decrypt_secrets.py
chown ${vm_username}:${vm_username} /opt/myapp/decrypt_secrets.py

# Install required Python packages
pip3 install google-cloud-kms google-cloud-storage

# Create systemd service for a sample application
cat > /etc/systemd/system/myapp.service << 'EOF'
[Unit]
Description=My Application
After=network.target

[Service]
Type=simple
User=${vm_username}
WorkingDirectory=/opt/myapp
ExecStart=/usr/bin/python3 /opt/myapp/decrypt_secrets.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable but don't start the service (for demonstration)
systemctl daemon-reload
systemctl enable myapp

# Create a welcome message
cat > /home/${vm_username}/README.txt << 'EOF'
Welcome to your GCP Compute Engine instance!

This instance has been configured with:
- Google Cloud SDK
- Docker
- Node.js (LTS)
- Python 3 with google-cloud-kms and google-cloud-storage

Sample scripts available in /opt/myapp/:
- test_gcp.sh: Test gcloud CLI access
- decrypt_secrets.py: Decrypt secrets from Cloud KMS

Your credentials are stored securely in Cloud KMS.
Use the gcloud CLI or Google Cloud client libraries to retrieve them.

To test GCP access, run:
  /opt/myapp/test_gcp.sh

To work with encrypted secrets, run:
  python3 /opt/myapp/decrypt_secrets.py

Service account is automatically configured for this instance.
EOF

chown ${vm_username}:${vm_username} /home/${vm_username}/README.txt

# Configure gcloud for the user
sudo -u ${vm_username} gcloud config set project ${project_id}

# Signal completion
echo "Startup script completed successfully" > /var/log/startup-script.log
