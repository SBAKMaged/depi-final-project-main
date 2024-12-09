#!/bin/bash
set -x 

# Update and install necessary packages
apt-get update && apt-get install -y jq openssh-client  git

# Fetch IP addresses and keys from output.json
PUBLIC_IP_1=$(jq -r '.ec2_public_ip_az1_from_module.value' infrastructure/output.json)
PRIVATE_IP_1=$(jq -r '.ec2_private_ip_az1_from_module.value' infrastructure/output.json)
PRIVATE_IP_2=$(jq -r '.ec2_private_ip_az2_from_module.value' infrastructure/output.json)
private_key=$(jq -r '.private_key.value' infrastructure/output.json)
public_key=$(jq -r '.public_key.value' infrastructure/output.json)

# Save the private key to a file
echo "$private_key" > private_key.pem
chmod 600 private_key.pem


# Debug: Show the content of output.json and list the private key
cat infrastructure/output.json
ls -la private_key.pem

# SSH into the public EC2 instance
ssh -i private_key.pem -o StrictHostKeyChecking=no ubuntu@$PUBLIC_IP_1 <<EOF
  # Create private key file for SSH to private instances
  echo "$private_key" > ~/private_key.pem
  chmod 600 ~/private_key.pem
  

  # Ensure sudoers file exists and is correctly configured
  sudo touch /etc/sudoers.d/ubuntu
  echo "ubuntu ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ubuntu
  sudo chmod 440 /etc/sudoers.d/ubuntu
  sudo cat /etc/sudoers.d/ubuntu

  # Set variables for private IPs
  PRIVATE_IP_1="$PRIVATE_IP_1"
  PRIVATE_IP_2="$PRIVATE_IP_2"
  public_key="$public_key"

  # Loop through private IPs to set up the environment on each private instance
  for ip in "\$PRIVATE_IP_1" "\$PRIVATE_IP_2"; do
    echo "Setting up SSH on \$ip"
    
    # Directly configure sudoers file on private instances
    ssh -t -i private_key.pem -o StrictHostKeyChecking=no ubuntu@\$ip "echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ubuntu"
    ssh -t -i ~/private_key.pem -o StrictHostKeyChecking=no ubuntu@\$ip <<EON
      sudo chmod 440 /etc/sudoers.d/ubuntu
      mkdir -p ~/.ssh
      echo "\$public_key" | sudo tee -a ~/.ssh/authorized_keys
      chmod 700 ~/.ssh
      chmod 600 ~/.ssh/authorized_keys
EON
  done

EOF

ssh -i private_key.pem -o StrictHostKeyChecking=no ubuntu@$PUBLIC_IP_1 "
  # Create private key file for SSH to private instances
  # Clone the project repository
  git clone https://gitlab.com/asmaa18/depi-final-project.git || echo "Already cloned" &&
  cd /home/ubuntu/depi-final-project/deployment&&

  # Create Ansible inventory file 
  echo "[private_ec2s]" > inventory.yml &&
  echo "\$PRIVATE_IP_1" >> inventory.yml &&
  echo "\$PRIVATE_IP_2" >> inventory.yml &&
  cat inventory.yml &&
  
  while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
      sleep 5
  done
  apt-get update &&  apt-get install -y ansible
  

  ansible-playbook -i inventory.yml deployment/deployment_playbook.yml --private-key=~/private_key.pem --user=ubuntu"
